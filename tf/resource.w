bring "cdktf" as cdktf;
bring util;

pub struct ResourceProps extends cdktf.TerraformResourceConfig {
  attributes: Json?;
}

pub class Resource extends cdktf.TerraformResource {
  attributes: Json;

  new(props: ResourceProps) {
    super(props);

    if !util.env("WING_TARGET").startsWith("tf") {
      throw "tf.Resource can only be used in a Terraform target.";
    }

    this.attributes = props.attributes ?? {};
  }

  protected synthesizeAttributes(): Json {
    return this.attributes;
  }
}
