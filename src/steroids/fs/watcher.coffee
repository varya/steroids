watchr = require "watchr"

class Watcher

  constructor:(@options) ->

  watch: (path)=>
    watchr.watch
      paths: [path]
      listeners:
        change: (changeType, filePath, fileCurrentStat, filePreviousStat) =>
          switch changeType
            when "delete"
              @options.onDelete(filePath, fileCurrentStat, filePreviousStat)
            when "create"
              @options.onCreate(filePath, fileCurrentStat, filePreviousStat)
            when "update"
              @options.onUpdate(filePath, fileCurrentStat, filePreviousStat)

module.exports = Watcher
