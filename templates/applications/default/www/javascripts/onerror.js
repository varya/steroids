window.onerror = function(errorMsg, url, lineNumber) {
  var formattedMsg = url+":"+lineNumber+" "+errorMsg;
  console.log(formattedMsg);
  alert(formattedMsg);

};