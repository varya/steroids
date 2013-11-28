Example = require './generators/examples/Example'

NgResource = require './generators/resources/NgResource'
NgScaffoldResource = require './generators/resources/NgScaffold'
NgSqlScaffold = require './generators/resources/NgSqlScaffold'

module.exports =
  "example": Example
  "ng-resource": NgResource
  "ng-scaffold": NgScaffoldResource
  "ng-sql-scaffold": NgSqlScaffold
