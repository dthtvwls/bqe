express  = require 'express'
resource = require 'express-resource'
mongoose = require 'mongoose'
stylus   = require 'stylus'

# Create the Express app
app = express.createServer express.logger(), express.bodyParser(), express.methodOverride()

# Express configuration
app.configure ->
  app.use express.errorHandler dumpExceptions: true, showStack: true
  app.use stylus.middleware src: './public', compress: true
  app.use express.static './public'
  app.set 'view engine', 'jade'
  app.use app.router

# Connect Mongoose to MongoDB
mongoose.connect process.env.MONGOHQ_URL || 'mongodb://localhost/fanometer'

# Include Mongoose models
Like = require('./models/like') mongoose

# Include Express resources
likes = app.resource 'likes', require('./resources/likes') Like


# Set up Socket.IO with xhr settings for Heroku
io = require('socket.io').listen app,
  transports: ['xhr-polling'], transportOptions: 'xhr-polling': duration: 10000

# Listen for messages on connected sockets and send them back
io.sockets.on 'connection', (socket)-> socket.on 'message', (message)-> socket.send message


app.get '/', (request, response)-> response.render 'index', title: 'Hello World'

app.listen process.env.PORT || 5000
