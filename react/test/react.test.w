bring "../react.w" as r;

let app = new r.React("./my-react-app");

test "get url of app" {
  log(app.url);
}