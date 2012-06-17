class App.Routers.Widgets extends Backbone.Router

  initialize: (options)->
    @widgets = new App.Collections.Widgets()
    @widgets.reset options.widgets

  routes:
    "/new"      : "newWidget"
    "/index"    : "index"
    "/:id/edit" : "edit"
    "/:id"      : "show"
    ".*"        : "index"

  newWidget: ->
    @view = new App.Views.Widgets.NewView collection: @widgets
    $("#widgets").html @view.render().el

  index: ->
    @view = new App.Views.Widgets.IndexView widgets: @widgets
    $("#widgets").html @view.render().el

  show: (id)->
    widget = @widgets.get id
    @view = new App.Views.Widgets.ShowView model: widget
    $("#widgets").html @view.render().el

  edit: (id)->
    widget = @widgets.get id
    @view = new App.Views.Widgets.EditView model: widget
    $("#widgets").html @view.render().el
