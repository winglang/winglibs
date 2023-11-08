interface IHandler {
  inflight handle(): void;
}

class Base {
  init(handler: IHandler?) {
  }
}

class Derived extends Base {
  init() {
    super();
  }
}

new Derived();