---
layout: post
title:  "Default Gruntfile.js tasks"
date:   2013-10-24 11:31
categories: project_configuration
platforms: iOS, Android
---

## steroids make

When you press enter in the Steroids console (i.e. the Terminal running `$ steroids connect`), Steroids CLI runs a series of internal commands. One of these is `$ steroids make`, which creates the `dist/` folder and its contents. The `dist/` folder contains the final app structure that is then copied onto the actual mobile devices.

Starting from version 2.7.39, Steroids CLI uses a `Gruntfile.js` in the project root to configure which tasks are run as part of `steroids make`. The Steroids tasks are loaded from the [`grunt-steroids`](http://github.com/appgyver/grunt-steroids) Grunt plugin, included as an npm dependency in new projects.

## Configuring the default tasks

`steroids make` runs the `default` task of the `Gruntfile.js` in the project root. By default, the task configuration contains the `steroids-make` and `steroids-compile-sass` tasks. You should modify the default task list to include any additional tasks you might want to run.

The Steroid tasks' code can be found in your project's `node_modules/grunt-steroids/tasks/` folder. If you need to change the default behavior, you can either modify the task files themselves, overwrite the configurations in your `Gruntfile.js` or use them as inspiration for your own tasks.

## Migrating from an old project

If you have a project created with an older version of Steroids CLI, running `$ steroids update` will run you through the steps required to migrate to the current setup.
