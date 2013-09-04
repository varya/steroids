path = require "path"
childProcess = require "child_process"
archiver = require "archiver"
wrench = require "wrench"
fs = require "fs"

class Zip
  constructor: (@from, @to, @filesOutsideSourceDirectory)->

  create: (callback)->
    @zipRecursively callback

  zipRecursively: (callback)->

    # use node-archiver on windows
    if process.env.OS is "Windows_NT"
      files = wrench.readdirSyncRecursive @from
      fileObjs = ({name: file, path: path.join(@from, file)} for file in files when fs.lstatSync(path.join(@from, file)).isFile())

      archive = archiver "zip"
      currentDate = new Date()

      stream = fs.createWriteStream @to

      archive.pipe stream

      readNext = ()=>
        currentFile = fileObjs.pop()
        readStream = fs.createReadStream(currentFile.path)
        readStream.on "close", ()=>
          if fileObjs.length isnt 0
            #console.log "#{currentFile.name} was read to archive.."
            readNext()
          else
            #console.log "Finalizing archive.."
            archive.finalize()
            #console.log "Finalized archive to: #{@to}"
            timestamp = (new Date).getTime()
            callback.apply(null, [timestamp]) if callback?

        archive.append readStream, { name: currentFile.name, date: currentDate}

      readNext() if fileObjs.length > 0

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