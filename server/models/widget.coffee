module.exports = (mongoose)->
  global.Widget = mongoose.model 'Widget', new mongoose.Schema
    name: String
