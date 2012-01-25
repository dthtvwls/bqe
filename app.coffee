express  = require 'express'
resource = require 'express-resource'
mongoose = require 'mongoose'

# Create the Express app
app = express.createServer express.logger(), express.bodyParser(), express.methodOverride()

# Express configuration
app.configure ->
  app.use express.errorHandler dumpExceptions: true, showStack: true
  app.use require('stylus').middleware src: './public', compress: true
  app.use express.static './public'
  app.set 'view engine', 'jade'
  app.use app.router

# Set up Socket.IO with xhr settings for Heroku
io = require('socket.io').listen app, transports: ['xhr-polling'], 'polling duration': 10

# Listen for messages on connected sockets and send them back
io.sockets.on 'connection', (socket)-> socket.on 'message', (message)-> socket.send message

# Connect Mongoose to MongoDB
mongoose.connect process.env.MONGOHQ_URL || 'mongodb://localhost/fanometer'

# Include Mongoose models
require('./models/like') mongoose

# Include Express resources
app.resource 'likes', require './resources/likes'

app.get '/', (request, response)-> response.render 'home', title: 'Hello World'

app.listen process.env.PORT || 5000
