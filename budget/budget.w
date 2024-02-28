bring util;

bring "./budget-tfaws.w" as tfaws;
bring "./budget-shared.w" as shared;

pub class Budget {
  platform: shared.IBudget;

  new(props: shared.BudgetProps) {
    if util.env("WING_TARGET") == "tf-aws" {
      this.platform = new tfaws.BudgetTfAws(props);
    }
    else {
      throw "unknown platform";
    }
  }
}
