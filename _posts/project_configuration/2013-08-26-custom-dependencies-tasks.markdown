---
layout: post
title:  "Custom dependencies and build tasks for your project"
date:   2013-05-21 13:51:34
categories: project_configuration
platforms: iOS, Android
---

###Related guides
* [Steroids preferences in config/application.coffee][config-application-coffee-guide]

## Pre- and post-make hooks

When you press enter in the Steroids console (i.e. the Terminal running `$ steroids connect`), Steroids npm runs a series of internal commands. One of these is `$ steroids make`, which creates the `dist/` folder and its contents. The `dist/` folder contains the final app structure that is then copied onto the actual mobile devices.

The `make` task runs a series of [Grunt.js](http://gruntjs.com/) tasks, including compiling SASS and CoffeeScript, merging layouts and views in the `app/` directory, copying everything to the `dist/` folder etc. (You can see the actual tasks that are run in the [GruntDefaults.coffee](https://github.com/AppGyver/steroids/blob/master/src/steroids/GruntDefaults.coffee) file in the Steroids npm source.)

The [config/application.coffee][config-application-coffee-guide] file has support for custom pre- and post-make hooks with the `steroids.config.hooks` property. The first hook is run before the `make` command:

{% highlight coffeescript %}
steroids.config.hooks.preMake.cmd = "echo"
steroids.config.hooks.preMake.args = ["running yeoman"]
{% endhighlight %}

The other hook is run right after `make`, before running `steroids package`, the process that packages the app before sending it to client devices. 

**The post-make commands should output to the `dist/` folder** – after the `make` task, nothing will be copied over from the `www`, `merges`, `app` etc. directories.

{% highlight coffeescript %}
steroids.config.hooks.postMake.cmd = "echo"
steroids.config.hooks.postMake.args = ["cleaning up files"]
{% endhighlight %}

Note that the arguments are always given as an array.

## Custom Bower dependencies

All Steroids projects use Bower to load the latest version of Steroids.js by default, and some generators add their own Bower dependencies. The `$ steroids update` command provied a shorthand for updating Bower dependencies.

To add a custom Bower dependency to your project, simply run `$ bower install package-name` – the default install directory, set up by the `.bowerrc` file in your project root is `www/components/`. The `config/bower.json` file keeps track of your project's Bower dependencies.

## Custom npm dependencies

A new Steroids project doesn't include any npm dependencies, but you can use `$ npm install package-name` like you would normally.

[config-application-coffee-guide]: /steroids/guides/project_configuration/config-application-coffee/