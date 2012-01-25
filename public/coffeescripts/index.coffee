socket = io.connect window.location.hostname
socket.on 'message', (message)-> alert message

socket.send 'hello'

FB.init
  appId: '282526041801577'
  oauth: true
  xfbml: true
  status: true
  cookie: true

FB.login (response)->
  if (response.authResponse)
    alert response.authResponse.accessToken
, scope: 'email'
