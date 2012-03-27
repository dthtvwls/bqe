#$LAB
#.script('//ajax.googleapis.com/ajax/libs/jquery/1/jquery.min.js')
#.script('//cdnjs.cloudflare.com/ajax/libs/json2/20110223/json2.js')
#.script('//cdnjs.cloudflare.com/ajax/libs/underscore.js/1.3.1/underscore-min.js')
#.script('//cdnjs.cloudflare.com/ajax/libs/backbone.js/0.9.1/backbone-min.js')
#.script('//cdnjs.cloudflare.com/ajax/libs/handlebars.js/1.0.0.beta2/handlebars.min.js')
#.script('/socket.io/socket.io.js')
#.script('/templates/widgets.coffee')
#.script('/models/widgets.coffee')
#.script('/views/widgets.coffee')
#.script('/routers/widgets.coffee').wait ->

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

  # Set up Socket.IO on client
  window.socket = io.connect window.location.hostname
  window.socket.on 'message', (message)-> alert message


  window.App =
    Models: {}
    Collections: {}
    Routers: {}
    Views: {}


  methodMap =
    'create': 'POST'
    'update': 'PUT'
    'delete': 'DELETE'
    'read'  : 'GET'

  getUrl = (object)->
    return null unless object and object.url
    if _.isFunction object.url then object.url() else object.url

  urlError = -> throw new Error "A 'url' property or function must be specified"


  # Override sync method
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
