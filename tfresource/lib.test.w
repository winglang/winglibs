bring fs;
bring expect;
bring "./lib.w" as tfr;

struct ShellOpts {
  cwd: str?;
}

class Util {
  pub static inflight extern "./util.js" shell(cmd: str, opts: ShellOpts?): str;
}

test "weird way to test this" {
  Util.shell("wing compile -t tf-aws examples/file.main.w");

  let cwd = "examples/target/file.main.tfaws";
  Util.shell("terraform init", cwd: cwd);
  Util.shell("terraform apply -auto-approve", cwd: cwd);

  expect.equal(fs.readFile("{cwd}/hello1.txt"), "my file");
  expect.equal(fs.readFile("{cwd}/world.txt"), "your file2");
}