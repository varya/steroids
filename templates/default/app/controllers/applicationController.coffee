# always put everything inside PhoneGap deviceready

document.addEventListener "deviceready", ()->

  $(".opensLayer").on "tap", () ->

    # Create a new layer that ...

    # TODO: FIXME get rid off localhost setting
    layer = new Steroids.Layer { location: "http://localhost:13101" + @getAttribute("data-location") }

    # ... Open on top of this document and pushes to the navigation stack
    Steroids.layers.push layer: layer

  $(".opensModal").on "tap", () ->

    # TODO: FIXME get rid off localhost setting
    layer = new Steroids.Layer { location: "http://localhost:13101" + @getAttribute("data-location") }

    Steroids.modal.show layer:layer

  $(".closesModal").on "tap", () ->

     Steroids.modal.hide()
