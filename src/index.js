require('./all.scss');

var elm_app = require('./app');
// module.exports = Elm.App.emded;

// console.log("WIP3", elm_app);

var app_element = document.getElementById('elm-app');
// var App = elm_app(app_element, JSON.parse(localStorage.session || "null"));
var App = elm_app(app_element, localStorage.session || null);

var ws_server;
// if(location.hostname.match(/github/)) {
if(location.hostname.match(/localhost/)) {
    ws_server = "ws://gsmopener.baden.space:9112/websocket";
} else {
    ws_server = "ws://" + location.hostname +":9112/websocket";
}

console.log("ws_server=", ws_server);

var websocket;

function connect()
{
    websocket = new WebSocket(ws_server);
    websocket.onopen = function(evt) { onOpen(evt) };
    websocket.onclose = function(evt) { onClose(evt) };
    websocket.onmessage = function(evt) { onMessage(evt) };
    websocket.onerror = function(evt) { onError(evt) };
};

function disconnect() {
    websocket.close();
};

function onOpen(evt) {
    App.ports.websocketOpen.send("Open");
};

function onClose(evt) {
    App.ports.websocketClose.send("Close");
};

function onMessage(evt) {
    var msg = JSON.parse(evt.data);
    console.log(["msg = ", msg]);
    App.ports.websocketMessage.send(msg);
};

function onError(evt) {
    App.ports.websocketError.send("Error");
};


App.ports.websocketConnect.subscribe(function(data) {
    console.log("websocketConnect", data);
    connect();
});

App.ports.websocketDisconnect.subscribe(function(data) {
    console.log("websocketDisconnect", data);
    disconnect();
});

App.ports.websocketSend.subscribe(function(data) {
    console.log("websocketSend", data);
    websocket.send(JSON.stringify(data));
});

App.ports.storeSession.subscribe(function(session) {
    console.log("storeSession", session);
    localStorage.session = session;
});

window.addEventListener("storage", function(event) {
    if (event.storageArea === localStorage && event.key === "session") {
        console.log(["onStorage", event.newValue]);
        App.ports.onSessionChange.send(JSON.parse(event.newValue));
    }
}, false);

App.ports.beep.subscribe(function(data) {
    console.log("beep", data);
    document.getElementsByTagName('audio')[0].play();
});

// document.body.addEventListener('touchstart', function() {
// // document.body.addEventListener('click', function() {
//   console.log("boo");
//   document.getElementsByTagName('audio')[0].play();
//   // if ("vibrate" in navigator) {
//   //   navigator.vibrate(1000);
//   // }
// });

// connect();

// setInterval(function() {
//     console.log("boo");
//     App.ports.websocketConnect.send("Hallo");
//
// }, 3000);


// require('./all.scss');
// require('bootstrap-css');
// var Elm = require('./App/App.elm');
// import Elm from './App/App.elm';
// const embed = require('./app.js');
// console.dir(embed);

// Не очень это помогает.
// document.addEventListener('touchmove', function (event) {
//   if (event.scale !== 1) { event.preventDefault(); }
// }, false);

// var element = document.getElementById('elm-app');
// var App = embed(element);
//
// // Copyright 2014-2017 The Bootstrap Authors
// // Copyright 2014-2017 Twitter, Inc.
// // Licensed under MIT (https://github.com/twbs/bootstrap/blob/master/LICENSE)
// if (navigator.userAgent.match(/IEMobile\/10\.0/)) {
//   var msViewportStyle = document.createElement('style');
//   msViewportStyle.appendChild(
//     document.createTextNode(
//       '@-ms-viewport{width:auto!important}'
//     )
//   );
//   document.head.appendChild(msViewportStyle);
// }
