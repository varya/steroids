childProcess = require('child_process')

childProcess.exec "echo LOL", (err, stdout)->
  console.log err
  console.log stdout
