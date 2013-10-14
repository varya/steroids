disabledSass = /v0\.11/.test(process.version)
if disabledSass
  console.log "WARNING: node-sass module is not compatible with node version 0.11 yet. SASS compilation is disabled."
else
  sass = require 'node-sass'
coffeelint = require 'coffeelint'
colorize = require "colorize"
events = require "events"

Paths = require "./paths"


fs = require "fs"
wrench = require "wrench"
coffee = require "coffee-script"

defaultConfig = {}

registerDefaultTasks = (grunt)->
  grunt.registerTask 'steroids-default', [
    'steroids-clean-dist',
    'steroids-build-controllers',
    'steroids-build-models',
    'steroids-build-statics',
    'steroids-compile-coffeescript-files',
    'steroids-compile-sass-files',
    'steroids-compile-models',
    'steroids-compile-views',
    'steroids-cordova-merges'
  ]

  # -------------------------------------------
  # CLEAN TASKS

  grunt.registerTask 'steroids-clean-dist', 'Removes dist/ recursively and creates it again ', ->
    wrench.rmdirSyncRecursive Paths.application.distDir, true
    grunt.file.mkdir Paths.application.distDir

  # -------------------------------------------
  # BUILD TASKS

  copyFilesSyncRecursive = (options)->
    grunt.verbose.writeln "Copying files from #{options.sourcePath} to #{options.destinationDir} using #{options.relativeDir} as basedir"

    for filePath in grunt.file.expand options.sourcePath when fs.statSync(filePath).isFile()
      grunt.verbose.writeln "Copying file #{filePath}"

      relativePath = path.relative options.relativeDir, filePath
      destinationPath = path.join options.destinationDir, relativePath

      grunt.verbose.writeln "Copying file #{filePath} to #{destinationPath}"

      grunt.file.copy filePath, destinationPath

  grunt.registerTask 'steroids-build-controllers', "Build controllers", ->
    copyFilesSyncRecursive {
      sourcePath: Paths.application.sources.controllers
      destinationDir: Paths.application.distDir
      relativeDir: Paths.application.appDir
    }

  grunt.registerTask 'steroids-build-models', "Build models", ->
    copyFilesSyncRecursive {
      sourcePath: Paths.application.sources.models
      destinationDir: Paths.application.distDir
      relativeDir: Paths.application.appDir
    }

  grunt.registerTask 'steroids-build-statics', "Build static files", ->
    copyFilesSyncRecursive {
      sourcePath: Paths.application.sources.statics
      destinationDir: Paths.application.distDir
      relativeDir: Paths.application.sources.staticDir
    }

  # -------------------------------------------
  # COMPILE TASKS

  grunt.registerTask 'steroids-compile-coffeescript-files', "Compile built coffeescript files", ->
    grunt.verbose.writeln "Compiling coffeescripts #{Paths.application.compiles.coffeescripts}"
    coffeeFiles = grunt.file.expand Paths.application.compiles.coffeescripts

    for filePath in coffeeFiles
      grunt.log.writeln colorize.ansify(" #yellow[Compiling CoffeeScript:] #reset[#{filePath}]")

      coffeeFile = new CoffeeScriptFile(filePath: filePath)

      coffeeFile.on "compiled", =>
        fs.unlinkSync filePath

      coffeeFile.compile()

  grunt.registerTask 'steroids-compile-sass-files', "Compile build sass files", ->
    if disabledSass
      grunt.log.writeln colorize.ansify "#red[Skipping sass compile task. Module node-sass does not support currently installed node version.]"
      return true

    sassFiles = grunt.file.expand Paths.application.compiles.sassfiles
    scssFiles = grunt.file.expand Paths.application.compiles.scssfiles

    allFiles = sassFiles.concat(scssFiles)

    done = @async() if allFiles.length > 0

    for filePath, i in allFiles
      do (filePath, i)->
        grunt.log.writeln colorize.ansify(" #yellow[Compiling Sass:] #reset[#{filePath}]")

        sassFile = new SassFile(filePath: filePath)

        sassFile.on "compiled", =>
          # because lets support sass imports (when node-sass does..)
          if i+1 is allFiles.length
            fs.unlinkSync filePath for filePath in allFiles
            done()

        sassFile.compile()


  grunt.registerTask 'steroids-compile-models', "Compile models", ->
    javascripts = []
    sourceFiles = grunt.file.expand Paths.application.compiles.models

    for filePath in sourceFiles when fs.statSync(filePath).isFile()
      grunt.verbose.writeln "Compiling model file at #{filePath}"
      javascripts.push grunt.file.read(filePath, "utf8").toString()
      fs.unlinkSync filePath

    grunt.file.write Paths.application.compileProducts.models, javascripts.join("\n\n")

  class CoffeeScriptFile extends events.EventEmitter
    constructor: (@options)->
      @sourcePath = @options.filePath
      @destinationPath = @sourcePath.replace path.extname(@sourcePath), ".js"
      @contents = grunt.file.read(@sourcePath, "utf8").toString()

    compile: ()->
      @checkWithLint()

      if @lintErrors.length > 0
        @reportLintErrors()
        return false

      try
        compiledSource = coffee.compile(@contents)
        grunt.file.write @destinationPath, compiledSource
        @emit "compiled"
      catch err
        grunt.warn err

    checkWithLint: ->
      @lintErrors = coffeelint.lint @contents,
        max_line_length:
          level: "ignore"
        no_backticks:
          level: "ignore"

    reportLintErrors: ->
      text = "#red[#{@lintErrors.length} errors in #underline[#{@sourcePath}]]\n\n"

      for error in @lintErrors
        text += "#red[#{path.basename(@sourcePath)}:#{error.lineNumber}] > #yellow[#{error.message if error.message?}] #green[#{'('+error.context+')' if error.context?}]\n\n"
        if error.line?
          text += "\n#{error.line}\n\n\n"

      grunt.warn colorize.ansify text


  class SassFile extends events.EventEmitter
    constructor: (@options)->
      @sourcePath = @options.filePath
      @destinationPath = @sourcePath.replace path.extname(@sourcePath), ".css"
      @contents = grunt.file.read(@sourcePath, "utf8").toString()

    compile: ()->
      sassCallback = (err, css)=>
        if err
          text = "#red[Errors in #underline[#{@sourcePath}]]\n\n"
          text += "#red[#{path.basename(@sourcePath)}]#yellow[#{err}]"
          grunt.warn colorize.ansify(text)
        else
          grunt.file.write @destinationPath, css

        @emit "compiled"

      sass.render @contents, sassCallback,
        output_style: "compressed"


  grunt.registerTask 'steroids-compile-views', "Compile views", ->

    projectDirectory          = Paths.applicationDir

    buildDirectory            = path.join projectDirectory, "dist"
    buildViewsDirectory       = path.join buildDirectory, "views"
    buildModelsDirectory      = path.join buildDirectory, "models"
    buildcontrollersDirectory = path.join buildDirectory, "controllers"
    buildStylesheetsDirectory = path.join buildDirectory, "stylesheets"

    appDirectory              = path.join projectDirectory, "app"
    appViewsDirectory         = path.join appDirectory, "views"
    appModelsDirectory        = path.join appDirectory, "models"
    appControllersDirectory   = path.join appDirectory, "controllers"
    appLayoutsDirectory       = path.join appDirectory, "views", "layouts"

    vendorDirectory           = path.join projectDirectory, "vendor"
    wwwDirectory              = path.join projectDirectory, "www"

    viewDirectories = []

    # get each view folder (except layout)
    for dirPath in grunt.file.expand(path.join(appViewsDirectory, "*")) when fs.statSync(dirPath).isDirectory()
      basePath = path.basename(dirPath)
      unless basePath is "layouts" + path.sep or basePath is "layouts"
        viewDirectories.push dirPath
        grunt.file.mkdir path.join(buildViewsDirectory, path.basename(dirPath))


    for viewDir in viewDirectories
      # resolve layout file for these views
      layoutFileName = "";

      # Some machines report folder/ as basename while others do not
      viewBasename = path.basename viewDir

      unless viewBasename.indexOf(path.sep) is -1
        viewBasename = viewBasename.replace path.sep, ""

      layoutFileName = "#{viewBasename}.html"

      layoutFilePath = path.join appLayoutsDirectory, layoutFileName

      unless fs.existsSync(layoutFilePath)
        layoutFilePath = path.join appLayoutsDirectory, "application.html"

      applicationLayoutFile = grunt.file.read layoutFilePath, "utf8"

      for filePathPart in grunt.file.expand(path.join(viewDir, "**", "*")) when fs.statSync(filePathPart).isFile()

        filePath = path.resolve filePathPart

        buildFilePath = path.resolve filePathPart.replace("app"+path.sep, "dist"+path.sep)

        resourceDirName = filePathPart.split("/").splice(-2,1)[0]

        buildFilePath = path.join(buildDirectory, "views", resourceDirName, path.basename(filePathPart))

        # skip "partial" files that begin with underscore
        if /^_/.test path.basename(filePath)
          yieldedFile = grunt.file.read(filePath, "utf8")
        else

          controllerName = path.basename(viewDir).replace(path.sep, "")
          controllerBasenameWithPath = path.join(buildcontrollersDirectory, "#{controllerName}")



          unless fs.existsSync "#{controllerBasenameWithPath}.js"
            warningMessage = "#red[Warning:] There is no controller for resource '#{controllerName}'.  Add file app/controllers/#{controllerName}.{js|coffee}"
            grunt.log.writeln colorize.ansify(warningMessage)

          yieldObj =
            view: grunt.file.read(filePath, "utf8")
            controller: controllerName

          # put layout+yields together
          yieldedFile = grunt.util._.template(
            applicationLayoutFile.toString()
          )({ yield: yieldObj })

        # write the file
        grunt.file.mkdir path.dirname(buildFilePath)
        grunt.file.write buildFilePath, yieldedFile

  grunt.registerTask 'steroids-cordova-merges', "Handle cordova merges", ->

    projectDirectory  = Paths.applicationDir
    distDirectory     = Paths.application.distDir

    mergesDirectory         = path.join projectDirectory, "merges"
    androidMergesDirectory  = path.join mergesDirectory, "android"
    iosMergesDirectory      = path.join mergesDirectory, "ios"

    mergesExist = fs.existsSync mergesDirectory
    if mergesExist
      # android
      for filePath in grunt.file.expand(path.join(androidMergesDirectory, "*")) when fs.statSync(filePath).isFile()
        filePath = path.normalize(filePath) # fix windows path syntax
        grunt.log.writeln colorize.ansify(" #yellow[Copying Android Merges:]")

        # setup proper paths and filenames to steroids android comptible syntax: index.html to index.android.html
        origFileName  = path.basename filePath
        origFileExtension = path.extname origFileName
        androidPrefixedExtension = ".android#{origFileExtension}"
        androidFileName = origFileName.replace origFileExtension, androidPrefixedExtension
        filePathInDist = filePath.replace(androidMergesDirectory, distDirectory)
        filePathInDistWithAndroidExtensionPrefix = filePathInDist.replace(origFileName, androidFileName)

        grunt.log.writeln colorize.ansify("  #{filePath.replace(androidMergesDirectory+'/', '')} -> dist#{filePathInDistWithAndroidExtensionPrefix.replace(distDirectory, '')}")

        if fs.existsSync filePathInDistWithAndroidExtensionPrefix
          grunt.log.writeln colorize.ansify("   #red[Overwriting:] #reset[dist#{filePathInDistWithAndroidExtensionPrefix.replace(distDirectory, '')}]")

        fs.writeFileSync filePathInDistWithAndroidExtensionPrefix, fs.readFileSync(filePath)

      # ios
      for filePath in grunt.file.expand(path.join(iosMergesDirectory, "*")) when fs.statSync(filePath).isFile()
        filePath = path.normalize(filePath) # fix windows path syntax
        grunt.log.writeln colorize.ansify(" #yellow[Copying iOS Merges:]")

        # setup proper paths for file copy
        filePathInDist = filePath.replace(iosMergesDirectory, distDirectory)

        grunt.log.writeln colorize.ansify("  #{filePath.replace(iosMergesDirectory+'/', '')} -> dist#{filePathInDist.replace(distDirectory, '')}")

        if fs.existsSync filePathInDist
          grunt.log.writeln colorize.ansify("   #red[Overwriting:] #reset[dist#{filePathInDist.replace(distDirectory, '')}]")

        fs.writeFileSync filePathInDist, fs.readFileSync(filePath)


module.exports =
  registerDefaultTasks: registerDefaultTasks
  defaultConfig: defaultConfig
