bring "./check.w" as c;
bring "./results.w" as r;
bring http;
bring expect;

pub struct CheckHttpProps extends c.CheckProps {
  method: http.HttpMethod?; // http method (default "GET")
  path: str?;               // url path
  status: num?; // expected status
  body: str?;   // expected body contents
}

pub class CheckHttp impl c.ICheck {
  inner: c.Check;

  new(url: str, options: CheckHttpProps?) {
    this.inner = new c.Check(inflight () => {
      let var full_url: str = url;
      if let path = options?.path {
        let var sep = "/";
        if path.startsWith("/") {
          sep = "";
        }

        full_url = full_url + sep + path;
      }

      let method = options?.method ?? http.HttpMethod.GET;
      log("http ${method} ${full_url}");
      let response = http.fetch(full_url, method: method);
      log("status ${response.status}");
      
      expect.equal(response.status, options?.status ?? 200);

      if let body = options?.body {
        expect.equal(response.body?.contains(body), true);
      }
    }, options) as "check";
  }

  pub inflight run(): r.CheckResult {
    return this.inner.run();
  }

  pub inflight latest(): r.CheckResult? {
    return this.inner.latest();
  }
}