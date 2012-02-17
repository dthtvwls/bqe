(function() {
  var getUrl, methodMap, urlError, _base,
    __hasProp = Object.prototype.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor; child.__super__ = parent.prototype; return child; },
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  window.socket = io.connect(window.location.hostname);

  window.socket.on('message', function(message) {
    return alert(message);
  });

  methodMap = {
    'create': 'POST',
    'update': 'PUT',
    'delete': 'DELETE',
    'read': 'GET'
  };

  getUrl = function(object) {
    if (!(object && object.url)) return null;
    if (_.isFunction(object.url)) {
      return object.url();
    } else {
      return object.url;
    }
  };

  urlError = function() {
    throw new Error("A 'url' property or function must be specified");
  };

  Backbone.sync = function(method, model, options) {
    var complete, data, params, type;
    type = methodMap[method];
    params = _.extend({
      type: type,
      dataType: 'json',
      contentType: 'application/json',
      beforeSend: function(xhr) {
        var token;
        token = $('meta[name="csrf-token"]').attr('content');
        if (token) xhr.setRequestHeader('X-CSRF-Token', token);
        return model.trigger('sync:start');
      }
    }, options);
    if (!params.url) params.url = getUrl(model) || urlError();
    if (!params.data && model && (method === 'create' || method === 'update')) {
      data = {};
      if (model.paramRoot) {
        data[model.paramRoot] = model.toJSON();
      } else {
        data = model.toJSON();
      }
      params.data = JSON.stringify(data);
    }
    complete = options.complete;
    params.complete = function(jqXHR, textStatus) {
      model.trigger('sync:end');
      if (complete) return complete(jqXHR, textStatus);
    };
    $.ajax(params);
    return alert(JSON.stringify(params));
  };

  /*
    socket = window.socket
    socket.send 'hello'
  
    signature = ->
      sig = {}
      sig.endPoint = if model._id then "#{model.url}/#{model._id}" else model.url
      sig.ctx = model.ctx if model.ctx
      sig
  
    event = (operation, sig)->
      e = operation + ':'
      e += sig.endPoint
      e += (':' + sig.ctx) if sig.ctx
      e
  
    switch method
      when 'create' then ->
        sign = signature model
        e = event 'create', sign
        socket.emit 'create', 'signature': sign, item: model.attributes
        socket.once e, (data)->
          model._id = data._id
          console.log model
      when 'read' then ->
        sign = signature model
        e = event 'read', sign
        socket.emit 'read', 'signature': sign
        socket.once e, (data)-> options.success data
      when 'update' then ->
        sign = signature model
        e = event 'update', sign
        socket.emit 'update', 'signature': sign, item: model.attributes
        socket.once e, (data)-> console.log data
      when 'delete' then ->
        sign = signature model
        e = event 'delete', sign
        socket.emit 'delete', 'signature': sign, item: model.attributes
        socket.once e, (data)-> console.log data
  */

  (function($) {
    return $.extend($.fn, {
      backboneLink: function(model) {
        return $(this).find(":input").each(function() {
          var el, name;
          el = $(this);
          name = el.attr("name");
          model.bind("change:" + name, function() {
            return el.val(model.get(name));
          });
          return $(this).bind("change", function() {
            var attrs;
            el = $(this);
            attrs = {};
            attrs[el.attr("name")] = el.val();
            return model.set(attrs);
          });
        });
      }
    });
  })($);

  window.App = {
    Models: {},
    Collections: {},
    Routers: {},
    Views: {}
  };

  App.Models.Widget = (function(_super) {

    __extends(Widget, _super);

    function Widget() {
      Widget.__super__.constructor.apply(this, arguments);
    }

    Widget.prototype.idAttribute = '_id';

    Widget.prototype.paramRoot = 'widget';

    Widget.prototype.defaults = {
      name: null
    };

    return Widget;

  })(Backbone.Model);

  App.Collections.WidgetsCollection = (function(_super) {

    __extends(WidgetsCollection, _super);

    function WidgetsCollection() {
      WidgetsCollection.__super__.constructor.apply(this, arguments);
    }

    WidgetsCollection.prototype.model = App.Models.Widget;

    WidgetsCollection.prototype.url = '/widgets';

    return WidgetsCollection;

  })(Backbone.Collection);

  this.JST || (this.JST = {});

  this.JST["backbone/templates/widgets/edit"] = function(obj) {
    var print, __p;
    __p = [];
    print = function() {
      return __p.push.apply(__p, arguments);
    };
    __p.push('<h1>Edit widget</h1>\n\n<form id="edit-widget" name="widget">\n  <div class="field">\n    <label for="name"> name:</label>\n    <input type="text" name="name" id="name" value="', obj.name, '" >\n  </div>\n\n  <div class="actions">\n    <input type="submit" value="Update Widget" />\n  </div>\n\n</form>\n\n<a href="#/index">Back</a>\n');
    return __p.join('');
  };

  this.JST["backbone/templates/widgets/index"] = function(obj) {
    var print, __p;
    __p = [];
    print = function() {
      return __p.push.apply(__p, arguments);
    };
    __p.push('<h1>Listing widgets</h1>\n\n<table id="widgets-table">\n  <tr>\n    <th>Name</th>\n    <th></th>\n    <th></th>\n    <th></th>\n  </tr>\n</table>\n\n<br/>\n\n<a href="#/new">New Widget</a>\n');
    return __p.join('');
  };

  this.JST["backbone/templates/widgets/new"] = function(obj) {
    var print, __p;
    __p = [];
    print = function() {
      return __p.push.apply(__p, arguments);
    };
    __p.push('<h1>New widget</h1>\n\n<form id="new-widget" name="widget">\n  <div class="field">\n    <label for="name"> name:</label>\n    <input type="text" name="name" id="name" value="', obj.name, '" >\n  </div>\n\n  <div class="actions">\n    <input type="submit" value="Create Widget" />\n  </div>\n\n</form>\n\n<a href="#/index">Back</a>\n');
    return __p.join('');
  };

  this.JST["backbone/templates/widgets/show"] = function(obj) {
    var print, __p;
    __p = [];
    print = function() {
      return __p.push.apply(__p, arguments);
    };
    __p.push('<p>\n  <b>Name:</b>\n  ', obj.name, '\n</p>\n\n\n<a href="#/index">Back</a>\n');
    return __p.join('');
  };

  this.JST["backbone/templates/widgets/widget"] = function(obj) {
    var print, __p;
    __p = [];
    print = function() {
      return __p.push.apply(__p, arguments);
    };
    __p.push('<td>', obj.name, '</td>\n\n<td><a href="#/', obj._id, '">Show</td>\n<td><a href="#/', obj._id, '/edit">Edit</td>\n<td><a href="#/', obj._id, '/destroy" class="destroy">Destroy</a></td>\n');
    return __p.join('');
  };

  (_base = App.Views).Widgets || (_base.Widgets = {});

  App.Views.Widgets.EditView = (function(_super) {

    __extends(EditView, _super);

    function EditView() {
      EditView.__super__.constructor.apply(this, arguments);
    }

    EditView.prototype.template = JST["backbone/templates/widgets/edit"];

    EditView.prototype.events = {
      "submit #edit-widget": "update"
    };

    EditView.prototype.update = function(e) {
      var _this = this;
      e.preventDefault();
      e.stopPropagation();
      return this.model.save(null, {
        success: function(widget) {
          _this.model = widget;
          return window.location.hash = "/" + _this.model._id;
        }
      });
    };

    EditView.prototype.render = function() {
      $(this.el).html(this.template(this.model.toJSON()));
      this.$("form").backboneLink(this.model);
      return this;
    };

    return EditView;

  })(Backbone.View);

  App.Views.Widgets.IndexView = (function(_super) {

    __extends(IndexView, _super);

    function IndexView() {
      this.render = __bind(this.render, this);
      this.addOne = __bind(this.addOne, this);
      this.addAll = __bind(this.addAll, this);
      IndexView.__super__.constructor.apply(this, arguments);
    }

    IndexView.prototype.template = JST["backbone/templates/widgets/index"];

    IndexView.prototype.initialize = function() {
      return this.options.widgets.bind('reset', this.addAll);
    };

    IndexView.prototype.addAll = function() {
      return this.options.widgets.each(this.addOne);
    };

    IndexView.prototype.addOne = function(widget) {
      var view;
      view = new App.Views.Widgets.WidgetView({
        model: widget
      });
      return this.$("tbody").append(view.render().el);
    };

    IndexView.prototype.render = function() {
      $(this.el).html(this.template({
        widgets: this.options.widgets.toJSON()
      }));
      this.addAll();
      return this;
    };

    return IndexView;

  })(Backbone.View);

  App.Views.Widgets.NewView = (function(_super) {

    __extends(NewView, _super);

    NewView.prototype.template = JST["backbone/templates/widgets/new"];

    NewView.prototype.events = {
      "submit #new-widget": "save"
    };

    function NewView(options) {
      var _this = this;
      NewView.__super__.constructor.call(this, options);
      this.model = new this.collection.model();
      this.model.bind("change:errors", function() {
        return _this.render();
      });
    }

    NewView.prototype.save = function(e) {
      var _this = this;
      e.preventDefault();
      e.stopPropagation();
      this.model.unset("errors");
      return this.collection.create(this.model.toJSON(), {
        success: function(widget) {
          _this.model = widget;
          return window.location.hash = "/" + _this.model._id;
        },
        error: function(widget, jqXHR) {
          return _this.model.set({
            errors: $.parseJSON(jqXHR.responseText)
          });
        }
      });
    };

    NewView.prototype.render = function() {
      $(this.el).html(this.template(this.model.toJSON()));
      this.$("form").backboneLink(this.model);
      return this;
    };

    return NewView;

  })(Backbone.View);

  App.Views.Widgets.ShowView = (function(_super) {

    __extends(ShowView, _super);

    function ShowView() {
      ShowView.__super__.constructor.apply(this, arguments);
    }

    ShowView.prototype.template = JST["backbone/templates/widgets/show"];

    ShowView.prototype.render = function() {
      $(this.el).html(this.template(this.model.toJSON()));
      return this;
    };

    return ShowView;

  })(Backbone.View);

  App.Views.Widgets.WidgetView = (function(_super) {

    __extends(WidgetView, _super);

    function WidgetView() {
      WidgetView.__super__.constructor.apply(this, arguments);
    }

    WidgetView.prototype.template = JST["backbone/templates/widgets/widget"];

    WidgetView.prototype.events = {
      "click .destroy": "destroy"
    };

    WidgetView.prototype.tagName = "tr";

    WidgetView.prototype.destroy = function() {
      this.model.destroy();
      this.remove();
      return false;
    };

    WidgetView.prototype.render = function() {
      $(this.el).html(this.template(this.model.toJSON()));
      return this;
    };

    return WidgetView;

  })(Backbone.View);

  App.Routers.WidgetsRouter = (function(_super) {

    __extends(WidgetsRouter, _super);

    function WidgetsRouter() {
      WidgetsRouter.__super__.constructor.apply(this, arguments);
    }

    WidgetsRouter.prototype.initialize = function(options) {
      this.widgets = new App.Collections.WidgetsCollection();
      return this.widgets.reset(options.widgets);
    };

    WidgetsRouter.prototype.routes = {
      "/new": "newWidget",
      "/index": "index",
      "/:id/edit": "edit",
      "/:id": "show",
      ".*": "index"
    };

    WidgetsRouter.prototype.newWidget = function() {
      this.view = new App.Views.Widgets.NewView({
        collection: this.widgets
      });
      return $("#widgets").html(this.view.render().el);
    };

    WidgetsRouter.prototype.index = function() {
      this.view = new App.Views.Widgets.IndexView({
        widgets: this.widgets
      });
      return $("#widgets").html(this.view.render().el);
    };

    WidgetsRouter.prototype.show = function(id) {
      var widget;
      widget = this.widgets.get(id);
      this.view = new App.Views.Widgets.ShowView({
        model: widget
      });
      return $("#widgets").html(this.view.render().el);
    };

    WidgetsRouter.prototype.edit = function(id) {
      var widget;
      widget = this.widgets.get(id);
      this.view = new App.Views.Widgets.EditView({
        model: widget
      });
      return $("#widgets").html(this.view.render().el);
    };

    return WidgetsRouter;

  })(Backbone.Router);

}).call(this);
