express = require 'express'
mongoose = require('mongoose').connect process.env.MONGOHQ_URL || 'mongodb://localhost/yoyo'
require 'express-resource'
#require 'consolidate'

app = express.createServer().configure ->
  @use express.logger()
  @use express.bodyParser()
  @use express.cookieParser()
  @use express.methodOverride()
  @use express.static 'client'
  @use express.session secret: 'secret'
  @use require('stylus').middleware src: 'client', compress: true
  @set 'views', "#{__dirname}/views"
  @set 'view engine', 'jade'
  @use @router
.configure 'development', ->
  @use express.errorHandler dumpExceptions: true, showStack: true
.configure 'production', ->
  @use express.errorHandler
.listen process.env.PORT || 5000

require('./models/widget') mongoose

app.resource 'widgets', require './resources/widgets'


# Socket.IO (use xhr settings for Heroku/Joyent)
#options = transports: ['xhr-polling'], 'polling duration': 10
io = require('socket.io').listen(app).sockets.on 'connection', (socket)->

  # (debug) Listen for messages on connected sockets and send them back
  socket.on 'message', (message)-> socket.send message

  socket.on 'create', (data)->
    e = event 'create', data.signature
    data = []
    socket.emit e, id: 1

  socket.on 'read', (data)->
    e = event 'read', data.signature
    data = []
    data.push {}
    socket.emit e, data

  socket.on 'update', (data)->
    e = event 'update', data.signature
    data = []
    socket.emit e, success: true

  socket.on 'delete', (data)->
    e = event 'delete', data.signature
    data = []
    socket.emit e, success: true

event = (operation, sig)->
  e = operation + ':'
  e += sig.endPoint
  e += ':' + sig.ctx if sig.ctx
  e
