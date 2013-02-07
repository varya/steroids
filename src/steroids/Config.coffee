class Config

  statusBar: {
    style: "black"
    enabled: false
  }
  navigationBar: {
    tintColor:                  ""
    titleColor:                 ""
    titleShadowColor:           ""

    buttonTitleColor:           ""
    buttonShadowColor:          ""
    buttonTintColor:            ""
  }
  theme:                        "black"
  location:                     "http://localhost/index.html"
  tabBar: {
    enabled:                    false
    tintColor:                  ""
    tabTitleColor:              ""
    tabTitleShadowColor:        ""
    selectedTabTintColor:       ""
    selectedTabBackgroundImage: ""

    # tabs: [{title: "default", icon:"icon.png", location: "http://localhost/index.html"}]
    tabs: []
  }
  worker: {}


module.exports = Config
