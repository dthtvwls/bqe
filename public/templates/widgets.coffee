@JST ||= {}

@JST["backbone/templates/widgets/edit"] = (obj)->
  __p = []
  print = -> __p.push.apply __p, arguments
  __p.push '<h1>Edit widget</h1>\n\n<form id="edit-widget" name="widget">\n  <input type="hidden" name="_method" value="put" >\n  <div class="field">\n    <label for="name"> name:</label>\n    <input type="text" name="name" id="name" value="', obj.name ,'" >\n  </div>\n\n  <div class="actions">\n    <input type="submit" value="Update Widget" />\n  </div>\n\n</form>\n\n<a href="#/index">Back</a>\n'
  __p.join ''

@JST["backbone/templates/widgets/index"] = (obj)->
  __p = []
  print = -> __p.push.apply __p, arguments
  __p.push '<h1>Listing widgets</h1>\n\n<table id="widgets-table">\n  <tr>\n    <th>Name</th>\n    <th></th>\n    <th></th>\n    <th></th>\n  </tr>\n</table>\n\n<br/>\n\n<a href="#/new">New Widget</a>\n'
  __p.join ''

@JST["backbone/templates/widgets/new"] = (obj)->
  __p = []
  print = -> __p.push.apply __p, arguments
  __p.push '<h1>New widget</h1>\n\n<form id="new-widget" name="widget">\n  <div class="field">\n    <label for="name"> name:</label>\n    <input type="text" name="name" id="name" value="', obj.name ,'" >\n  </div>\n\n  <div class="actions">\n    <input type="submit" value="Create Widget" />\n  </div>\n\n</form>\n\n<a href="#/index">Back</a>\n'
  __p.join ''

@JST["backbone/templates/widgets/show"] = (obj)->
  __p = []
  print = -> __p.push.apply __p, arguments
  __p.push '<p>\n  <b>Name:</b>\n  ', obj.name ,'\n</p>\n\n\n<a href="#/index">Back</a>\n'
  __p.join ''

@JST["backbone/templates/widgets/widget"] = (obj)->
  __p = []
  print = -> __p.push.apply __p, arguments
  __p.push '<td>', obj.name ,'</td>\n\n<td><a href="#/', obj._id ,'">Show</td>\n<td><a href="#/', obj._id ,'/edit">Edit</td>\n<td><a href="#/', obj._id ,'/destroy" class="destroy">Destroy</a></td>\n'
  __p.join ''
