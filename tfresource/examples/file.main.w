bring "../lib.w" as tfr;
bring fs;
bring util;

struct FileState {
  hash: str;
  path: str;
}

class File {
  new(path: str, data: str) {
    let r = new tfr.TerraformResource();

    r.onCreate(inflight () => {
      fs.writeFile(path, data);
      return this.state(path, data);
    });

    r.onDelete(inflight (state) => {
      let s = FileState.fromJson(state);
      fs.remove(s.path);
    });

    r.onRead(inflight (state) => {
      return this.state(path, data);
    });
  }

  inflight state(path: str, data: str): FileState {
    return {
      hash: util.sha256(data),
      path: path,
    };
  }
}

new File("hello1.txt", "my file") as "hello";
new File("world.txt", "your file2") as "world";
