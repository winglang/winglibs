bring http;

pub class SlackUtils {
  pub static inflight post(body: Json, token: str): Json {
    let slackApi = "https://slack.com/api/chat.postMessage";
    return http.post(
      slackApi,
      headers: {
        Authorization: "Bearer {token}",
        "Content-Type": "application/json"
      },
      body: Json.stringify(body)
    );
  }
}