$.getScript '/socket.io/socket.io.js', ->
  socket = io.connect window.location.hostname
  socket.on 'message', (message)-> alert message

  # If Socket.IO server is running correctly,
  # it will send our message back to the client
  #socket.send 'hello'

$.getScript '//connect.facebook.net/en_US/all.js', ->
  FB.init
    appId: '282526041801577'
    oauth: true
    xfbml: true
    status: true
    cookie: true
    channelUrl: 'https://fanometer.herokuapp.com/channel.html'

  # Login to FB account with permissions
  #FB.login (response)->
  #  alert response.authResponse.accessToken if response.authResponse
  #, scope: 'email'
