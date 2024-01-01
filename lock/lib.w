bring expect;
bring util;
bring cloud;
bring math;

pub struct LockAcquireOptions {
  timeout: duration;
  expiry: duration?;
}

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
  pub inflight tryAcquire(id: str, options: LockAcquireOptions): bool {
    try {
      this.acquire(id, options);
      return true;
    } catch {
      return false;
    }
  }

  inflight releaseIfExpired(id: str) {
    let now = datetime.systemNow().timestampMs;
    let expiry = this.counter.peek("{id}-expiry");
    if expiry == 0 {
      return;
    }
    if now < expiry {
      return;
    }
    if this.tryAcquire("{id}-expiry-lock", timeout:1ms) {
      let expiry = this.counter.peek("{id}-expiry");
      let expired = expiry != 0 && now > expiry;
      if expired {
        this.counter.set(0, "{id}-expiry");
      }
      this.release("{id}-expiry-lock");
      this.release(id);
      return;
    }
    log("releaseIfExpired({id}): failed to acquire {id}-expiry-lock");
    return;
  }
  /** 
    try to acquire lock with id
    @id the name of the lock
    @timeout the time to try acquiring the lock
    @throws if failed to acquire a lock within the timeout
  */
  pub inflight acquire(id: str, options: LockAcquireOptions){
    let acquired = util.waitUntil(inflight () => {
        this.releaseIfExpired(id);
        let peeked = this.counter.peek(id);
        if (peeked != 0) {
          return false;
        }
        let value = this.counter.inc(1, id);
        
        if value == 0 {
          if let expiry = options.expiry {
            this.acquire("{id}-expiry-lock", timeout:options.timeout);
            this.counter.set(datetime.systemNow().timestampMs + expiry.milliseconds, "{id}-expiry");
            this.release("{id}-expiry-lock");
          }
          return true;
        }
        let preDec = this.counter.dec(1, id);
        // randomize sleep time to prevent livelock
        // util.sleep(duration.fromMilliseconds(100 * math.random()));
        return false;
      }, timeout: options.timeout);
      if !acquired {
        throw "Failed to acquire lock, timeout {options.timeout.seconds} seconds reached";
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
    this.counter.set(0, "{id}-expiry");
    this.counter.dec(1, id);
  }
}
