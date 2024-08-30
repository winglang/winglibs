bring "cdk8s" as cdk8s;

pub struct ApiObjectProps extends cdk8s.ApiObjectProps {
  spec: Json?;
}

pub class ApiObject extends cdk8s.ApiObject {
  new(props: ApiObjectProps) {
    super(props);
  }
}