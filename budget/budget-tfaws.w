bring "cdktf" as cdktf;
bring "@cdktf/provider-aws" as tfaws;

bring "./budget-shared.w" as shared;

pub class AlertTfAws impl shared.IAlert {
  budget: tfaws.budgetsBudget.BudgetsBudget;

  new(props: shared.AlertProps) {
    this.budget = new tfaws.budgetsBudget.BudgetsBudget(
      name: props.name,
      budgetType: "COST",
      limitUnit: "USD",
      limitAmount: "{props.amount}",
      timeUnit: shared.Util.timeUnitToStr(props.timeUnit ?? shared.TimeUnit.MONTHLY),
      notification: {
        comparison_operator: "GREATER_THAN",
        threshold: 100,
        threshold_type: "PERCENTAGE",
        notification_type: "ACTUAL",
        subscriber_email_addresses: props.emailAddresses,
      },
    );
  }
}
