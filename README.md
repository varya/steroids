AppGyver Steroids
-----------------

AppGyver Steroids is like PhoneGap on Steroids, providing native UI elements, multiple WebViews and enhancements for better developer productivity.


## Installation and requirements

Steroids requires node and npm package management. Install with ```-g``` to make it work.


*IMPORTANT NOTE:* brew installed node and npm might are somewhat broken, fix this by setting both:

```
export NODE_PATH="/usr/local/share/npm/lib/node_modules/"
export PATH="/usr/local/share/npm/bin:$PATH"
```


If NODE_PATH is not set and npm is installed with brew, you will following when the client connects

```

23 Dec 15:43:45 - Client connected: Mozilla/5.0 (iPhone; CPU iPhone OS 6_0 like Mac OS X) AppleWebKit/536.26 (KHTML, like Gecko) Mobile/10A403
---------------------------------------------------------
error: Error: Cannot find module 'steroids'
---------------------------------------------------------
stack: 
            module.js:338 - Module._resolveFilename()
            module.js:280 - Module._load()
            module.js:362 - Module.require()
            module.js:378 - require()
```

if PATH is not set, steroids command wont work.


This all being said, install it as global 

```
  $ npm install steroids -g
```

Xcode(and OS X platform) is not required, but installing Xcode on OS X gives you iOS Simulator. Xcode is available for download at the Mac App Store.


## Usage

```
  $ steroids create project_name
  $ cd project_name
  $ steroids connect
```

More usage information is available in

```
  $ steroids usage
```

## Debug

Steroids comes bundled with Weinre.

```
  $ steroids debug
```

Starts Weinre server and opens your browser.  Once devices are connected, you can select a target document to inspect from the first page.


## Javascript API documentation

http://appgyver.github.com/steroids-js/steroids-js-latest.html


## Bugs, feedback

We want to get your feedback, send it to contact@appgyver.com
