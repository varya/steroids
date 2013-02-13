DefaultResource = require './generators/resources/Default'

AngularScaffold = require './generators/scaffolds/Angular'
MongoDBScaffold = require './generators/scaffolds/MongoDB'
TouchDBScaffold = require './generators/scaffolds/TouchDB'

generators =
  "resource": DefaultResource
  "ng-scaffold": AngularScaffold
  "ng-mongodb-scaffold": MongoDBScaffold
  "ng-touchdb-scaffold": TouchDBScaffold

module.exports = generators
