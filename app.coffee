express  = require 'express'
resource = require 'express-resource'
mongoose = require 'mongoose'

# Connect Mongoose to MongoDB
mongoose.connect process.env.MONGOHQ_URL || 'mongodb://localhost/bqe'

# Include Mongoose models
require('./models/widget') mongoose

# Express configuration
app = express.createServer().configure ->
  @use express.logger()
  @use express.bodyParser()
  @use express.cookieParser()
  @use express.methodOverride()
  @use express.static './public'
  @use express.session secret: 'secret'
  @use express.errorHandler dumpExceptions: true, showStack: true
  @use require('stylus').middleware src: './public', compress: true
  @set 'view engine', 'jade'
  @use @router

# Socket.IO server
io = require('./socket') app

# Include Express resources
app.resource 'widgets', require './resources/widgets'

app.listen process.env.PORT || 5000
