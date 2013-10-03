steroids = require "../../steroids"

path = require "path"
paths = require "../paths"
fs = require "fs"
util = require "util"
Bower = require "../Bower"
env = require("yeoman-generator")()

module.exports = class NgResource

  constructor: ->
    @args = "steroids:ng-resource"
    @opts = {}

  generate: ->
    # register each built-in generator individually
    env.plugins "node_modules", paths.npm

    # alias any single namespace to `*:all` and `webapp` namespace specifically to webapp:app.
    env.alias /^([^:]+)$/, '$1:all'
    env.alias /^([^:]+)$/, '$1:app'

    # lookup for every namespaces, within the environments.paths and lookups
    env.lookup '*:*'

    # env.on 'end', ->

    #
    # env.on 'error', (err)->
    #   console.error 'Error', process.argv.slice(2).join(' '), '\n'
    #   console.error opts.debug ? err.stack : err.message
    #   process.exit(err.code || 1)

    # Note: at some point, nopt needs to know about the generator options, the
    # one that will be triggered by the below args. Maybe the nopt parsing
    # should be done internally, from the args.
    env.run @args, @opts

    #Bower.update
