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

# facebook-client (https://github.com/DracoBlue/node-facebook-client)
FacebookClient = require('facebook-client').FacebookClient
facebook_client = new FacebookClient '282526041801577', '6e63390355ab12ee2e2315c2fda19566'

# Connect Mongoose to MongoDB
mongoose.connect process.env.MONGOHQ_URL || 'mongodb://localhost/fanometer'

# Include Mongoose models
require('./models/like') mongoose

# Include Express resources
app.resource 'likes', require './resources/likes'

app.get '/', (request, response)-> response.render 'home', title: 'Hello World'

# Blitz
#app.get '/mu-2ab3bb76-48723d6a-b7f2d339-da840b46', (request, response)-> response.send '42'

app.listen process.env.PORT || 5000
