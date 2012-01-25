module.exports = (mongoose)->
  mongoose.model 'Like', new mongoose.Schema
    fb_id: String
    email: String
