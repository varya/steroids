// Spec is run by node & wd.js using appium.io
// Exposed variables are:
//  browser   (wd.js driver instance)
//  handles   (instance windowHandles)

// Write your tests here:
should.not.exist(err);
handles.length.should.be.above(0);

// For example to validate that some text exists:
//
// browser.execute("mobile: findElementNameContains", [{name: 'Welcome to'}], function(err, el) {
//   should.not.exist(err);
//   should.exist(el);
//   el.getAttribute('name', function(err, name) {
//     should.not.exist(err);
//     name.should.equal("Welcome to Steroids!");
//   })
// });