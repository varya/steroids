DefaultResource = require './generators/resources/Default'
AngularScaffold = require './generators/scaffolds/Angular'

generators =
  "resource": DefaultResource
  "ng-scaffold": AngularScaffold

module.exports = generators
