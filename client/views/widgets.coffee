App.Views.Widgets ||= {}

class App.Views.Widgets.EditView extends Backbone.View
  template: JST["backbone/templates/widgets/edit"]
  events: "submit #edit-widget": "update"
  update: (e)->
    e.preventDefault()
    e.stopPropagation()
    @model.save null, success: (widget)=>
      @model = widget
      window.location.hash = "/#{@model._id}"
  render: ->
    $(@el).html @template @model.toJSON()
    @$("form").backboneLink @model
    @

class App.Views.Widgets.IndexView extends Backbone.View
  template: JST["backbone/templates/widgets/index"]
  initialize: -> @options.widgets.bind 'reset', @addAll
  addAll: => @options.widgets.each @addOne
  addOne: (widget)=>
    view = new App.Views.Widgets.WidgetView model: widget
    @$("tbody").append view.render().el
  render: =>
    $(@el).html @template widgets: @options.widgets.toJSON()
    @addAll()
    @

class App.Views.Widgets.NewView extends Backbone.View
  template: JST["backbone/templates/widgets/new"]
  events: "submit #new-widget": "save"
  constructor: (options)->
    super(options)
    @model = new @collection.model()
    @model.bind "change:errors", => @render()
  save: (e)->
    e.preventDefault()
    e.stopPropagation()
    @model.unset "errors"
    @collection.create @model.toJSON(),
      success: (widget)=>
        @model = widget
        window.location.hash = "/#{@model._id}"
      error: (widget, jqXHR)=> @model.set errors: $.parseJSON jqXHR.responseText
  render: ->
    $(@el).html @template @model.toJSON()
    @$("form").backboneLink @model
    @

class App.Views.Widgets.ShowView extends Backbone.View
  template: JST["backbone/templates/widgets/show"]
  render: ->
    $(@el).html @template @model.toJSON()
    @

class App.Views.Widgets.WidgetView extends Backbone.View
  template: JST["backbone/templates/widgets/widget"]
  events: "click .destroy": "destroy"
  tagName: "tr"
  destroy: ->
    @model.destroy()
    @remove()
    false
  render: ->
    $(@el).html @template @model.toJSON()
    @
