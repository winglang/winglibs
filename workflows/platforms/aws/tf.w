bring "cdktf" as cdktf;

pub struct TerraformResourceProps {
  type: str;
  attributes: Json?;
}

pub class TerraformResource extends cdktf.TerraformResource {
  attributes: Json;

  new(props: TerraformResourceProps) {
    super(terraformResourceType: props.type);
    this.attributes = props.attributes ?? {};
  }

  protected synthesizeAttributes(): Json {
    return this.attributes;
  }
}
