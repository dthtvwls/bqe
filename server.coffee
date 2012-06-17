mongoose = require('mongoose').connect process.env.MONGOHQ_URL || 'mongodb://localhost/bqe'
express  = require 'express'
gzippo   = require 'gzippo'
require 'express-resource'

Widget = mongoose.model 'Widget', new mongoose.Schema
  name: String

app = express.createServer().configure ->
  @set 'views', "#{__dirname}/public/templates"
  @set 'view engine', 'hbs'
  @use express.logger()
  @use express.bodyParser()
  @use express.methodOverride()
  @use express.cookieParser 'changeme'
  @use express.session secret: 'changeme'
  @use @router
.configure 'development', ->
  @use require('stylus').middleware
    compress: true
    src: 'public'
  @use express.static 'public'
  @use express.errorHandler
    dumpExceptions: true
    showStack: true
.configure 'production', ->
  @use gzippo.staticGzip 'public'
  @use express.errorHandler()
.helpers
  env: -> app.settings.env+'' || process.env
.dynamicHelpers
  user:    (req, res)-> req.user
  flash:   (req, res)-> req.flash()
  session: (req, res)-> req.session
.listen process.env.PORT || 3000

app.get '/', (req, res)-> res.render ''
app.resource 'widgets', require './widgets'

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
