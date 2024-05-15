#!/usr/bin/env node
const http = require('http');

process.on('SIGTERM', () => {
  console.info("Interrupted")
  process.exit(0)
});

const server = http.createServer((req, res) => {
  console.log(`request received: ${req.method} ${req.url}`);
  res.setHeader('Content-Type', 'application/json');
  res.end(JSON.stringify({ result: 12 }));
});

console.log('listening on port 4000');
server.listen(4000);

