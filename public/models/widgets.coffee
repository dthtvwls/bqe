class App.Models.Widget extends Backbone.Model
  idAttribute: '_id'
  paramRoot: 'widget'
  defaults: name: null

class App.Collections.Widgets extends Backbone.Collection
  model: App.Models.Widget
  url: '/widgets'
