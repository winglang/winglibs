bring "./check.w" as c;

new c.Check(inflight () => { assert(false); }, testing: false);