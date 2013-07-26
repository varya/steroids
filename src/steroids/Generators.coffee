TutorialResource = require './generators/resources/Tutorial'
ExampleResource = require './generators/resources/Example'

DefaultResource = require './generators/resources/Default'
AngularResource = require './generators/resources/Angular'
NgScaffoldResource = require './generators/resources/NgScaffold'


module.exports =
  "tutorial": TutorialResource
  "example": ExampleResource
  "resource": DefaultResource
  "ng-resource": AngularResource
  "ng-scaffold": NgScaffoldResource
