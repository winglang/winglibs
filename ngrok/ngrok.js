const ngrok = require('@ngrok/ngrok');

async function main(url, domain) {
  const x = await ngrok.forward({ addr: url, domain, authtoken_from_env: true, proto: "http" });
  return x.url();
}

const url = process.argv[2];
const domain = process.argv[3];

main(url, domain)
  .then((url) => process.stdout.write(url))
  .catch((e) => process.stderr.write(e.message));

process.on("SIGINT", () => ngrok.kill().then(() => process.exit(0)));
process.stdin.resume();
