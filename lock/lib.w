bring expect;
bring util;
bring cloud;
bring math;

pub class Lock {
  counter: cloud.Counter;
  new() {
    this.counter = new cloud.Counter();
  }

  /** 
    try to acquire lock with id
    @id the name of the lock
    @timeout the time to try acquiring the lock
    @returns true if success, false if timeout is reached
  */
  pub inflight tryAcquire(id: str, timeout: duration): bool {
    try {
      this.acquire(id, timeout);
      return true;
    } catch {
      return false;
    }
  }

  /** 
    try to acquire lock with id
    @id the name of the lock
    @timeout the time to try acquiring the lock
    @throws if failed to acquire a lock within the timeout
  */
  pub inflight acquire(id: str, timeout: duration){
    let acquired = util.waitUntil(inflight () => {
        let value = this.counter.inc(1, id);
        if value == 0 {
            return true;
        }
        let preDec = this.counter.dec(1, id);
        // randomize sleep time to prevent livelock
        // util.sleep(duration.fromMilliseconds(100 * math.random()));
        return false;
      }, timeout: timeout);
      if !acquired {
        throw "Failed to acquire lock, timeout {timeout.seconds} seconds reached";
      }
  }

  /** 
    Release the lock
    @id the name of the lock
    @returns false if lock is not locked
  */
  pub inflight tryRelease(id: str): bool {
    try {
      this.release(id);
      return true;
    } catch {
      return false;
    }
  }
  /** 
    Release the lock
    @id the name of the lock
    @throws an exception if lock is not locked
  */
  pub inflight release(id: str) {
    if this.counter.peek(id) <= 0 {
      throw "Lock is not being held";
    }
    let val1 = this.counter.dec(1, id);
  }
}
