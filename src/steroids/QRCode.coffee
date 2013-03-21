open = require "open"

class QRCode

  constructor: (@data) ->


  show: =>
    return if process.env.STEROIDS_TEST_RUN

    open "http://localhost:4567/qrcode.html?qrCodeData=#{encodeURIComponent(@data)}"

  @showLocal: =>
    interfaces = steroidsCli.server.interfaces()
    ips = steroidsCli.server.ipAddresses()

    code = new QRCode("appgyver://?ips=#{encodeURIComponent(JSON.stringify(ips))}")
    code.show()





module.exports = QRCode
