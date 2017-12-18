const Elm = require('./App/App.elm');

console.log("Elm=", Elm, Elm.ports);

// Elm.Main.

module.exports = Elm.Main.embed;
