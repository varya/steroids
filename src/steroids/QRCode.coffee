open = require "open"

class QRCode

  constructor: (@options = {}) ->


  show: =>
    return if process.env.STEROIDS_TEST_RUN

    steroidsCli.debug "Opening URL http://127.0.0.1:#{@options.port}/__appgyver/connect/qrcode.html?qrCodeData=#{encodeURIComponent(@options.data)} in default web browser."
    open "http://127.0.0.1:#{@options.port}/__appgyver/connect/qrcode.html?qrCodeData=#{encodeURIComponent(@options.data)}"

  @showLocal: (options={}) =>
    interfaces = steroidsCli.server.interfaces()
    ips = steroidsCli.server.ipAddresses()

    encodedJSONIPs = encodeURIComponent(JSON.stringify(ips))
    encodedPort = encodeURIComponent(options.port)

    code = new QRCode
      data: "appgyver://?ips=#{encodedJSONIPs}&port=#{encodedPort}"
      port: options.port

    code.show()





module.exports = QRCode
