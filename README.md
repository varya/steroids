AppGyver Steroids
-----------------

AppGyver Steroids is like PhoneGap on Steroids, providing native UI elements, multiple WebViews and enhancements for better developer productivity.


## Installation and requirements


### Requirements

* Node.js and NPM package management http://nodejs.org/
* Git

Once your environment is set up, run

```
  $ [sudo] npm install steroids -g
```


Xcode (and OS X platform) is not required, but installing Xcode on OS X gives you iOS Simulator. Xcode is available for download at the Mac App Store.

#### Troubleshooting

If you are having issues with the install, you should maybe remove your (old) node installation and install the latest node.  There is a [remove-node.sh](https://raw.github.com/AppGyver/steroids/master/remove-node.sh) script to help with that.

## Usage

```
  $ steroids create tutorial directory_name
  $ cd directory_name
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
