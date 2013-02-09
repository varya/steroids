open = require "open"

class QRCode

  constructor: (@data) ->


  show: =>
    return if process.env.STEROIDS_TEST_RUN
    open "http://localhost:4567/qrcode.html?qrCodeData=#{encodeURIComponent(@data)}"



module.exports = QRCode
