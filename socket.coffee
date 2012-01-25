module.exports = (app)->
  # Set up Socket.IO with xhr settings for Heroku
  io = require('socket.io').listen app, transports: ['xhr-polling'], 'polling duration': 10

  # Listen for messages on connected sockets and send them back
  io.sockets.on 'connection', (socket)-> socket.on 'message', (message)-> socket.send message

  io
