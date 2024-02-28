pub enum TimeUnit {
  DAILY,
  MONTHLY,
  ANNUALLY,
}

pub struct BudgetProps {
  amount: num; // USD
  name: str;
  timeUnit: TimeUnit?; // default: MONTHLY
  emailAddresses: Array<str>;
}

pub interface IBudget {
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
