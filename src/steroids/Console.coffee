# nesh = require "nesh"
#
#

#
# nesh.config.load()

# Load CoffeeScript
# nesh.loadLanguage('coffee')

# Start the REPL
# nesh.start opts, (err) ->
#
#   console.log "juu", nesh.repl.commands
#   console.log "jaa", nesh.repl.rli
#
#   if (err)
#     nesh.log.error(err);
#


  #if code and code.length and code isnt '.history' and lastLine isnt code
  #    # Save the latest command in the file
  #    fs.write fd, "#{code}\n"
  #    lastLine = code


nesh = require "nesh"
util = require 'util'

opts =
  welcome: "--[ steroids console ]--"
  prompt: '> '

nesh.init false, =>
  nesh.start opts, (err) ->
    console.log nesh.plugins

# myPlugin =
#     name: "eval"
#     description: "Some description here"
#     setup: (context) ->
#         {defaults} = context
#         nesh.log.info 'Setting up my plugin! Defaults:'
#         #nesh.log.info util.inspect defaults
#
#     preStart: (context) ->
#         {options} = context
#         nesh.log.info 'About to start the interpreter with these options:'
#         #nesh.log.info util.inspect options
#
#     postStart: (context) ->
#         # {repl} = context
#         # nesh.log.info 'Interpreter started! REPL:'
#         #nesh.log.info util.inspect repl
#
#       {repl} = context
#       if repl.opts.evalData
#         log.debug 'Evaluating code in the REPL'
#       # if global is repl.context
# #       vm.runInThisContext repl.opts.evalData
# #       else
# #       vm.runInContext repl.opts.evalData, repl.context
#
# nesh.loadPlugin myPlugin, (err) ->
#   nesh.log.error err if err
#
#   nesh.start opts, (err) ->
#     nesh.log.error err if err
