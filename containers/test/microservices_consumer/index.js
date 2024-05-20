#!/usr/bin/env node
const PRODUCER_URL = process.env.PRODUCER_URL;
const http = require('http');

if (!PRODUCER_URL) {
  console.error("PRODUCER_URL is not set");
  process.exit(1);
}

process.on('SIGTERM', () => {
  console.info("Interrupted")
  process.exit(0)
});

const server = http.createServer((req, res) => {
  console.log(`request received: ${req.method} ${req.url}`);
  console.log(`PRODUCER_URL: ${PRODUCER_URL}`);
  res.setHeader('Content-Type', 'application/json');

  fetch(PRODUCER_URL)
    .then(r => r.json().then(json => res.end(JSON.stringify({ producer_result: json }))))
    .catch(e => {
      console.error(e);
      res.statusCode = 500;
      res.end(JSON.stringify({ 
        producer_url: PRODUCER_URL,
        error: e.message 
      }));
    });
});

console.log('listening on port 3000');
server.listen(3000);
