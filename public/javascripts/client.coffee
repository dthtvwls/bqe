# Create Socket.IO client
socket = io.connect window.location.hostname

# Add message listener
socket.on 'message', (message)-> alert message

# If Socket.IO server is running correctly,
# it will send our message back to the client
#socket.send 'hello'

# Facebook init
FB.init
  appId: '282526041801577'
  oauth: true
  xfbml: true
  status: true
  cookie: true

# Login to FB account with permissions
FB.login (response)->
  #alert response.authResponse.accessToken if response.authResponse
, scope: 'email'
