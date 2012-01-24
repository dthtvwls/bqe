FB.init
  appId: '282526041801577'
  oauth: true
  xfbml: true
  status: true
  cookie: true

FB.login (res)->
  if (res.authResponse)
    alert res.authResponse.accessToken
, scope: 'email'