/*! steroids-js - v0.0.3 - 2012-12-20 */
;var NativeBridge,
  __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

NativeBridge = (function() {

  function NativeBridge() {
    this.send = __bind(this.send, this);

    this.message_handler = __bind(this.message_handler, this);

    this.map_context = __bind(this.map_context, this);

    this.reopen = __bind(this.reopen, this);
    this.reopen();
  }

  NativeBridge.prototype.uid = 0;

  NativeBridge.prototype.callbacks = {};

  NativeBridge.prototype.reopen = function() {
    this.websocket = new WebSocket("ws://localhost:31337");
    this.websocket.onmessage = this.message_handler;
    this.websocket.onclose = this.reopen;
    this.websocket.addEventListener("open", this.map_context);
    this.map_context();
    return false;
  };

  NativeBridge.prototype.map_context = function() {
    if ((window.top.AG_SCREEN_ID != null) && (window.top.AG_LAYER_ID != null) && (window.top.AG_VIEW_ID != null)) {
      this.send("mapWebSocketConnectionToContext", {
        parameters: {
          screen: window.top.AG_SCREEN_ID,
          layer: window.top.AG_LAYER_ID,
          view: window.top.AG_VIEW_ID
        }
      });
    }
    return this;
  };

  NativeBridge.prototype.message_handler = function(e) {
    var data;
    data = JSON.parse(e.data);
    if ((data != null ? data.callback : void 0) != null) {
      if (this.callbacks[data.callback] != null) {
        return this.callbacks[data.callback].call(data.parameters, data.parameters);
      }
    }
  };

  NativeBridge.prototype.send = function(options) {
    var callback_name, callbacks, method, request,
      _this = this;
    method = options.method;
    if ((options != null ? options.callbacks : void 0) != null) {
      callback_name = "" + method + "_" + (this.uid++);
      callbacks = {};
      if (options.callbacks.recurring != null) {
        callbacks.recurring = "" + callback_name + "_recurring";
        this.callbacks[callbacks.recurring] = function(parameters) {
          return options.callbacks.recurring.call(parameters, parameters);
        };
      }
      if (options.callbacks.success != null) {
        callbacks.success = "" + callback_name + "_success";
        this.callbacks[callbacks.success] = function(parameters) {
          delete _this.callbacks[callbacks.success];
          delete _this.callbacks[callbacks.failure];
          return options.callbacks.success.call(parameters, parameters);
        };
      }
      if (options.callbacks.failure != null) {
        callbacks.failure = "" + callback_name + "_fail";
        this.callbacks[callbacks.failure] = function(parameters) {
          delete _this.callbacks[callbacks.success];
          delete _this.callbacks[callbacks.failure];
          return options.callbacks.failure.call(parameters, parameters);
        };
      }
    } else {
      callbacks = {};
    }
    request = {
      method: method,
      parameters: (options != null ? options.parameters : void 0) != null ? options.parameters : {},
      callbacks: callbacks
    };
    request.parameters["view"] = window.top.AG_VIEW_ID;
    request.parameters["screen"] = window.top.AG_SCREEN_ID;
    request.parameters["layer"] = window.top.AG_LAYER_ID;
    if (this.websocket.readyState === 0) {
      return this.websocket.addEventListener("open", function() {
        return _this.websocket.send(JSON.stringify(request));
      });
    } else {
      return this.websocket.send(JSON.stringify(request));
    }
  };

  return NativeBridge;

})();
;var NativeObject;

NativeObject = (function() {

  function NativeObject() {}

  NativeObject.prototype.context = void 0;

  NativeObject.prototype.nativeBridge = new NativeBridge;

  NativeObject.prototype.didOccur = function(options, parameters) {
    var callback, _i, _len, _ref, _results;
    _ref = options.recurringCallbacks;
    _results = [];
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      callback = _ref[_i];
      if (callback != null) {
        _results.push(callback.call(this, parameters, options));
      }
    }
    return _results;
  };

  NativeObject.prototype.didHappen = function(options, parameters) {
    var callback, _i, _len, _ref, _results;
    _ref = options.successCallbacks;
    _results = [];
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      callback = _ref[_i];
      if (callback != null) {
        _results.push(callback.call(this, parameters, options));
      }
    }
    return _results;
  };

  NativeObject.prototype.didFail = function(options) {
    var callback, _i, _len, _ref, _results;
    _ref = options.failureCallbacks;
    _results = [];
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      callback = _ref[_i];
      if (callback != null) {
        _results.push(callback.call(this, parameters, options));
      }
    }
    return _results;
  };

  NativeObject.prototype.nativeCall = function(options) {
    var _this = this;
    return this.nativeBridge.send({
      method: options.method,
      parameters: options.parameters,
      callbacks: {
        recurring: function(parameters) {
          return _this.didOccur(options, parameters);
        },
        success: function(parameters) {
          return _this.didHappen(options, parameters);
        },
        failure: function(parameters) {
          return _this.didFail(options, parameters);
        }
      }
    });
  };

  return NativeObject;

})();
;var Device,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

