class window.PillsController

  @index: ->

    document.addEventListener "deviceready", () ->

      # Make Navigation Bar to appear with a custom title text
      steroids.view.navigationBar.show { title: "Steroids" }

  @show: ->

    document.addEventListener "deviceready", () ->

      steroids.view.navigationBar.show { title: "show.html" }

      $("#vibrate").on "tap", ->
        navigator.notification.vibrate(2000)
