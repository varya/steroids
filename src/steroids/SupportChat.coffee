open = require "open"

class SupportChat

  constructor: (@name) ->


  open: () ->
    encodedName = encodeURIComponent(@name)
    chatURL = "http://steroids.chat.appgyver.com?nickName=#{encodedName}"

    open(chatURL)


module.exports = SupportChat