Device = (function(_super) {

  __extends(Device, _super);

  function Device() {}

  Device.prototype.ping = function(options, callbacks) {
    if (callbacks == null) {
      callbacks = {};
    }
    return this.nativeCall({
      method: "ping",
      parameters: {
        payload: options.data
      },
      successCallbacks: [callbacks.onSuccess],
      failureCallbacks: [callbacks.onFailure]
    });
  };

  return Device;

})(NativeObject);
;var Animation,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

Animation = (function(_super) {

  __extends(Animation, _super);

  function Animation() {
    return Animation.__super__.constructor.apply(this, arguments);
  }

  Animation.prototype.start = function(options, callbacks) {
    if (callbacks == null) {
      callbacks = {};
    }
    return this.nativeCall({
      method: "performTransition",
      parameters: {
        transition: options.name,
        curve: options.curve || "easeInOut",
        duration: options.duration || 0.7
      },
      successCallbacks: [callbacks.onSuccess],
      failureCallbacks: [callbacks.onFailure]
    });
  };

  return Animation;

})(NativeObject);
;var App,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

App = (function(_super) {

  __extends(App, _super);

  App.prototype.path = void 0;

  App.prototype.fullPath = void 0;

  function App() {
    var _this = this;
    this.getPath({}, {
      onSuccess: function(params) {
        _this.path = params.applicationPath;
        _this.fullPath = params.applicationFullPath;
        return Steroids.markComponentReady("App");
      }
    });
  }

  App.prototype.getPath = function(options, callbacks) {
    return this.nativeCall({
      method: "getApplicationPath",
      parameters: {},
      successCallbacks: [callbacks.onSuccess],
      failureCallbacks: [callbacks.onFailure]
    });
  };

  return App;

})(NativeObject);
;var Button,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

Button = (function(_super) {

  __extends(Button, _super);

  function Button() {
    return Button.__super__.constructor.apply(this, arguments);
  }

  Button.prototype.show = function(options, callbacks) {
    if (callbacks == null) {
      callbacks = {};
    }
    return this.nativeCall({
      method: "showNavigationBarRightButton",
      parameters: {
        title: options.title
      },
      successCallbacks: [callbacks.onSuccess],
      failureCallbacks: [callbacks.onFailure],
      recurringCallbacks: [callbacks.onRecurring]
    });
  };

  return Button;

})(NativeObject);
;var Modal,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

Modal = (function(_super) {

  __extends(Modal, _super);

  function Modal() {
    return Modal.__super__.constructor.apply(this, arguments);
  }

  Modal.prototype.show = function(layer, callbacks) {
    if (callbacks == null) {
      callbacks = {};
    }
    return this.nativeCall({
      method: "openModal",
      parameters: {
        url: layer.location
      },
      successCallbacks: [callbacks.onSuccess],
      failureCallbacks: [callbacks.onFailure]
    });
  };

  Modal.prototype.hide = function(options, callbacks) {
    if (options == null) {
      options = {};
    }
    if (callbacks == null) {
      callbacks = {};
    }
    return this.nativeCall({
      method: "closeModal",
      parameters: options,
      successCallbacks: [callbacks.onSuccess],
      failureCallbacks: [callbacks.onFailure]
    });
  };

  return Modal;

})(NativeObject);
;var LayerCollection,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

LayerCollection = (function(_super) {

  __extends(LayerCollection, _super);

  function LayerCollection() {
    this.array = [];
  }

  LayerCollection.prototype.pop = function(options, callbacks) {
    var defaultOnSuccess,
      _this = this;
    if (options == null) {
      options = {};
    }
    if (callbacks == null) {
      callbacks = {};
    }
    defaultOnSuccess = function() {
      return _this.array.pop();
    };
    this.nativeCall({
      method: "popLayer",
      successCallbacks: [defaultOnSuccess, callbacks.onSuccess],
      failureCallbacks: [callbacks.onFailure]
    });
    return this.array.pop();
  };

  LayerCollection.prototype.push = function(layer, callbacks) {
    var defaultOnSuccess, parameters,
      _this = this;
    if (callbacks == null) {
      callbacks = {};
    }
    defaultOnSuccess = function() {
      return function() {
        return _this.array.push(layer);
      };
    };
    parameters = {
      url: layer.location
    };
    if (layer.pushAnimation != null) {
      parameters.pushAnimation = layer.pushAnimation;
    }
    if (layer.pushAnimationDuration != null) {
      parameters.pushAnimationDuration = layer.pushAnimationDuration;
    }
    if (layer.popAnimation != null) {
      parameters.popAnimation = layer.popAnimation;
    }
    if (layer.popAnimationDuration != null) {
      parameters.popAnimationDuration = layer.popAnimationDuration;
    }
    return this.nativeCall({
      method: "openLayer",
      parameters: parameters,
      successCallbacks: [defaultOnSuccess, callbacks.onSuccess],
      failureCallbacks: [callbacks.onFailure]
    });
  };

  return LayerCollection;

})(NativeObject);
;var Layer,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

