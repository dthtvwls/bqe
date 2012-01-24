exp = require 'express'
app = exp.createServer exp.logger()

app.use exp.static __dirname + '/public'

app.listen process.env.PORT || 3000
