window.socket = io.connect window.location.hostname
window.socket.on 'message', (message)-> alert message



methodMap =
  'create': 'POST'
  'update': 'PUT'
  'delete': 'DELETE'
  'read'  : 'GET'

getUrl = (object)->
  return null unless object and object.url
  if _.isFunction object.url then object.url() else object.url

urlError = -> throw new Error "A 'url' property or function must be specified"

Backbone.sync = (method, model, options)->

  type = methodMap[method]

  # Default JSON-request options.
  params = _.extend
    type: type
    dataType: 'json'
    contentType: 'application/json'
    beforeSend: (xhr)->
      token = $('meta[name="csrf-token"]').attr 'content'
      xhr.setRequestHeader 'X-CSRF-Token', token if token
      model.trigger 'sync:start'
  , options

  params.url = getUrl(model) or urlError() unless params.url

  # Ensure that we have the appropriate request data.
  if !params.data and model and (method == 'create' or method == 'update')
    data = {}
    if model.paramRoot
      data[model.paramRoot] = model.toJSON()
    else
      data = model.toJSON()

    params.data = JSON.stringify data

  # Dont process data on a non-GET request.
  params.processData = false unless params.type == 'GET'

  # Trigger the sync end event
  complete = options.complete
  params.complete = (jqXHR, textStatus)->
    model.trigger 'sync:end'
    complete jqXHR, textStatus if complete

  # Make the request.
  $.ajax params

  #alert JSON.stringify params
###
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
###


do ($)->
  $.extend $.fn,
    backboneLink: (model)->
      $(@).find(":input").each ->
        el = $ @
        name = el.attr "name"
        model.bind "change:" + name, -> el.val model.get name
        $(@).bind "change", ->
          el = $ @
          attrs = {}
          attrs[el.attr("name")] = el.val()
          model.set attrs



window.App =
  Models: {}
  Collections: {}
  Routers: {}
  Views: {}



class App.Models.Widget extends Backbone.Model
  idAttribute: '_id'
  paramRoot: 'widget'
  defaults: name: null

class App.Collections.WidgetsCollection extends Backbone.Collection
  model: App.Models.Widget
  url: '/widgets'



@JST ||= {}

@JST["backbone/templates/widgets/edit"] = (obj)->
  __p = []
  print = -> __p.push.apply __p, arguments
  __p.push '<h1>Edit widget</h1>\n\n<form id="edit-widget" name="widget">\n  <div class="field">\n    <label for="name"> name:</label>\n    <input type="text" name="name" id="name" value="', obj.name ,'" >\n  </div>\n\n  <div class="actions">\n    <input type="submit" value="Update Widget" />\n  </div>\n\n</form>\n\n<a href="#/index">Back</a>\n'
  __p.join ''

@JST["backbone/templates/widgets/index"] = (obj)->
  __p = []
  print = -> __p.push.apply __p, arguments
  __p.push '<h1>Listing widgets</h1>\n\n<table id="widgets-table">\n  <tr>\n    <th>Name</th>\n    <th></th>\n    <th></th>\n    <th></th>\n  </tr>\n</table>\n\n<br/>\n\n<a href="#/new">New Widget</a>\n'
  __p.join ''

@JST["backbone/templates/widgets/new"] = (obj)->
  __p = []
  print = -> __p.push.apply __p, arguments
  __p.push '<h1>New widget</h1>\n\n<form id="new-widget" name="widget">\n  <div class="field">\n    <label for="name"> name:</label>\n    <input type="text" name="name" id="name" value="', obj.name ,'" >\n  </div>\n\n  <div class="actions">\n    <input type="submit" value="Create Widget" />\n  </div>\n\n</form>\n\n<a href="#/index">Back</a>\n'
  __p.join ''

@JST["backbone/templates/widgets/show"] = (obj)->
  __p = []
  print = -> __p.push.apply __p, arguments
  __p.push '<p>\n  <b>Name:</b>\n  ', obj.name ,'\n</p>\n\n\n<a href="#/index">Back</a>\n'
  __p.join ''

@JST["backbone/templates/widgets/widget"] = (obj)->
  __p = []
  print = -> __p.push.apply __p, arguments
  __p.push '<td>', obj.name ,'</td>\n\n<td><a href="#/', obj._id ,'">Show</td>\n<td><a href="#/', obj._id ,'/edit">Edit</td>\n<td><a href="#/', obj._id ,'/destroy" class="destroy">Destroy</a></td>\n'
  __p.join ''



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



class App.Routers.WidgetsRouter extends Backbone.Router
  initialize: (options)->
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
