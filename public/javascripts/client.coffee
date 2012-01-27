socket = io.connect window.location.hostname

socket.on 'message', (message)->
  alert message

# If Socket.IO server is running correctly,
# it will send our message back to the client
#socket.send 'hello'
