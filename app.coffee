exp = require 'express'
mon = require 'mongoose'
pub = __dirname + '/public'

app = exp.createServer exp.logger(), exp.bodyParser(), exp.methodOverride()

mon.connect process.env.MONGOHQ_URL || 'mongodb://localhost/fanometer'

app.configure ->
  app.use exp.errorHandler dumpExceptions: true, showStack: true
  app.use require('stylus').middleware src: pub, compress: true
  app.use exp.static pub

app.get '/', (req, res)-> res.render 'index.jade', title: 'Hello World'

app.listen process.env.PORT || 5000
