class window.PillsController

  @index: ->

    steroids.on('ready', () ->
      # Make Navigation Bar to appear with a custom title text
      steroids.view.navigationBar.show { title: "Steroids" }

  @show: ->

    steroids.on('ready', () ->

      steroids.view.navigationBar.show { title: "show.html" }

      $("#vibrate").on "tap", ->
        navigator.notification.vibrate(2000)
