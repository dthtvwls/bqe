express  = require 'express'
resource = require 'express-resource'
mongoose = require('mongoose').connect process.env.MONGOHQ_URL || 'mongodb://localhost/bqe'

# Express configuration
app = express.createServer().configure ->
  @use express.logger()
  @use express.bodyParser()
  @use express.cookieParser()
  @use express.methodOverride()
  @use express.static 'client'
  @use express.session secret: 'secret'
  @use express.errorHandler dumpExceptions: true, showStack: true
  @use require('stylus').middleware src: 'client', compress: true
  @set 'views', "#{__dirname}/views"
  @set 'view engine', 'jade'
  @use @router

# Mongoose models
require('./models/widget') mongoose

# Express resources
app.resource 'widgets', require './resources/widgets'

app.listen process.env.PORT || 5000

# Socket.IO (use xhr settings for Heroku/Joyent)
# require('socket.io').listen app, transports: ['xhr-polling'], 'polling duration': 10
io = require('socket.io').listen(app).sockets.on 'connection', (socket)->

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

  # Listen for messages on connected sockets and send them back
  socket.on 'message', (message)-> socket.send message

event = (operation, sig)->
  e = operation + ':'
  e += sig.endPoint
  e += ':' + sig.ctx if sig.ctx
  e
