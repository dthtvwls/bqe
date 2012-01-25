express  = require 'express'
mongoose = require 'mongoose'
stylus   = require 'stylus'
public   = __dirname + '/public'

# Create the Express app
app = express.createServer express.logger, express.bodyParser, express.methodOverride

# Express configuration
app.configure ->
  app.use express.errorHandler dumpExceptions: true, showStack: true
  app.use stylus.middleware src: public, compress: true
  app.use express.static public
  app.use app.router

# Respond to application root
app.get '/', (request, response)-> response.render 'index.jade', title: 'Hello World'


# Set up Socket.IO with xhr settings for Heroku
io = require('socket.io').listen app,
  transports: ['xhr-polling'], transportOptions: 'xhr-polling': duration: 10000

# Listen for messages on connected sockets and send them back
io.sockets.on 'connection', (socket)-> socket.on 'message', (message)-> socket.send message


# Connect Mongoose to MongoDB
mongoose.connect process.env.MONGOHQ_URL || 'mongodb://localhost/fanometer'

# Include Mongoose models
Like = require(__dirname + '/models/like.coffee') mongoose


# Listen to HTTP
app.listen process.env.PORT || 5000
