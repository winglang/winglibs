
bring "cdktf" as cdktf;

pub class Element extends cdktf.TerraformElement {
  config: Json;
  
  new(config: Json) {
    super();
    this.config = config;
  }

  pub toTerraform(): Json {
    return this.config;
  }
}
