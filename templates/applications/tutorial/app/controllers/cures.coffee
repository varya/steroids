class window.CuresController
  
  index: ->
    document.addEventListener "DOMContentLoaded", ->
      Hammer(document.querySelector("#closesModal")).on "tap", ->
        steroids.modal.hide()
