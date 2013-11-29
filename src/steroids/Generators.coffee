Example = require './generators/examples/Example'

BbScaffold = require './generators/resources/BbScaffold'

NgResource = require './generators/resources/NgResource'
NgScaffoldResource = require './generators/resources/NgScaffold'
NgSqlScaffold = require './generators/resources/NgSqlScaffold'
NgTouchdbResource = require './generators/resources/NgTouchdbResource'

Tutorial = require './generators/tutorials/Tutorial'

module.exports =
  "example": Example
  "bb-scaffold": BbScaffold
  "ng-resource": NgResource
  "ng-scaffold": NgScaffoldResource
  "ng-sql-scaffold": NgSqlScaffold
  "ng-touchdb-resource": NgTouchdbResource
  "tutorial": Tutorial