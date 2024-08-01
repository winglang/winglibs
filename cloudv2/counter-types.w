// TODO: Default values for struct fields - https://github.com/winglang/wing/issues/3121

pub struct CounterProps {
  /// The initial value of the counter
  /// @default 0
  initial: num?;
}

pub interface ICounter {
  /// Increments the counter atomically by a certain amount and returns the previous value.
  /// - `amount` The amount to increment by (defaults to 1)
  /// - `key` The key of the counter (defaults to "default")
  inflight inc(amount: num?, key: str?): num;

  /// Decrements the counter atomically by a certain amount and returns the previous value.
  /// - `amount` The amount to decrement by (defaults to 1)
  /// - `key` The key of the counter (defaults to "default")
  inflight dec(amount: num?, key: str?): num;

  /// Returns the current value of the counter.
  /// - `key` The key of the counter (defaults to "default")
  inflight peek(key: str?): num;
  
  /// Sets the value of the counter.
  /// - `value` The new value of the counter
  /// - `key` The key of the counter (defaults to "default")
  inflight set(value: num, key: str?): void;
}
