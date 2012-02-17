module.exports = (app)->

  # Set up Socket.IO (use xhr settings for Heroku/Joyent)
  io = require('socket.io').listen app#, transports: ['xhr-polling'], 'polling duration': 10

  event = (operation, sig)->
    e = operation + ':'
    e += sig.endPoint
    e += ':' + sig.ctx if sig.ctx
    e

  io.sockets.on 'connection', (socket)->

    socket.on 'create', (data)->
      e = event 'create', data.signature
      data = []
      socket.emit e, id: 1

    socket.on 'read', (data)->
      e = event 'read', data.signature
      data = []
      data.push {}
      socket.emit e, data

    socket.on 'update', (data)->
      e = event 'update', data.signature
      data = []
      socket.emit e, success: true

    socket.on 'delete', (data)->
      e = event 'delete', data.signature
      data = []
      socket.emit e, success: true

    # Listen for messages on connected sockets and send them back
    socket.on 'message', (message)-> socket.send message