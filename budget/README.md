# budget

A Wing library for working with [AWS Budgets](https://docs.aws.amazon.com/cost-management/latest/userguide/budgets-managing-costs.html)

## Prerequisites

* [winglang](https://winglang.io).

## Installation

`sh
npm i @winglibs/budget
`

## Usage

Add your budget to the code:

```
bring budget;

let fifyCents = new budget.Budget(
  name: "Test",
  amount: 0.5,
  emailAddresses: ["your@email.com"],
);
```

_Note: ​The budget amount is in USD._

You get an alert when your monthly payment goes over your budget.

## License

This library is licensed under the [MIT License](./LICENSE).
