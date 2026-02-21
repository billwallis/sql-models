<span align="center">

[![Python](https://img.shields.io/badge/Python-3.13+-blue.svg)](https://www.python.org/downloads/)
[![uv](https://img.shields.io/endpoint?url=https://raw.githubusercontent.com/astral-sh/uv/main/assets/badge/v0.json)](https://github.com/astral-sh/uv)
[![pre-commit.ci status](https://results.pre-commit.ci/badge/github/billwallis/sql-models/main.svg)](https://results.pre-commit.ci/latest/github/billwallis/sql-models/main)
![GitHub last commit](https://img.shields.io/github/last-commit/billwallis/sql-models)

</span>

---

# SQL Models

Stand-alone SQL models.

These can be used to enhance existing databases, or as reference material for training and learning.

Some are created by me, and others are from various sources which are credited below.

## Contents

### Date Dimension

Almost all data models can be improved by adding a calendar table which has dates over a range with useful info and such, such as weekday names.

This model extends this by including holidays and additional columns.

### [Football](src/sql_models/football/README.md)

The Euro 2016 football tournament.

This was built by [w3resource](https://www.w3resource.com/) and can be found at:

- [https://www.w3resource.com/sql-exercises/soccer-database-exercise/index.php](https://www.w3resource.com/sql-exercises/soccer-database-exercise/index.php)

### Human Resources

Employees, departments, and salaries.

This was built by [w3resource](https://www.w3resource.com/) and can be found at:

- [https://www.w3resource.com/sql-exercises/employee-database-exercise/index.php](https://www.w3resource.com/sql-exercises/employee-database-exercise/index.php)

### [Loans](src/sql_models/loans/README.md)

Loans and balances for a B2B bank.

### School

A typical school.

This was built by Microsoft and can be found at:

- [https://docs.microsoft.com/en-us/ef/ef6/resources/school-database](https://docs.microsoft.com/en-us/ef/ef6/resources/school-database)

### Website Backend

A simple website with users and events.

---

Additional databases can be found at:

- https://dzone.com/articles/collection-sql-server-sample-databases
