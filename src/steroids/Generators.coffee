DefaultResource = require './generators/resources/Default'
AngularResource = require './generators/resources/Angular'
TutorialResource = require './generators/resources/Tutorial'

DrawerExample = require './generators/resources/Drawer'
PreloadExample = require './generators/resources/Preload'
ModalExample = require './generators/resources/Modal'

module.exports =
  "resource": DefaultResource
  "ng-resource": AngularResource
  "tutorial": TutorialResource
  "drawer": DrawerExample
  "preload": PreloadExample
  "modal": ModalExample
