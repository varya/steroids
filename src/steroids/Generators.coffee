TutorialResource = require './generators/resources/Tutorial'
ExampleResource = require './generators/resources/Example'

DefaultResource = require './generators/resources/Default'
NgResource = require './yeoman-generators/NgResource'
NgScaffoldResource = require './generators/resources/NgScaffold'
NgTouchdbResource = require './generators/resources/NgTouchdbResource'
NgSqlScaffold = require './generators/resources/NgSqlScaffold'

BbScaffoldResource = require './generators/resources/BbScaffold'

module.exports =
  "tutorial": TutorialResource
  "example": ExampleResource
  "resource": DefaultResource
  "bb-scaffold": BbScaffoldResource
  "ng-resource": NgResource
  "ng-scaffold": NgScaffoldResource
  "ng-sql-scaffold": NgSqlScaffold
  "ng-touchdb-resource": NgTouchdbResource
