# budget

A Wing library for working with [AWS Budgets](https://docs.aws.amazon.com/cost-management/latest/userguide/budgets-managing-costs.html)

## Prerequisites

* [winglang](https://winglang.io).

## Installation

```sh
npm i @winglibs/budget
```

## Usage

**⚠️ The budget refers to the entire account and not just for the current project!**

Add your budget alert to the code:

```js
bring budget;

new budget.Alert(
  name: "Test",
  amount: 10,
  emailAddresses: ["your@email.com"],
);
```

*Note: ​The budget amount is in USD.*

You get an alert when your monthly payment goes over your budget.

## TODO

- [ ] Set a budget alert only for resources with certain tags.
- [ ] Allow to perform automatic actions when the budget runs out.

## License

This library is licensed under the [MIT License](./LICENSE).
