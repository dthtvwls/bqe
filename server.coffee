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

# Socket.IO configuration
io = require('./socket') app

# facebook-client (https://github.com/DracoBlue/node-facebook-client)
FacebookClient = require('facebook-client').FacebookClient
facebook_client = new FacebookClient '282526041801577', '6e63390355ab12ee2e2315c2fda19566'

# Connect Mongoose to MongoDB
mongoose.connect process.env.MONGOHQ_URL || 'mongodb://localhost/fanometer'

# Include Mongoose models
require('./models/like') mongoose

# Include Express resources
app.resource 'likes', require './resources/likes'

app.get '/', (request, response)-> response.render 'index', title: 'Hello'

app.listen process.env.PORT || 5000
