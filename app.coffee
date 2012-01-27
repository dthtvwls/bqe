express  = require 'express'
resource = require 'express-resource'
mongoose = require 'mongoose'

# Express configuration
app = express.createServer().configure ->
  @use express.logger()
  @use express.bodyParser()
  @use express.cookieParser()
  @use express.methodOverride()
  #@use express.session secret: 'secret'
  @use express.errorHandler dumpExceptions: true, showStack: true
  @use require('stylus').middleware src: './public', compress: true
  @use express.static './public'
  @set 'view engine', 'jade'
  @use @router

# Socket.IO server
io = require('./socket') app

# Connect Mongoose to MongoDB
mongoose.connect process.env.MONGOHQ_URL || 'mongodb://localhost/pelvis'

# Include Mongoose models
require('./models/like') mongoose

# Include Express resources
app.resource 'likes', require './resources/likes'

app.get '/', (req, res)-> res.render 'index'

app.listen process.env.PORT || 3000
