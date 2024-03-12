pub enum TimeUnit {
  DAILY,
  MONTHLY,
  ANNUALLY,
}

pub struct AlertProps {
  name: str;
  amount: num; // USD
  emailAddresses: Array<str>;
  timeUnit: TimeUnit?; // default: MONTHLY
}

pub interface IAlert {
}

pub class Util {
  pub static timeUnitToStr(timeUnit: TimeUnit): str {
    if timeUnit == TimeUnit.DAILY {
      return "DAILY";
    } elif timeUnit == TimeUnit.MONTHLY {
      return "MONTHLY";
    } elif timeUnit == TimeUnit.ANNUALLY {
      return "ANNUALLY";
    }
  }
}
