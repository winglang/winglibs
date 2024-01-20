bring cloud;
bring "../handlers.w" as typescript;

let src = "./src";

new cloud.Function(new typescript.FunctionHandler(src));

let queue = new cloud.Queue();
queue.setConsumer(new typescript.QueueHandler(src));

let api = new cloud.Api();
api.get("/foo", new typescript.ApiEndpointHandler(src) as "foo");
api.post("/bar", new typescript.ApiEndpointHandler(src) as "bar");
