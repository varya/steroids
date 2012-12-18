path = require "path"
childProcess = require('child_process') #.exec

class Zip
  constructor: (@from, @to, @filesOutsideSourceDirectory)->

  create: (callback)->
    @zipRecursively callback

  zipRecursively: (callback)->
    childProcess.exec "echo LOL", (err, stdout)->
      console.log err
      console.log stdout

    #console.log "TO: #{@to} FROM: #{@from}"
    #child = childProcess.exec "zip -R -FS #{@to} ./**/* ./*", {
    #  cwd: @from
    #}, (error, stdout, stderr)->
    #  console.log "#{error}"
    #  console.log "#{stdout}"
    #  console.log "#{stderr}"
    #  timestamp = (new Date).getTime()
    #  callback.apply(null, [timestamp]) if callback?
    ##console.log child

module.exports = Zip