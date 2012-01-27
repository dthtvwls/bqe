# index
exports.index = (req, res)->
  Like.find (err, likes)-> res.render 'likes/index', likes: likes

# new
exports.new = (req, res)-> res.render 'likes/new'

# create
exports.create = (req, res)->
  like = new Like req.body.like
  like.save (err)-> res.redirect "/likes/#{like.id}"

# show
exports.show = (req, res)->
  Like.findById req.params.like, (err, like)-> res.render 'likes/show', like: like

# edit
exports.edit = (req, res)->
  Like.findById req.params.like, (err, like)-> res.render 'likes/edit', like: like

# update
exports.update = (req, res)->
  Like.update { _id: req.params.like }, req.body.like, upset: true, (err)->
    res.redirect "/likes/#{req.params.like}"

# destroy
exports.destroy = (req, res)->
  Like.findById req.params.like, (err, like)-> like.remove (err)-> res.redirect '/likes'
