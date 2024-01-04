const { matchesPattern } = require('./match');

const tests = [
  {
      event: { "source": "aws.ec2", "detail-type": "EC2 Instance State-change Notification", "detail": { "state": "terminated" }},
      pattern: { "source": ["aws.ec2"], "detail-type": ["EC2 Instance State-change Notification"], "detail": { "state": ["terminated"] }},
      expected: true
  },
  {
    event: { "source": "aws.ec2", "detail-type": "EC2 Instance State-change Notification", "detail": { "state": "terminated" }},
    pattern: { "source": [{"prefix": "aws"}], "detail-type": ["EC2 Instance State-change Notification"], "detail": { "state": [{"prefix": "term"}] }},
    expected: true
  },
  {
      event: { "source": "aws.ec2", "region": "us-east-1" },
      pattern: { "source": ["aws.ec2"], "region": [{ "prefix": "us-" }] },
      expected: true
  },
  {
      event: { "fileName": "example.png" },
      pattern: { "fileName": [{ "suffix": ".png" }] },
      expected: true
  },
  {
      event: { "fileName": "test/example.png" },
      pattern: { "fileName": [{ "wildcard": "test/*.png" }] },
      expected: true
  },
  {
      event: { "name": "Alice" },
      pattern: { "name": [{ "equals-ignore-case": "alice" }] },
      expected: true
  },
  {
      event: { "price": 100 },
      pattern: { "price": [{ "numeric": ["=", 100] }] },
      expected: false  // Currently, numeric comparisons are not implemented
  }
];

tests.forEach((test, index) => {
  console.log(`Test ${index + 1}:`, matchesPattern(test.event, test.pattern) === test.expected ? 'Pass' : 'Fail');
});
