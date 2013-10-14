path = require "path"
Paths = require "./../paths"
childProcess = require "child_process"
wrench = require "wrench"
fs = require "fs"

class Zip
  constructor: (@from, @to, @filesOutsideSourceDirectory)->

  create: (callback)->
    @zipRecursively callback

  zipRecursively: (callback)->

    # use 7zip on windows
    if process.platform is "win32"
      # delete the zip file first
      if fs.existsSync @to
        fs.unlinkSync @to

      zipCommand = path.join Paths.vendor, "7zip", "7za"
      fromPath = path.join @from, "*"
      zipArgs = ["a", @to, fromPath]
      childProcess.spawn zipCommand, zipArgs
    # use OS supplied zip on OSX/Linux
    else

      child = childProcess.exec "find . -print | zip -@ -FS #{@to}", {
        cwd: @from
      }, (error, stdout, stderr)->
        throw error if error?
        #console.log "#{stdout}"

        timestamp = (new Date).getTime()
        callback.apply(null, [timestamp]) if callback?

module.exports = Zip