socket = io.connect window.location.hostname

socket.on 'message', (message)-> alert message

# If Socket.IO server is running correctly,
# it will send our message back to the client
#socket.send 'hello'



window.App =
  Models: {}
  Collections: {}
  Routers: {}
  Views: {}



class App.Models.Widget extends Backbone.Model
  paramRoot: 'widget'
  defaults: name: null


class App.Collections.WidgetsCollection extends Backbone.Collection
  model: App.Models.Widget
  url: '/widgets'



class App.Views.Widgets.EditView extends Backbone.View
  template: JST["backbone/templates/widgets/edit"]
  events: "submit #edit-widget": "update"
  update: (e)->
    e.preventDefault()
    e.stopPropagation()
    @model.save(null,
      success: (post) =>
        @model = post
        window.location.hash = "/#{@model.id}"
    )
  render: ->
    $(this.el).html this.template @model.toJSON()
    this.$("form").backboneLink @model
    this

class App.Views.Widgets.IndexView extends Backbone.View
  template: JST["backbone/templates/widgets/index"]
  initialize: ->
    _.bindAll this, 'addOne', 'addAll', 'render'
    @options.posts.bind 'reset', @addAll
  addAll: -> @options.posts.each @addOne
  addOne: (widget)->
    view = new App.Views.Widgets.WidgetView model : post
    @$("tbody").append(view.render().el)
  render: ->
    $(@el).html @template posts: @options.posts.toJSON()
    @addAll()
    this

class App.Views.Widgets.NewView extends Backbone.View
  template: JST["backbone/templates/widgets/new"]
  events: "submit #new-widget": "save"
  constructor: (options)->
    super options
    @model = new @collection.model()
    @model.bind "change:errors", ()=> this.render()
  save: (e)->
    e.preventDefault()
    e.stopPropagation()
    @model.unset "errors"
    @collection.create(@model.toJSON(),
      success: (post)=>
        @model = post
        window.location.hash = "/#{@model.id}"
      error: (post, jqXHR)=>
        @model.set errors: $.parseJSON jqXHR.responseText
    )
  render: ->
    $(this.el).html @template @model.toJSON()
    this.$("form").backboneLink @model
    this

class App.Views.Widgets.WidgetView extends Backbone.View
  template: JST["backbone/templates/widgets/widget"]
  events: "click .destroy": "destroy"
  tagName: "tr"
  destroy: ->
    @model.destroy()
    this.remove()
    false
  render: ->
    $(this.el).html @template @model.toJSON()
    this

class Blog.Views.Posts.ShowView extends Backbone.View
  template: JST["backbone/templates/posts/show"]
  render: ->
    $(this.el).html @template @model.toJSON()
    this




class App.Routers.WidgetsRouter extends Backbone.Router
  initialize: (options) ->
    @widgets = new App.Collections.WidgetsCollection()
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



$ ->
  window.router = new App.Routers.WidgetsRouter widgets: @widgets.to_json
  Backbone.history.start()
