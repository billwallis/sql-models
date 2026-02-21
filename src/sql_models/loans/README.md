# Loans

> [!TIP]
>
> This is a simple database model for a loan company.

## Model 📚

There are four tables:

- `customers` with information about the customers
- `customer_relationships` with the relationships between the customers (to model family trees)
- `loans` with information about the loans
- `balances` with the loan balances over time

The "customers" in this model can be individuals, businesses, or lending groups (a collection of businesses).

Individuals can be directors of businesses, and businesses can be subsidiaries of lending groups or other businesses.

Loans can be associated with individuals, businesses, or lending groups, and each customer can have multiple loans.

The `balances` table has a new row each time the balance on a loan changes. This means that the "current balance" on a loan will be the balance with the most recent `balance_date`; similarly, the balance at a specific point in time will be the latest balance before that time.

## Exercises 🧩

Exercises to complete on the loan database are below. The columns expected in the result set are described after the question.

1.  Write a query that returns the count of each `customer_type`.

    Expected columns are `customer_type`, `customer_count`.

2.  Write a query that returns the sum of loan values per `customer_type`. If the `customer_type` does not have a loan, show 0 for that `customer_type`.

    Expected columns are `customer_type`, `loan_value`.

3.  Write a query that returns which businesses and lending groups have at least two directors.

    Expected columns are `customer_id`.

4.  Write a query that returns the sum of loan values per business. If the business does not have a loan, show 0 for that business.

    Expected columns are `customer_id`, `loan_value`.

5.  Write a query that returns which businesses have both at least one director and are a subsidiary of a lending group.

    Expected columns are `customer_id`.

6.  Write a query that returns all the children of the `LEN559852` lending group.

    Expected columns are `customer_id`.

7.  Write a query that returns all the children and grandchildren of the `LEN559852` lending group.

    Expected columns are `customer_id`.

8.  Write a query that returns all the descendants of the `LEN559852` lending group, including `LEN559852` itself.

    Expected columns are `customer_id`.

9.  Write a query that returns all the customers related to the `IND154203` individual, including `IND154203` itself. This should include relatives of all depths and generations.

    Expected columns are `customer_id`.

10. Write a query to identify how many distinct family trees belong in the database.

    Expected columns are `distinct_families`.

11. Define the total relative capital for a customer to be the sum of their loans' values, plus the sum of the loan values for all of their descendents. Write a query that returns the customer with the highest total relative capital.

    Expected columns are `customer_id`, `total_relative_capital`.

12. Repeat Q11 but exclude the `LEN559852` lending group.

    Expected columns are `customer_id`, `total_relative_capital`.

13. Write a query that returns the latest balance for every loan.

    Expected columns are `loan_id`, `balance`.

14. Write a query that returns the balance for each loan on 2020-12-31. If a loan had not been opened by that date, don't include it in the result.

    Expected columns are `loan_id`, `balance`.

15. Write a query to show the sum of month-end balances for each month from 2020-01 to 2023-03, inclusive.

    Expected columns are `reporting_month`, `balance`.

## Solutions ✅

Check out the (result set) solutions at:

- [solutions/solutions.md](solutions/solutions.md)
