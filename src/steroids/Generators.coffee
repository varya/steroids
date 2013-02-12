DefaultResource = require './generators/resources/Default'

AngularScaffold = require './generators/scaffolds/Angular'
TouchDBScaffold = require './generators/scaffolds/TouchDB'

generators =
  "resource": DefaultResource
  "ng-scaffold": AngularScaffold
  "ng-touchdb-scaffold": TouchDBScaffold

module.exports = generators
