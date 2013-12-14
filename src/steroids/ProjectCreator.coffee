paths = require "./paths"

env = require("yeoman-generator")()

q = require "q"

class ProjectCreator

  constructor: ->

  generate: (targetDirectory) ->

    deferred = q.defer()

    env.plugins "node_modules", paths.npm
    # lookup for every namespaces, within the environments.paths and lookups
    env.lookup '*:*'
    #
    # # env.on 'end', ->
    #
    # env.on 'error', (err)->
    #   console.error 'Error', process.argv.slice(2).join(' '), '\n'
    #   console.error opts.debug ? err.stack : err.message
    #   process.exit(err.code || 1)
    #
    env.run "steroids:app #{targetDirectory}", ->
      deferred.resolve()

    return deferred.promise

module.exports = ProjectCreator
