create or replace table balances as
    select
        account_id::bigint as account_id,
        closing_date::date as closing_date,
        translate(balance, '£,', '')::numeric(12, 2) as balance,
    from 'src/sql_models/loans/balance-question/balances.tsv'
;

create or replace table solution_1 as
    select
        account_id::bigint as account_id,
        closing_date::date as closing_date,
        translate(balance, '£,', '')::numeric(12, 2) as balance,
    from 'src/sql_models/loans/balance-question/solution-1.tsv'
;
create or replace table solution_2 as
    select
        reporting_month,
        translate(month_end_balance, '£,', '')::numeric(12, 2) as month_end_balance,
        translate(month_end_credit_balance, '£,', '')::numeric(12, 2) as month_end_credit_balance,
        translate(month_end_debit_balance, '£,', '')::numeric(12, 2) as month_end_debit_balance,
    from 'src/sql_models/loans/balance-question/solution-2.tsv'
;

from solution_1;
from solution_2;


/* Objective 1 */
select *
from balances
qualify 1 = row_number() over (
    partition by account_id
    order by closing_date desc
)
order by account_id
;


/* Objective 2 */
with

axis(report_date, balance_date) as (
    select dt::date, (dt + interval '1 month')::date
    from generate_series(
        (select date_trunc('month', min(closing_date)) from balances),
        (select date_trunc('month', max(closing_date)) from balances),
        interval '1 month'
    ) as gs(dt)
),

month_end_balances as (
    select
        axis.report_date,
        month_end_balance.net,
        month_end_balance.credit,
        month_end_balance.debit,
    from axis
        cross join lateral (
            select
                sum(balance) as net,
                sum(balance) filter (where balance > 0) as credit,
                sum(balance) filter (where balance < 0) as debit,
            from (
                select *
                from balances
                where balances.closing_date < axis.balance_date
                qualify 1 = row_number() over (
                    partition by account_id
                    order by closing_date desc
                )
            )
        ) as month_end_balance
)

select
    strftime(report_date, '%Y-%m') as reporting_month,
    net as month_end_balance,
    coalesce(credit, 0) as month_end_credit_balance,
    coalesce(debit, 0) as month_end_debit_balance,
from month_end_balances
order by report_date
;
