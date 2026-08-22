# Balance questions

### Table Details

The `balances.tsv` table is a "delta" table. This means that when the balance on an account changes, the new balance will be _appended_ to this table. This allows us to track the history of balances in an efficient way.

For example, take the account with the ID of `2506812882667502`:

- This account had a balance of £220.04 on 2022-01-09
- The next change in balance for this account was on 2022-01-23 where it jumped to £46,161.18
  - This means that the balance for this account remained at £220.04 for every day until 2022-01-23
- The next change in balance for this account was on 2022-02-12 where it jumped to £89,477.27
  - This means that the balance for this account at the 2022-01 month-end was £46,161.18

Similarly, take the account with the ID of `2506815749825845`:

- This account had a balance of £42,329.56 on 2020-02-10
- This account only has 1 balance record in the table, so balance has remained unchanged on this account until today
- This means the month-end balance for this account is £42,329.56 for every month-end from 2020-02-10 until today

### Objectives

- **Objective 1**: Write a query to show the current balance for every account
- **Objective 2**: Write a query to show the sum of month-end balances for each month from 2020-01 to 2022-05
