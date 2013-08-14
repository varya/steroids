fs = require "fs"
wd = require "wd"
should = require "should" # TODO: jasmine-node?
util = require "util"
request = require "request"

class AppiumRunner
  constructor: (@options)->
    throw "Simulator app path not defined" unless @options.simulatorPath?

  wrapper: (specString)=>
    wrap = """
      var wd = require('wd')
        , should = require('should')
        , appURL = '#{@options.simulatorPath}';

      // Instantiate a new browser session
      var browser = wd.remote('localhost', 4723);

      // See whats going on
      browser.on('status', function(info) {
        console.log('\x1b[36m%s\x1b[0m', info);
      });

      browser.on('command', function(meth, path, data) {
        console.log(' > \x1b[33m%s\x1b[0m: %s', meth, path, data || '');
      });

      // Run the test
      browser
        .chain()
        .init({
          device: 'iPhone Simulator'
          , name: 'my test app'
          , platform:'Mac 10.8'
          , app: appURL
          , version: ''
          , browserName: ''
        })
        .windowHandles(function(err, handles) {
          #{specString}
        });
    """
    return wrap

  runTest: (options)->
    throw "path required" unless options.path?
    wait = true
    waiter = setInterval ()=>
      util.log "Waiting for Appium.io service for #{options.path} test run.."
      request "http://localhost:4723", (err, response, body)=>

        if body is "That URL did not map to a valid JSONWP resource"
          util.log "Appium.io service is alive, running #{options.path} test.."

          wait = false
          clearInterval waiter if waiter?
          if fs.existsSync options.path
            specString = @wrapper(fs.readFileSync(options.path, "utf8"))
            eval specString
    , 1000

module.exports = AppiumRunner