// UI Automation JavaScript Reference: http://developer.apple.com/library/ios/documentation/DeveloperTools/Reference/UIAutomationRef/Introduction/Introduction.html
// UI Automation JavaScript Reference API: http://developer.apple.com/library/ios/documentation/DeveloperTools/Reference/UIAutomationRef/_index.html

#import "./tuneup_js/tuneup.js" // http://www.tuneupjs.org/

test("should be running in simulator", function(target, app) {
  var name = app.name();

  assertEquals(app.name(), "Simulator", "application is not running in simulator");

  target.delay(5); // Give app some time to start, always do this before rest of the test suite.
});

test("it should pass", function(target, app) {
  assertTrue(true);
});

// Example for checking navigation bar title:
/*
test("navigation bar name should be 'My app'", function(target, app) {
  var window  = app.mainWindow(),
      navbar   = window.navigationBar();

  assertEquals(navbar.name(), "My app", "navigation bar should be My app");
});
*/