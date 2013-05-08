DefaultResource = require './generators/resources/Default'
AngularResource = require './generators/resources/Angular'
TutorialResource = require './generators/resources/Tutorial'
ExampleResource = require './generators/resources/Example'

module.exports =
  "resource": DefaultResource
  "ng-resource": AngularResource
  "tutorial": TutorialResource
  "example": ExampleResource