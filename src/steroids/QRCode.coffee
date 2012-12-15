open = require "open"

class QRCode

  constructor: (@data) ->


  show: =>
    open "http://localhost:4567/qrcode.html?qrCodeData=#{encodeURIComponent(@data)}"



module.exports = QRCode