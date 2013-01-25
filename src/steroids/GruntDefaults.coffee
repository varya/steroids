sass = require 'node-sass'
coffeelint = require 'coffeelint'
colorize = require "colorize"

defaultConfig = {}

registerDefaultTasks = (grunt)->
  grunt.registerTask 'steroids-default', [
    'steroids-clean-dist',
    'steroids-copy-www',
    'steroids-compile-sass',
    'steroids-copy-vendor',
    'steroids-generate-views',
    'steroids-compile-coffeescripts',
    'steroids-concat',
    'steroids-remove-dist-models'
  ]

  # Steroids Tasks & functions:
  buildDirectory            = path.join process.cwd(), "dist"
  buildViewsDirectory       = path.join buildDirectory, "views"
  buildModelsDirectory      = path.join buildDirectory, "models"
  buildcontrollersDirectory = path.join buildDirectory, "controllers"
  buildStylesheetsDirectory = path.join buildDirectory, "stylesheets"
  appDirectory              = path.join process.cwd(), "app"
  appViewsDirectory         = path.join appDirectory, "views"
  appModelsDirectory        = path.join appDirectory, "models"
  appControllersDirectory   = path.join appDirectory, "controllers"
  appLayoutsDirectory       = path.join appDirectory, "views", "layouts"
  vendorDirectory           = path.join process.cwd(), "vendor"
  wwwDirectory              = path.join process.cwd(), "www"

  compileCoffee = (filePath, baseDir, newDirPrefix)->
    if typeof(newDirPrefix) is "undefined"
      newDirPrefix = ""

      coffeeContent = grunt.file.read(filePath, "utf8").toString()
      errors = coffeelint.lint coffeeContent
      if errors.length > 0
        text = "#red[#{errors.length} errors in #underline[#{filePath}]]\n\n"
        for error in errors
          text += "#red[#{path.basename(filePath)}:#{error.lineNumber}] > #yellow[#{error.message if error.message?}] #green[#{'('+error.context+')' if error.context?}]\n\n"
          if error.line?
            text += "\n#{error.line}\n\n\n"
        console.error colorize.ansify("#{text}\n\nWhat would Richard Dean Anderson do?\n")

      try
        compiledSource = coffee.compile(grunt.file.read(filePath, "utf8").toString())
        fileBuildPath = filePath.replace(baseDir, path.join(buildDirectory, newDirPrefix)).replace /\.coffee/, ".js"
        grunt.file.write fileBuildPath, compiledSource
      catch err
        grunt.warn err

  compileSass = (filePath, callback)->
    sass.render(grunt.file.read(filePath, "utf8").toString(), (err, css)->
      if err
        text = "#red[Errors in #underline[#{filePath}]]\n\n"
        text += "#red[#{path.basename(filePath)}]#yellow[#{err}]"
        grunt.warn colorize.ansify(text)
      else
        cssFilePath = filePath.replace(path.extname(filePath), ".css")

        grunt.file.write cssFilePath, css
        fs.unlinkSync filePath

      callback()

    , {output_style: "compressed"})


  grunt.registerTask 'steroids-compile-coffeescripts',
    "Compiles coffeescripts from app/models/* app/controllers/* and vendor/appgyver/*",
    ()->
      for directory in [appModelsDirectory, appControllersDirectory]
        for filePath in grunt.file.expand(path.join(directory, "**", "*.coffee"))
          compileCoffee filePath, appDirectory

    for filePath in grunt.file.expand(path.join(vendorDirectory, "**", "*.coffee"))
      compileCoffee filePath, vendorDirectory, "vendor"

  grunt.registerTask 'steroids-concat',
    'Concatenate steroids project files in dist/',
    ()->
      jsArr = []

      for filePath in grunt.file.expand(grunt.file.expandFiles(path.join(buildModelsDirectory, "**", "*")))
        jsArr.push grunt.file.read(filePath, "utf8").toString()

      grunt.file.write path.join(buildModelsDirectory, "models.js"), jsArr.join("\n")

  grunt.registerTask 'steroids-copy-www',
    'Copy www/ content over dist/',
    ()->
      wrench.copyDirSyncRecursive wwwDirectory, buildDirectory, inflateSymlinks: true

  grunt.registerTask 'steroids-compile-sass',
    'Compile sass files in dist/stylesheets',
    ()->
      compileSass filePath, this.async() for filePath in grunt.file.expandFiles path.join(buildStylesheetsDirectory, "**", "*.sass")
      compileSass filePath, this.async() for filePath in grunt.file.expandFiles path.join(buildStylesheetsDirectory, "**", "*.scss")


  grunt.registerTask 'steroids-copy-vendor',
    'Copy vendor/ to dist/vendor',
    ()->
      for filePathPart in grunt.file.expandFiles(path.join(vendorDirectory,"**","*"))
        if !/\.coffee$/.test(path.basename(filePathPart))
          filePath = path.resolve filePathPart
          buildFilePath = path.resolve filePathPart.replace("vendor"+path.sep, "dist"+path.sep+"vendor"+path.sep)

          grunt.file.copy filePath, buildFilePath

  grunt.registerTask 'steroids-clean-dist',
    'Removes dist/ recursively and creates it again ',
    ()->
      wrench.rmdirSyncRecursive buildDirectory, true
      grunt.file.mkdir buildDirectory

      for suffix in ["views", "models", "controllers", "vendor"]
        grunt.file.mkdir path.join(buildDirectory, suffix)

  grunt.registerTask 'steroids-remove-dist-models',
    'Remove single model files from build dir',
    ()->
      for filePath in grunt.file.expandFiles path.join(buildModelsDirectory, "**", "*")
        unless path.basename(filePath) is "models.js"
          fs.unlink filePath

  grunt.registerTask 'steroids-generate-views',
    'HTML files from app/layouts/application & app/**/* files',
    ()->
      viewDirectories = []

      # get each view folder (except layout)
      for dirPath in grunt.file.expandDirs(path.join(appViewsDirectory, "*"))
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

        for filePathPart in grunt.file.expand(path.join(viewDir, "**", "*"))
          filePath = path.resolve filePathPart
          buildFilePath = path.resolve filePathPart.replace("app"+path.sep, "dist"+path.sep)

          controllerName = path.basename(viewDir).replace(path.sep, "") + "Controller"
          yieldObj =
            view: grunt.file.read(filePath, "utf8")
            controller: controllerName

          # put layout+yields together
          yieldedFile = grunt.utils._.template(
            applicationLayoutFile.toString()
          )({ yield: yieldObj })

          # write the file
          grunt.file.mkdir path.dirname(buildFilePath)
          grunt.file.write buildFilePath, yieldedFile

module.exports =
  registerDefaultTasks: registerDefaultTasks
  defaultConfig: defaultConfig
