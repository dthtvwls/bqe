module.exports = (mongoose)->
  global.Like = mongoose.model 'Like', new mongoose.Schema
    email: String
