open = require "open"

class SupportChat

  constructor: () ->


  open: () ->
    chatURL = "http://discussion.appgyver.com"

    open(chatURL)


module.exports = SupportChat