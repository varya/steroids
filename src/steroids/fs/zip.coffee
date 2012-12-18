path = require "path"
childProcess = require('child_process') #.exec

class Zip
  constructor: (@from, @to, @filesOutsideSourceDirectory)->

  create: (callback)->
    @zipRecursively callback

  zipRecursively: (callback)->
    child = childProcess.exec "zip -R -FS #{@to} ./**/* ./*", {
      cwd: @from
    }, (error, stdout, stderr)->
      throw error if error?
      console.log "#{stdout}"

      timestamp = (new Date).getTime()
      callback.apply(null, [timestamp]) if callback?

module.exports = Zip