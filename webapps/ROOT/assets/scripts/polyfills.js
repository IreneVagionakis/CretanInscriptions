(function (window, document) {
  'use strict';

  var vendors = ['ms', 'moz', 'webkit', 'o'];
  for (var i = 0; i < vendors.length && !window.requestAnimationFrame; i += 1) {
    window.requestAnimationFrame = window[vendors[i] + 'RequestAnimationFrame'];
    window.cancelAnimationFrame = window[vendors[i] + 'CancelAnimationFrame'] || window[vendors[i] + 'CancelRequestAnimationFrame'];
  }

  if (!window.requestAnimationFrame) {
    var lastTime = 0;
    window.requestAnimationFrame = function (callback) {
      var now = new Date().getTime();
      var delay = Math.max(0, 16 - (now - lastTime));
      var id = window.setTimeout(function () {
        lastTime = now + delay;
        callback(lastTime);
      }, delay);
      return id;
    };
  }

  if (!window.cancelAnimationFrame) {
    window.cancelAnimationFrame = function (id) {
      window.clearTimeout(id);
    };
  }

  if (!('classList' in document.documentElement)) {
    var ClassList = function (element) {
      this.element = element;
    };

    ClassList.prototype._classes = function () {
      return this.element.className.replace(/^\s+|\s+$/g, '').split(/\s+/).filter(Boolean);
    };

    ClassList.prototype._set = function (classes) {
      this.element.className = classes.join(' ');
    };

    ClassList.prototype.contains = function (token) {
      return this._classes().indexOf(token) !== -1;
    };

    ClassList.prototype.add = function () {
      var classes = this._classes();
      for (var i = 0; i < arguments.length; i += 1) {
        if (classes.indexOf(arguments[i]) === -1) {
          classes.push(arguments[i]);
        }
      }
      this._set(classes);
    };

    ClassList.prototype.remove = function () {
      var classes = this._classes();
      for (var i = 0; i < arguments.length; i += 1) {
        var index = classes.indexOf(arguments[i]);
        while (index !== -1) {
          classes.splice(index, 1);
          index = classes.indexOf(arguments[i]);
        }
      }
      this._set(classes);
    };

    ClassList.prototype.toggle = function (token, force) {
      var present = this.contains(token);
      if (force === true || (!present && force !== false)) {
        this.add(token);
        return true;
      }
      if (present && force !== true) {
        this.remove(token);
        return false;
      }
      return present;
    };

    Object.defineProperty(window.Element.prototype, 'classList', {
      get: function () {
        return new ClassList(this);
      }
    });
  }

  if (!window.URL) {
    window.URL = function (url, base) {
      var anchor = document.createElement('a');
      if (base) {
        var baseAnchor = document.createElement('a');
        baseAnchor.href = base;
        anchor.href = baseAnchor.href;
      }
      anchor.href = url;
      this.href = anchor.href;
      this.protocol = anchor.protocol;
      this.host = anchor.host;
      this.hostname = anchor.hostname;
      this.port = anchor.port;
      this.pathname = anchor.pathname.charAt(0) === '/' ? anchor.pathname : '/' + anchor.pathname;
      this.search = anchor.search;
      this.hash = anchor.hash;
      this.origin = anchor.protocol + '//' + anchor.host;
    };

    window.URL.prototype.toString = function () {
      return this.href;
    };
  }
}(window, document));