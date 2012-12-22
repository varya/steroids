class window.PillsController

  @index: ->

    # always put everything inside PhoneGap deviceready
    document.addEventListener "deviceready", ()->

      # Make Navigation Bar to appear with a custom title text
      Steroids.navigationBar.show { title: "Steroids" }

  @show: ->

    document.addEventListener "deviceready", ()->

      Steroids.navigationBar.show { title: "show.html" }

      $("#vibrate").on "tap", ->
        navigator.notification.vibrate(2000)
