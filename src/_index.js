const Elm = require('./Main');

const elm = Elm.Main.fullscreen({
  config: {
    urlApiRest: process.env.API_URL_REST,
    urlApiWebsocket: process.env.API_URL_WEBSOCKET
  },
  auth: {
    accessToken: localStorage.getItem('access_token') ? localStorage.getItem('access_token') : '',
    idToken: localStorage.getItem('id_token') ? localStorage.getItem('id_token') : '',
    expiresAt: localStorage.getItem('expires_at') ? localStorage.getItem('expires_at') : ''
  }
});

elm.ports.login.subscribe(() => {
  webAuth.authorize();
});

elm.ports.logout.subscribe(() => {
  logout();
  elm.ports.updateAuth.send({
    accessToken: '',
    idToken: '',
    expiresAt: ''
  });
});

//
// Auth0
//

var tokenRenewalTimeout;

const webAuth = new auth0.WebAuth({
  domain: `${process.env.AUTH0_DOMAIN}`,
  clientID: `${process.env.AUTH0_CLIENT_ID}`,
  responseType: 'token id_token',
  audience: `${process.env.AUTH0_AUDIENCE}`,
  scope: 'openid',
  redirectUri: window.location.href
});

function handleAuthentication() {
  webAuth.parseHash((err, authResult) => {
    if (authResult && authResult.accessToken && authResult.idToken) {
      window.location.hash = '';
      setSession(authResult);

      elm.ports.updateAuth.send({
        accessToken: localStorage.getItem('access_token') ? localStorage.getItem('access_token') : '',
        idToken: localStorage.getItem('id_token') ? localStorage.getItem('id_token') : '',
        expiresAt: localStorage.getItem('expires_at') ? localStorage.getItem('expires_at') : ''
      });
    } else if (err) {
      console.log(err);
      alert(
        'Error: ' + err.error + '. Check the console for further details.'
      );
    }
  });
}

function setSession(authResult) {
  var expiresAt = JSON.stringify(
    authResult.expiresIn * 1000 + new Date().getTime()
  );
  localStorage.setItem('access_token', authResult.accessToken);
  localStorage.setItem('id_token', authResult.idToken);
  localStorage.setItem('expires_at', expiresAt);
  scheduleRenewal();
}

function logout() {
  clearTimeout(tokenRenewalTimeout);
  localStorage.removeItem('access_token');
  localStorage.removeItem('id_token');
  localStorage.removeItem('expires_at');
  window.location = `${process.env.AUTH0_LOGOUT_URL}`;
}

function renewToken() {
  webAuth.checkSession({},
    function(err, result) {
      if (err) {
        console.log(err);
      } else {
        setSession(result);
      }
    }
  );
}

function scheduleRenewal() {
  var expiresAt = JSON.parse(localStorage.getItem('expires_at'));
  // if the token is expired renew it, otherwise schedule renewal
  if (Date.now() > expiresAt) {
    renewToken();
  } else {
    var delay = expiresAt - Date.now();
    if (delay > 0) {
      tokenRenewalTimeout = setTimeout(function() {
        renewToken();
      }, delay);
    }
  }
}

window.addEventListener('load', function() {
  scheduleRenewal();
});

handleAuthentication();

if (module.hot) {
  module.hot.dispose(() => {
    window.location.reload();
  });
}