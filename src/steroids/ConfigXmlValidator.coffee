fs = require "fs"
paths = require "./paths"
Q = require "q"
chalk = require "chalk"
Help = require "./Help"
xml2js = require "xml2js"

module.exports = class ConfigXmlValidator

  checkIos: ->

    deferred = Q.defer()

    parser = new xml2js.Parser()

    fs.exists paths.application.configs.configIosXml, (exists) ->
      if !exists
        deferred.resolve()
      else
        fs.readFile paths.application.configs.configIosXml, (err, data) ->
          parser.parseString data, (err, result) ->
            if result is undefined
              msg =
                """
                #{chalk.red.bold("config.ios.xml is not valid XML")}
                #{chalk.red.bold("==============================")}

                It looks like your #{chalk.bold("www/config.ios.xml")} file is not valid XML. Please ensure its validity.

                If the file is beyond recovery, you can create a new project with

                  #{chalk.bold("$ steroids create projectName")}

                and copy the #{chalk.bold("www/config.ios.xml")} over from the new project.

                """
              deferred.reject msg
            else if !result.widget?
              msg =
                """
                  #{chalk.red.bold("No <widget> root element found in config.ios.xml")}
                  #{chalk.red.bold("================================================")}

                  It looks like your #{chalk.bold("www/config.ios.xml")} file has no #{chalk.bold("<widget>")} element at its root.
                  This element is required for Steroids to function.

                  Please ensure that your project's #{chalk.bold("www/config.ios.xml")} is properly set up. You can run

                    #{chalk.bold("$ steroids create myProjectName")}

                  to create a new project to see how the #{chalk.bold("www/config.ios.xml")} file should look like.

                """
              deferred.reject msg
            else if result.widget.plugins?
              msg =
                """
                #{chalk.red.bold("<plugins> element found in config.ios.xml")}
                #{chalk.red.bold("=========================================")}

                It looks like your #{chalk.bold("www/config.ios.xml")} file has a #{chalk.bold("<plugins>")} element, which is deprecated as of Steroids
                CLI v3.1.0. This is likely because your project was built with a pre-3.1.0 Steroids CLI version.

                To get rid of this message, you need to remove all plugins from your #{chalk.bold("www/config.ios.xml")}. While you're at it,
                you should also upgrade your #{chalk.bold("www/config.ios.xml")} to match the new form introduced by Steroids CLI v3.1.0.

                To ensure we don't overwrite any of your custom configs, we won't upgrade your config file automatically.
                Instead, you should go through the migration steps at

                  #{chalk.underline("http://guides.appgyver.com/steroids/guides/steroids-js/cordova-3-1-migration")}

                """
              deferred.reject msg
            else
              deferred.resolve()

    return deferred.promise

  checkAndroid: ->

    deferred = Q.defer()

    parser = new xml2js.Parser()

    fs.exists paths.application.configs.configAndroidXml, (exists) ->
      if !exists
        deferred.resolve()
      else
        fs.readFile paths.application.configs.configAndroidXml, (err, data) ->
          parser.parseString data, (err, result) ->
            if result is undefined
              msg =
                """
                #{chalk.red.bold("config.android.xml is not valid XML")}
                #{chalk.red.bold("==============================")}

                It looks like your #{chalk.bold("www/config.android.xml")} file is not valid XML. Please ensure its validity.

                If the file is beyond recovery, you can create a new project with

                  #{chalk.bold("$ steroids create projectName")}

                and copy the #{chalk.bold("www/config.android.xml")} over from the new project.

                """
              deferred.reject msg
            else if !result.widget?
              msg =
                """
                  #{chalk.red.bold("No <widget> root element found in config.android.xml")}
                  #{chalk.red.bold("================================================")}

                  It looks like your #{chalk.bold("www/config.android.xml")} file has no #{chalk.bold("<widget>")} element at its root.
                  This is likely because your project was built with a pre-3.1.0 Steroids CLI version.

                  You need to replace your #{chalk.bold("www/config.android.xml")} with the new version, and migrate any existing
                  settings manually. Read more about the migration steps at:

                    #{chalk.underline("http://guides.appgyver.com/steroids/guides/steroids-js/cordova-3-1-migration")}

                  You can also run

                    #{chalk.bold("$ steroids create myProjectName")}

                  to create a new project to see how the #{chalk.bold("www/config.android.xml")} file should look like.

                """
              deferred.reject msg
            else if result.widget.plugins?
              msg =
                """
                #{chalk.red.bold("<plugins> element found in config.android.xml")}
                #{chalk.red.bold("=========================================")}

                It looks like your #{chalk.bold("www/config.android.xml")} file has a #{chalk.bold("<plugins>")} element, which is deprecated as of Steroids
                CLI v3.1.0. This is likely because your project was built with a pre-3.1.0 Steroids CLI version.

                To get rid of this message, you need to remove all plugins from your #{chalk.bold("www/config.android.xml")}. While you're at it,
                you should also upgrade your #{chalk.bold("www/config.android.xml")} to match the new form introduced by Steroids CLI v3.1.0.

                To ensure we don't overwrite any of your custom configs, we won't upgrade your config file automatically.
                Instead, you should go through the migration steps at

                  #{chalk.underline("http://guides.appgyver.com/steroids/guides/steroids-js/cordova-3-1-migration")}

                """
              deferred.reject msg
            else
              deferred.resolve()

    return deferred.promise
