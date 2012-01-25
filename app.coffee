express  = require 'express'
mongoose = require 'mongoose'
stylus   = require 'stylus'
public   = __dirname + '/public'

mongoose.connect process.env.MONGOHQ_URL || 'mongodb://localhost/fanometer'

app = express.createServer express.logger(), express.bodyParser(), express.methodOverride()

app.configure ->
  app.use express.errorHandler dumpExceptions: true, showStack: true
  app.use stylus.middleware src: public, compress: true
  app.use express.static public

app.get '/', (request, response)-> response.render 'index.jade', title: 'Hello World'

app.listen process.env.PORT || 5000
