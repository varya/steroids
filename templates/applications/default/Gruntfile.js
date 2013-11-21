/*
 * Default Gruntfile for AppGyver Steroids
 * http://www.appgyver.com
 *
 * Licensed under the MIT license.
 */

'use strict';

module.exports = function(grunt) {

  // Load all Grunt task modules in the project first, except for grunt-steroids
  require('load-grunt-tasks')(grunt, {pattern: ['grunt-*', '!grunt-steroids']});

  // User configs go here
  grunt.initConfig();

  // grunt-steroids must be loaded separately after grunt.initConfig()
  grunt.loadNpmTasks("grunt-steroids");

  grunt.registerTask("default", ["steroids-make", "steroids-compile-sass"]);

};
