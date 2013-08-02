TutorialResource = require './generators/resources/Tutorial'
ExampleResource = require './generators/resources/Example'

DefaultResource = require './generators/resources/Default'
NgResource = require './generators/resources/NgResource'
NgScaffoldResource = require './generators/resources/NgScaffold'
NgTouchdbResource = require './generators/resources/NgTouchdbResource'

BbScaffoldResource = require './generators/resources/BbScaffold'

module.exports =
  "tutorial": TutorialResource
  "example": ExampleResource
  "resource": DefaultResource
  "bb-scaffold": BbScaffoldResource
  "ng-resource": NgResource
  "ng-scaffold": NgScaffoldResource
  "ng-touchdb-resource": NgTouchdbResource
