bring http;

pub class SlackUtils {
  pub static inflight post(body: Json, botToken: str) {
    let slackApi = "https://slack.com/api/chat.postMessage";
    http.post(
      slackApi,
      headers: {
        Authorization: "Bearer {botToken}",
        "Content-Type": "application/json"
      },
      body: Json.stringify(body)
    );
  }
}