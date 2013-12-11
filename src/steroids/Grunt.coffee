paths = require "./paths"

class Grunt
  constructor: ()->

  run: (options = {}) ->

    task = options.task || "default"
    # set steroids path to global namespace for grunt requires
    global.steroidsPath = paths.npm

    require(paths.grunt.library).tasks [task],
      gruntfile: paths.grunt.gruntFile
      verbose: false

    # nothing gets executed here, the grunt steals the whole process somehow.

module.exports = Grunt
