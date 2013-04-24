DefaultResource = require './generators/resources/Default'
AngularResource = require './generators/resources/Angular'
TutorialResource = require './generators/resources/Tutorial'

module.exports =
  "resource": DefaultResource
  "ng-resource": AngularResource
  "tutorial": TutorialResource
