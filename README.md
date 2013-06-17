AppGyver Steroids
-----------------

AppGyver Steroids is like PhoneGap on Steroids, providing native UI elements, multiple WebViews and enhancements for better developer productivity.


## Installation and requirements

### Requirements

* Node.js 0.8.x and NPM package management http://nodejs.org/
* Xcode and command-line tools (mac app store)
* Git with homebrew or git mac installer (but with the installer, remember to set in $PATH)


### With Node Version Manager

We recommend installing with NVM, see https://github.com/creationix/nvm.

    $ curl https://raw.github.com/creationix/nvm/master/install.sh | sh

Note that by default NVM adds initialization lines to `.bash_profile`, so you need to make sure these lines are loaded.

To install node.js 0.8.x with nvm and set it as default:

    $ nvm install 0.8
    $ nvm use 0.8
    $ nvm alias default 0.8

Now install Steroids

    $ npm install steroids -g

Note that there might be some warnings in the install from various NPM packages.  The installation should fine though.

## Usage

    $ steroids create tutorial directory_name
    $ cd directory_name
    $ steroids connect

More usage information is available in

    $ steroids usage

## Debug

Steroids comes bundled with Weinre.

    $ steroids debug

Starts Weinre server and opens your browser.  Once devices are connected, you can select a target document to inspect from the first page.


## Javascript API documentation

http://docs.appgyver.com


## Bugs, feedback

We want to get your feedback, send it to contact@appgyver.com

## Testing

To run unit tests:

    $ bin/test

To create a test app with all generator examples:

    $ test/generate.sh