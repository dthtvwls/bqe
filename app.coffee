express  = require 'express'
mongoose = require 'mongoose'
stylus   = require 'stylus'
public   = __dirname + '/public'

require __dirname + '/models/like.coffee'

# Create the Mongoose connection
mongoose.connect process.env.MONGOHQ_URL || 'mongodb://localhost/fanometer'

# Create the Express app
app = express.createServer express.logger(), express.bodyParser(), express.methodOverride()

# Express configuration
app.configure ->
  app.use express.errorHandler dumpExceptions: true, showStack: true
  app.use stylus.middleware src: public, compress: true
  app.use express.static public

# Set up Socket.IO
io = require('socket.io').listen app
io.set 'transports', ['xhr-polling']
io.set 'polling duration', 10
io.sockets.on 'connection', (socket)->
  socket.on 'message', (message)->
    socket.send message

# Respond to application root
app.get '/', (request, response)-> response.render 'index.jade', title: 'Hello World'

# Listen to HTTP
app.listen process.env.PORT || 5000
