
pub struct ContainerOpts {
  name: str;
  image: str;

  /** Internal container port to expose */
  port: num?;
  env: Map<str?>?;
  readiness: str?;   // http get
  replicas: num?;    // number of replicas
  public: bool?;     // whether the workload should have a public url (default: false)
  args: Array<str>?; // container arguments

  /** 
   * The glob to use in order to calculate the content hash (default: all files)
   */
  sources: str?;

  /**
   * a hash that represents the container source. if not set,
   * and `sources` is set, the hash will be calculated based on the content of the
   * source files.
   */
  sourceHash: str?;
}

pub struct WorkloadProps extends ContainerOpts {

}