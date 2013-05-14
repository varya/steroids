open = require "open"

class SupportChat

  constructor: (@name) ->


  open: () ->
    encodedName = encodeURIComponent(@name)
    chatURL = "https://ninchat.com/embed?name=#{encodedName}#/c/10opaevm008"

    open(chatURL)


module.exports = SupportChat