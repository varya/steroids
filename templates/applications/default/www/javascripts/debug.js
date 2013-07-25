(function(window){
  var debugOn = true,
      buffer = [],
      useConsoleLog = false;


  window.debug = function(message){

    if (!debugOn) return false;

    // if ready to use console log
    if (useConsoleLog) {
      console.log(window.location.href+" > "+message);
    } else { // else add to buffer
      buffer.push(message);
    };

  };

  window.setTimeout(function(){
    useConsoleLog = true;
    console.log("Outputting ("+window.location.href+") debug buffer:");

    for (var i=0;i<buffer.length;i++) {

      console.log(window.location.href+" > "+buffer[i]);
    };

    buffer = [];

  }, 5000);

})(window);