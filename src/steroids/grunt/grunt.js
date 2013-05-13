
var gruntSteroidsDefaults = require("../GruntDefaults");

module.exports = function(grunt) {
  config = gruntSteroidsDefaults.defaultConfig;

  // Add your custom configurations here
  // config.foo = { bar: true, baz: [1,2,3]}'

  grunt.initConfig(config);

  gruntSteroidsDefaults.registerDefaultTasks(grunt);

  // Register your custom grunt tasks here
  // grunt.registerTask("custom", "Description", function() {
  //   grunt.file.write(path.join(process.cwd(), "dist", "README"), "Custom Generated Readme");
  // });

  grunt.registerTask("default", [
    "steroids-default"
  ]);
};
