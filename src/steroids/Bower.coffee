class Bower
  constructor: ->

  update: (cb)->
    bower = require 'bower'
    bower = bower.commands.install.line("jep", "jep", "install")

    bower.on "data", (data)->
      console.log data if data

    bower.on "end", (data)=>
      console.log data if data

    bower.on "error", (err)=>
      process.stderr.write err.message

module.exports = Bower
