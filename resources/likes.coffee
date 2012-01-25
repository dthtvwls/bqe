# index
exports.index = (request, response)->
  likes = Like.find {}, (error, likes)->
    response.render 'likes/index', title: 'title', likes: likes

# new
exports.new = (request, response)->
  response.render 'likes/new', title: 'title'

# create
exports.create = (request, response)->
  like = new Like request.body.like
  like.save()
  response.writeHead 303, 'Location': '/likes/' + like.id
  response.end()

# show
exports.show = (request, response)->
  Like.findById request.params.like, (error, like)->
    response.render 'likes/show', title: 'title', like: like

# edit
exports.edit = (request, response)->
  Like.findById request.params.like, (error, like)->
    response.render 'likes/edit', title: 'title', like: like

# update
exports.update = (request, response)->
  Like.update { id: request.params.like }, (error, like)->
    response.render 'likes/show', title: request.params, like: like

# destroy
exports.destroy = (request, response)->
  console.log request.params.like
