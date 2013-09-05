AppGyver Steroids
-----------------

AppGyver Steroids is PhoneGap on Steroids, providing native UI elements, multiple WebViews and enhancements for better developer productivity.


## Installation and requirements

### Requirements

* Node.js 0.10.x and NPM package management http://nodejs.org/

#### Windows

* Git ( http://git-scm.com/downloads )
* Python 2.7 or greater ( http://www.python.org/getit/ )

#### OS X

* Xcode and command-line tools (mac app store)
* Git with homebrew or git mac installer (but with the installer, remember to set in $PATH)

#### Linux

* Git
* Python 2.7 or greater

### Installing With Node Version Manager (for *nix OS)

We recommend installing with NVM, see [https://github.com/creationix/nvm](https://github.com/creationix/nvm) because it allows you to run multiple versions of node and does not require sudo at any point.

    $ curl https://raw.github.com/creationix/nvm/master/install.sh | sh

Note that by default NVM adds initialization lines to `.bash_profile`, so you need to make sure these lines are loaded.

To install node.js 0.10.x with nvm and set it as default:

    $ nvm install 0.10
    $ nvm use 0.10
    $ nvm alias default 0.10

Now install Steroids

    $ npm install steroids -g

Note that there might be some warnings in the install from various NPM packages.  The installation should fine though.

## Usage

    $ steroids create directory_name
    $ cd directory_name
    $ steroids connect

More usage information is available in

    $ steroids usage


## Documentation

[Steroids Developer Portal](http://developers.appgyver.com)


## Bugs, feedback

We want to get your feedback, send it to contact@appgyver.com


## Testing npm

To run unit tests:

    $ bin/test

To create a test app with all generator examples:

    $ test/generate.sh
