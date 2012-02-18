# index
exports.index = (req, res)->
  Widget.find (err, widgets)-> res.render 'widgets/index', widgets: widgets

# new
exports.new = (req, res)-> res.render 'widgets/new'

# create
exports.create = (req, res)->
  widget = new Widget req.body.widget
  widget.save (err)-> res.redirect "/widgets/#{widget.id}"

# show
exports.show = (req, res)->
  Widget.findById req.params.widget, (err, widget)-> res.render 'widgets/show', widget: widget

# edit
exports.edit = (req, res)->
  Widget.findById req.params.widget, (err, widget)-> res.render 'widgets/edit', widget: widget

# update
exports.update = (req, res)->
  Widget.update { _id: req.params.widget }, req.body.widget, upset: true, (err)->
    res.redirect "/widgets/#{req.params.widget}"

# destroy
exports.destroy = (req, res)->
  Widget.findById req.params.widget, (err, widget)-> widget.remove (err)-> res.redirect '/widgets'
