module.exports = (mongoose)->
  global.Like = mongoose.model 'Like', new mongoose.Schema
    fb_id: String
    email: String