Layer = (function(_super) {

  __extends(Layer, _super);

  function Layer(options) {
    this.location = options.location;
    if (options.pushAnimation != null) {
      this.pushAnimation = options.pushAnimation;
    }
    if (options.pushAnimationDuration != null) {
      this.pushAnimationDuration = options.pushAnimationDuration;
    }
    if (options.popAnimation != null) {
      this.popAnimation = options.popAnimation;
    }
    if (options.popAnimationDuration != null) {
      this.popAnimationDuration = options.popAnimationDuration;
    }
  }

  return Layer;

})(NativeObject);
;var Tab;

Tab = (function() {

  function Tab() {}

  return Tab;

})();
;var NavigationBar,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

NavigationBar = (function(_super) {

  __extends(NavigationBar, _super);

  function NavigationBar() {}

  NavigationBar.prototype.rightButton = new Button;

  NavigationBar.prototype.show = function(options, callbacks) {
    if (callbacks == null) {
      callbacks = {};
    }
    return this.nativeCall({
      method: "showNavigationBar",
      parameters: {
        title: options.title
      },
      successCallbacks: [callbacks.onSuccess],
      failureCallbacks: [callbacks.onFailure]
    });
  };

  NavigationBar.prototype.setTitle = function(options, callbacks) {
    var whenSet;
    return whenSet = function() {
      return this.title = options.title;
    };
  };

  return NavigationBar;

})(NativeObject);
;var Audio,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

Audio = (function(_super) {

  __extends(Audio, _super);

  function Audio() {
    return Audio.__super__.constructor.apply(this, arguments);
  }

  Audio.prototype.play = function(options, callbacks) {
    var _this = this;
    if (callbacks == null) {
      callbacks = {};
    }
    return Steroids.on("ready", function() {
      var mediaPath;
      if (options.absolutePath) {
        mediaPath = options.absolutePath;
      } else {
        mediaPath = "" + Steroids.app.path + "/" + options.path;
      }
      return _this.nativeCall({
        method: "play",
        parameters: {
          filenameWithPath: mediaPath
        },
        successCallbacks: [callbacks.onSuccess],
        failureCallbacks: [callbacks.onFailure]
      });
    });
  };

  Audio.prototype.prime = function(options, callbacks) {
    if (options == null) {
      options = {};
    }
    if (callbacks == null) {
      callbacks = {};
    }
    return this.nativeCall({
      method: "primeAudioPlayer",
      parameters: options,
      successCallbacks: [callbacks.onSuccess],
      failureCallbacks: [callbacks.onFailure]
    });
  };

  return Audio;

})(NativeObject);
;var Flash,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

Flash = (function(_super) {

  __extends(Flash, _super);

  function Flash() {
    return Flash.__super__.constructor.apply(this, arguments);
  }

  Flash.prototype.toggle = function(options, callbacks) {
    if (options == null) {
      options = {};
    }
    if (callbacks == null) {
      callbacks = {};
    }
    return this.nativeCall({
      method: "cameraFlashToggle",
      parameters: options,
      successCallbacks: [callbacks.onSuccess],
      failureCallbacks: [callbacks.onFailure]
    });
  };

  return Flash;

})(NativeObject);
;var Camera,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

Camera = (function(_super) {

  __extends(Camera, _super);

  function Camera() {
    return Camera.__super__.constructor.apply(this, arguments);
  }

  Camera.prototype.flash = new Flash;

  return Camera;

})(NativeObject);
;var Steroids;

Steroids = (function() {

  function Steroids() {
    this.debug("Steroids loaded");
  }

  Steroids.NavigationBar = NavigationBar;

  Steroids.Layer = Layer;

  Steroids.layers = new LayerCollection;

  Steroids.Modal = new Modal;

  Steroids.Audio = new Audio;

  Steroids.Animation = new Animation;

  Steroids.Camera = new Camera;

  Steroids.Tab = Tab;

  Steroids.version = "0.0.1";

  Steroids.navigationBar = new NavigationBar;

  Steroids.app = new App;

  Steroids.device = new Device;

  Steroids.eventCallbacks = {};

  Steroids.on = function(event, callback) {
    var _base;
    if (this["" + event + "_has_fired"] != null) {
      return callback();
    } else {
      (_base = this.eventCallbacks)[event] || (_base[event] = []);
      return this.eventCallbacks[event].push(callback);
    }
  };

  Steroids.fireSteroidsEvent = function(event) {
    var callback, _i, _len, _ref, _results;
    this["" + event + "_has_fired"] = new Date().getTime();
    if (this.eventCallbacks[event] != null) {
      _ref = this.eventCallbacks[event];
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        callback = _ref[_i];
        callback();
        _results.push(this.eventCallbacks[event].splice(this.eventCallbacks[event].indexOf(callback), 1));
      }
      return _results;
    }
  };

  Steroids.waitingForComponents = ["App"];

  Steroids.markComponentReady = function(model) {
    this.waitingForComponents.splice(this.waitingForComponents.indexOf(model), 1);
    if (this.waitingForComponents.length === 0) {
      return this.fireSteroidsEvent("ready");
    }
  };

  Steroids.prototype.debugBoolean = false;

  Steroids.prototype.debug = function(msg) {
    if (this.debugBoolean) {
      return console.log(msg);
    }
  };

  return Steroids;

})();
