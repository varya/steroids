paths = require "./paths"

class Grunt
  constructor: ()->

  run: (options = {}) ->
    # set steroids path to global namespace for grunt requires
    global.steroidsPath = paths.npm

    require(paths.grunt.library).tasks ["default"],
      gruntfile: paths.grunt.gruntFile

    # nothing gets executed here, the grunt steals the whole process somehow.

module.exports = Grunt
