window.PillsController = {

  index: function () {
    
    steroids.view.navigationBar.show("Pills Index");
    
  },

  show: function () {
    
    steroids.view.navigationBar.show("Pills View");
    
    // Cordova API calls should only be made after Cordova's "deviceready" event has fired
    document.addEventListener("deviceready", function() {
      Hammer(document.getElementById("confirm")).on("tap", function() {
        navigator.notification.confirm("", null, "Cool, huh?", "Yes,No");
      });
    });

  }

};
