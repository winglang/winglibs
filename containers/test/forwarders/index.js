#!/usr/bin/env node
const http = require('http');

const requests = [];

process.on('SIGTERM', () => {
  console.info("Interrupted")
  process.exit(0)
});

const server = http.createServer((req, res) => {

  if (req.url === '/requests') {
    res.writeHead(200, { 'Content-Type': 'application/json' });
    return res.end(JSON.stringify(requests));
  }

  console.log(`request received: ${req.method} ${req.url}`);

  const body = [];
  req.on("data", (data) => {
    body.push(data);
  });

  req.on("end", () => {
    let s = Buffer.concat(body).toString();
    if (s.length === 0) {
      s = undefined;
    }

    requests.push({
      method: req.method,
      url: req.url,
      body: s,
    });

    res.end('OK');
  });
});

console.log('listening on port 3000');
server.listen(3000);