require('./all.scss');

var elm_app = require('./app');
// module.exports = Elm.App.emded;

// console.log("WIP3", elm_app);

var app_element = document.getElementById('elm-app');
var App = elm_app(app_element);

// console.log("App=", App);


const ws_server = "ws://localhost:9112/websocket";


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
    var msg = evt.data;
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
