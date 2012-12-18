watch = require "watch"

class Watcher

  constructor:(@options) ->

  watch: (path)=>
    watch.watchTree path, (f, curr, prev)=>
      if typeof f is "object" and prev is null and curr is null
      else if prev is null
        @options.emitter.emit @options.onChange, f
      else if curr.nlink is 0
        @options.emitter.emit @options.onChange, f
      else
        @options.emitter.emit @options.onChange, f

    console.log "Monitoring directory: #{path}"

module.exports = Watcher
