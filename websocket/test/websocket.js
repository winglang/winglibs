const WebSocket = require("ws");
// var WebSocketClient = require('websocket').client;

var senderSocket = {};
var socketReceiver = {};

const onSocketOpen = () => {
  socket.send(JSON.stringify({
    action: "broadcast",
    message: "ok"
  }));
}

const onSocketClose = () => {
  socket.send(JSON.stringify({
    action: "broadcast",
    message: "goodbye"
  }));
}

const onSocketMessage = () => {
  socket.send(JSON.stringify({
    action: "broadcast",
    message: "message"
  }));
}

exports._broadcastMessage = function (url, msg) {
  if (senderSocket.readyState != WebSocket.OPEN) {
    senderSocket = new WebSocket(url);

    while (senderSocket.readyState != WebSocket.OPEN) { }

    senderSocket.send(JSON.stringify({
      action: "broadcast",
      message: msg
    }));
  }
}

exports._openSenderSocket = function (url) {
  if (senderSocket.readyState != WebSocket.OPEN) {
    return new WebSocket(url);
  }
}

// exports._openSender = function (url) {
//   if (socket.readyState != WebSocket.OPEN) {
//     socketSender = new WebSocket(url);
    // socket.addEventListener('open', onSocketOpen);
    // socket.addEventListener('close', onSocketClose);
    // socket.addEventListener('message', (event) => {
    //   onSocketMessage(event.data);
    // });
//   }
// }
