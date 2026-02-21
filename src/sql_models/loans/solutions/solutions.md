# Solutions

The SQL queries will depend on the database that you're using. However, the results should be the same across all databases so the results are shown here.

#### Q1: count of each `customer_type`

| customer_type | customer_count |
| :------------ | -------------: |
| Business      |             11 |
| Individual    |              9 |
| Lending Group |              1 |

#### Q2: total value of loans per `customer_type`

| customer_type | loan_value |
| :------------ | ---------: |
| Business      |    799,000 |
| Individual    |    189,000 |
| Lending Group |          0 |

#### Q3: businesses with at least two directors

| customer_id |
| :---------- |
| BUS156548   |
| BUS364265   |
| BUS365265   |
| BUS755902   |

#### Q4: total value of loans per business

| customer_id | loan_value |
| :---------- | ---------: |
| BUS116595   |          0 |
| BUS154890   |    368,000 |
| BUS156044   |          0 |
| BUS156544   |          0 |
| BUS156548   |     91,000 |
| BUS216549   |          0 |
| BUS364265   |          0 |
| BUS365265   |          0 |
| BUS484532   |     27,000 |
| BUS520654   |          0 |
| BUS755902   |    313,000 |

#### Q5: businesses with at least one director and belong to a lending group

| customer_id |
| :---------- |
| BUS484532   |

#### Q6: children of the `LEN559852` lending group

| customer_id |
| :---------- |
| BUS484532   |
| BUS154890   |

#### Q7: children and grandchildren of the `LEN559852` lending group

| customer_id |
| :---------- |
| BUS116595   |
| BUS154890   |
| BUS156544   |
| BUS365265   |
| BUS484532   |
| BUS755902   |
| IND744689   |

#### Q8: descendants of the `LEN559852` lending group

| customer_id |
| :---------- |
| BUS116595   |
| BUS154890   |
| BUS156544   |
| BUS365265   |
| BUS484532   |
| BUS755902   |
| IND454498   |
| IND459324   |
| IND744689   |
| IND752136   |
| IND986597   |
| LEN559852   |

#### Q9: customers related to the `IND154203` individual

| customer_id |
| :---------- |
| BUS156548   |
| BUS216549   |
| BUS520654   |
| IND154203   |
| IND549804   |

#### Q10: distinct family trees

| distinct_families |
| ----------------: |
|                 3 |

#### Q11: customer with the highest total relative capital

| customer_id | total_relative_capital |
| :---------- | ---------------------: |
| LEN559852   |                897,000 |

#### Q12: customer with the highest total relative capital, excluding `LEN559852`

| customer_id | total_relative_capital |
| :---------- | ---------------------: |
| BUS520654   |                 91,000 |

#### Q13: latest balance for every account

| loan_id   | balance |
| :-------- | ------: |
| LOA123046 |       0 |
| LOA156487 |       0 |
| LOA156489 |       0 |
| LOA326984 |       0 |
| LOA447741 |       0 |
| LOA549321 |       0 |
| LOA655489 |       0 |
| LOA989215 |       0 |

#### Q14: balance for each account on 2020-12-31

| loan_id   | balance |
| :-------- | ------: |
| LOA123046 |   8,125 |
| LOA156487 |       0 |
| LOA156489 |       0 |
| LOA326984 |  28,000 |
| LOA447741 | 110,000 |

#### Q15: sum of month-end balances for 2020-01 to 2023-03

| reporting_month | balance |
| :-------------- | ------: |
| 2020-01         | 230,000 |
| 2020-02         | 521,375 |
| 2020-03         | 499,750 |
| 2020-04         | 478,125 |
| 2020-05         | 431,500 |
| 2020-06         | 409,875 |
| 2020-07         | 383,250 |
| 2020-08         | 321,625 |
| 2020-09         | 280,000 |
| 2020-10         | 242,375 |
| 2020-11         | 180,750 |
| 2020-12         | 146,125 |
| 2021-01         | 124,500 |
| 2021-02         | 303,875 |
| 2021-03         | 480,750 |
| 2021-04         | 444,375 |
| 2021-05         | 387,250 |
| 2021-06         | 372,500 |
| 2021-07         | 342,000 |
| 2021-08         | 327,250 |
| 2021-09         | 296,750 |
| 2021-10         | 282,000 |
| 2021-11         | 251,500 |
| 2021-12         | 236,750 |
| 2022-01         | 206,250 |
| 2022-02         | 191,500 |
| 2022-03         | 161,000 |
| 2022-04         | 148,500 |
| 2022-05         | 120,250 |
| 2022-06         | 107,750 |
| 2022-07         |  79,500 |
| 2022-08         |  63,000 |
| 2022-09         |  47,250 |
| 2022-10         |  47,250 |
| 2022-11         |  31,500 |
| 2022-12         |  31,500 |
| 2023-01         |  15,750 |
| 2023-02         |  15,750 |
| 2023-03         |       0 |
