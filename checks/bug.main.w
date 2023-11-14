interface IHandler {
  inflight handle(): void;
}

class Base {
  new(handler: IHandler?) {
  }
}

class Derived extends Base {
  new() {
    super();
  }
}

new Derived();