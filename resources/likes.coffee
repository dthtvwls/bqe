module.exports = (Like)->
  exports.Like = Like
  module.exports

# index
module.exports.index = (request, response)->
  likes = exports.Like.find {}, (error, likes)->
    response.render 'likes/index', title: 'title', likes: likes

# new
module.exports.new = (request, response)->
  response.render 'likes/new', title: 'title'

# create
module.exports.create = (request, response)->
  like = new exports.Like request.body.like
  like.save()
  response.writeHead 303, 'Location': '/likes/' + like.id
  response.end()

# show
module.exports.show = (request, response)->
  exports.Like.findById request.params.like, (error, like)->
    response.render 'likes/show', title: 'title', like: like

# edit
module.exports.edit = (request, response)->
  exports.Like.findById request.params.like, (error, like)->
    response.render 'likes/edit', title: 'title', like: like

# update
module.exports.update = (request, response)->
  exports.Like.update { id: request.params.like }, (error, like)->
    response.render 'likes/show', title: request.params, like: like

# destroy
module.exports.destroy = (request, response)->
  console.log request.params.like
