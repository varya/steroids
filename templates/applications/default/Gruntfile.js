/*
 * grunt-steroids
 * http://www.appgyver.com
 *
 * Licensed under the MIT license.
 */

'use strict';

module.exports = function(grunt) {

  // These plugins provide necessary tasks.
  grunt.loadNpmTasks('grunt-steroids');

  // By default, run Steroids make, then compile SASS files to dist/
  grunt.registerTask('default', ['steroids-make', 'steroids-compile-sass']);

};
