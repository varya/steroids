---
layout: post
title:  "Installing Steroids npm on Windows"
date:   2013-05-21 13:51:34
categories: steroids_npm
platforms: Android, iOS
---

# Step 1: Install Node.js

Steroids npm requires Node.js version 0.10.x. Download and install Node.js from the [official website](http://nodejs.org), using the installer wizard. Make sure that all the components are selected for installation.

# Step 2: Install Git and Python

[Git](http://git-scm.com) and [Python](http://www.python.org) are required to install Steroids npm.

Download and install Git for Windows from http://git-scm.com/download/win. **In the install wizard, be sure to select the "Use Git from Windows Command Prompt" option.**

Download and install Python v2.7 or greater for Windows from http://www.python.org/getit/. **In the install wizard, be sure to select the the "Add python.exe Path" feature.**

# Step 3: Install Steroids npm

Open a command prompt and type `$ npm install steroids -g`. (Note that Node.js [doesn't support Cygwin](https://github.com/joyent/node/issues/5618) at the moment.)
