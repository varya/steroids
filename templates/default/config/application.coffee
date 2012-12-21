Steroids = require "steroids"

# -- Required settings -- 

Steroids.config.name = "Hello World"
Steroids.config.location = "index.html"

# -- Tabs --

# A boolean to enable tab bar (on bottom)
# This will override Steroids.config.location (that is for single webview apps, like in PhoneGap)

# Steroids.config.tabBar.enabled = true




# Array with objects to specify which tabs are created on app startup

# tab object properties are

# title: what to show in tabs title
# icon: path to icon file (www/images/icon[@2x].png)
# location: can be one of these
#   file URL (relative to www)
#   http://localhost:13101 (serves files locally from www)
#   http://www.google.com (directly from internet)


# Steroids.config.tabBar.tabs = [
#   {
#     title: "File URL"
#     icon: "images/first@2x.png"
#     location: "index.html"
#   },
#   {
#     title: "Localhost"
#     icon: "images/first@2x.png"
#     location: "http://localhost:13101/index.html"
#   }
#   {
#     title: "Internet"
#     icon: "images/first@2x.png"
#     location: "http://www.appgyver.com/steroids"
#   }
# ]



# -- Status bar --
# Sets status bar visible (carrier, clock, battery status)

# Steroids.config.statusBar.enabled = true



# -- Colors --
# Color values can be set in hex codes, eg. #ffbb20

# Steroids.config.navigationBar.tintColor = ""
# Steroids.config.navigationBar.titleColor = ""
# Steroids.config.navigationBar.titleShadowColor = ""

# Steroids.config.navigationBar.buttonTintColor = ""
# Steroids.config.navigationBar.buttonTitleColor = ""
# Steroids.config.navigationBar.buttonShadowColor = ""

# Steroids.config.tabBar.tintColor = ""
# Steroids.config.tabBar.tabTitleColor = ""
# Steroids.config.tabBar.tabTitleShadowColor = ""
# Steroids.config.tabBar.selectedTabTintColor = ""

# # Can be used to set background image for the selected tab (can be bigger than the tab)
# Steroids.config.tabBar.selectedTabBackgroundImage = ""

# # Built-in iOS theme, values: black and default
# Steroids.config.theme = "default"


module.exports = Steroids.config