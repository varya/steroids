DefaultResource = require './generators/resources/Default'
AngularResource = require './generators/resources/Angular'
TutorialResource = require './generators/resources/Tutorial'

DrawerExample = require './generators/resources/Drawer'

module.exports =
  "resource": DefaultResource
  "ng-resource": AngularResource
  "tutorial": TutorialResource
  "drawer": DrawerExample
