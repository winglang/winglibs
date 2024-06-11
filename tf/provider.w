bring "cdktf" as cdktf;
bring util;

pub struct ProviderProps {
  /// The name of the provider in Terraform - this is the prefix used for all resources in the provider.
  /// @example "aws"
  name: str;
  /// The source of the provider on the Terraform Registry.
  /// @example "hashicorp/aws"
  source: str;
  /// The version of the provider to use.
  /// @example "2.0"
  version: str;
  /// The provider-specific configuration options.
  /// @default {}
  attributes: Json?;
}

pub class Provider extends cdktf.TerraformProvider {
  attributes: Json;

  new(props: ProviderProps) {
    super(
      terraformResourceType: props.name,
      terraformGeneratorMetadata: {
        providerName: props.name,
        providerVersion: props.version,
      },
      terraformProviderSource: props.source,
    );

    if !util.env("WING_TARGET").startsWith("tf") {
      throw "tf.Provider can only be used in a Terraform target.";
    }

    this.attributes = props.attributes ?? {};
  }

  protected synthesizeAttributes(): Json {
    return this.attributes;
  }
}
