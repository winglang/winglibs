const express = require("express");
const { setLifted } = require("./clients");
const serverlessHttp = require("serverless-http");

var _clients = undefined;

const app = express();
app.use((req, res, next) => {
  setLifted(_clients);
  next();
});
app.use(
  express.urlencoded({
    extended: true,
  }),
);

app.use(express.json());

global["RegisterRoutes"].RegisterRoutes(app);
const handler = serverlessHttp(app);

exports.runHandler = async (event, context, clients) => {
  _clients = clients;

  const result = await handler(event, context);
  return result;
}
