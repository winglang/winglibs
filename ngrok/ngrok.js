// ngrok version:

// const ngrok = require('@ngrok/ngrok');

// async function main(url, domain) {
//   const x = await ngrok.forward({ addr: url, authtoken_from_env: true, proto: "http" });
//   return x.url();
// }

// const url = process.argv[2];
// const domain = process.argv[3];

// main(url, domain)
//   .then((url) => process.stdout.write(url))
//   .catch((e) => process.stderr.write(e.message));

// process.on("SIGINT", () => ngrok.kill().then(() => process.exit(0)));
// process.stdin.resume();

// untun version:

const { startTunnel } = require("untun");

async function main(url) {
  const x = await startTunnel({ url, acceptCloudflareNotice: true, protocol: "http" });
  const weburl = await x.getURL();
  return weburl;
}

const url = process.argv[2];

main(url)
  .then((url) => process.stdout.write("url=" + url))
  .catch((e) => process.stderr.write(e.message));

process.on("SIGINT", () => process.exit(0));
process.stdin.resume();
