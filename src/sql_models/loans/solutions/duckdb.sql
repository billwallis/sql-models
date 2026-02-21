/*
Solutions for DuckDB (0.9.2).
*/


/* Q1 */
select
    customer_type,
    count(*) as customer_count
from loans.customers
group by all
order by all
;


/* Q2 */
select
    customers.customer_type,
    coalesce(sum(loans.loan_value), 0) as loan_value
from loans.customers
    left join loans.loans
        using (customer_id)
group by all
order by all
;


/* Q3 */
select customer_id
from loans.customers
    semi join (
        select parent_customer_id as customer_id
        from loans.customer_relationships
        where relationship_type = 'Director'
        group by parent_customer_id
        having count(*) >= 2
    ) using (customer_id)
where customer_type in ('Business', 'Lending Group')
order by all
;


/* Q4 */
select
    customers.customer_id,
    coalesce(sum(loans.loan_value), 0) as loan_value
from loans.customers
    left join loans.loans
        using (customer_id)
where customers.customer_type = 'Business'
group by all
order by all
;


/* Q5 */
select customers.customer_id
from loans.customers
    semi join loans.customer_relationships as child
        on  customers.customer_id = child.parent_customer_id
        and child.relationship_type = 'Director'
    inner join loans.customer_relationships as parent
        on  customers.customer_id = parent.child_customer_id
        and parent.relationship_type = 'Subsidiary'
        and parent.parent_customer_id in (
            select customer_id
            from loans.customers
            where customer_type = 'Lending Group'
        )
where customers.customer_type = 'Business'
order by all
;


/* Q6 */
select child_customer_id as customer_id
from loans.customer_relationships
where parent_customer_id = 'LEN559852'
;


/* Q7 */
    select child_customer_id as customer_id
    from loans.customer_relationships
    where parent_customer_id = 'LEN559852'
union all
    select child.child_customer_id as customer_id
    from loans.customer_relationships as parent
        inner join loans.customer_relationships as child
            on  parent.child_customer_id = child.parent_customer_id
    where parent.parent_customer_id = 'LEN559852'
order by all
;


/* Q8 */
with recursive descendants as (
        select customer_id
        from loans.customers
        where customer_id = 'LEN559852'
    union all
        select customer_relationships.child_customer_id
        from loans.customer_relationships
            inner join descendants
                on customer_relationships.parent_customer_id = descendants.customer_id
)

select distinct customer_id
from descendants
order by all
;


/* Q9 */
with recursive relatives as (
        select
            customer_id,
            customer_id as seen
        from loans.customers
        where customer_id = 'IND154203'
    union all (
        /* zig-zag through the hierarchies */
            select
                child.child_customer_id as customer_id,
                concat_ws(' ', relatives.seen, child.child_customer_id) as seen
            from loans.customer_relationships as child
                inner join relatives
                    on  child.parent_customer_id = relatives.customer_id
                    and not contains(relatives.seen, child.child_customer_id)
        union
            select
                parent.parent_customer_id as customer_id,
                concat_ws(' ', relatives.seen, parent.parent_customer_id) as seen
            from loans.customer_relationships as parent
                inner join relatives
                    on  parent.child_customer_id = relatives.customer_id
                    and not contains(relatives.seen, parent.parent_customer_id)
    )
)

select distinct customer_id
from relatives
order by all
;


/* Q10 */
with recursive

relatives as (
        select
            customer_id,
            customer_id as related_customer_id,
            customer_id as seen
        from loans.customers
    union all (
        /* zig-zag through the hierarchies */
            select
                relatives.customer_id,
                child.child_customer_id as related_customer_id,
                concat_ws(' ', relatives.seen, child.child_customer_id) as seen
            from loans.customer_relationships as child
                inner join relatives
                    on  child.parent_customer_id = relatives.related_customer_id
                    and not contains(relatives.seen, child.child_customer_id)
        union
            select
                relatives.customer_id,
                parent.parent_customer_id as related_customer_id,
                concat_ws(' ', relatives.seen, parent.parent_customer_id) as seen
            from loans.customer_relationships as parent
                inner join relatives
                    on  parent.child_customer_id = relatives.related_customer_id
                    and not contains(relatives.seen, parent.parent_customer_id)
    )
),

families as (
    select
        customer_id,
        list(distinct related_customer_id order by related_customer_id) as family
    from relatives
    group by customer_id
)

select count(distinct family) as distinct_families
from families
;


/* Q11 */
with recursive descendants as (
        /* The customers that aren't the children of any other customers */
        select
            customers.customer_id,
            customers.customer_id as descendant_customer_id
        from loans.customers
            left join loans.customer_relationships
                on customers.customer_id = customer_relationships.child_customer_id
        where customer_relationships.parent_customer_id is null
    union all
        select
            descendants.customer_id,
            customer_relationships.child_customer_id as descendant_customer_id
        from loans.customer_relationships
            inner join descendants
                on customer_relationships.parent_customer_id = descendants.descendant_customer_id
)

select
    descendants.customer_id,
    coalesce(sum(loans.loan_value), 0) as total_relative_capital
from (
    select distinct customer_id, descendant_customer_id
    from descendants
) as descendants
    left join loans.loans
        on descendants.descendant_customer_id = loans.customer_id
group by descendants.customer_id
qualify total_relative_capital = max(total_relative_capital) over ()
;


/* Q12 */
with recursive descendants as (
        /* The customers that aren't the children of any other customers */
        select
            customers.customer_id,
            customers.customer_id as descendant_customer_id
        from loans.customers
            left join loans.customer_relationships
                on customers.customer_id = customer_relationships.child_customer_id
        where customer_relationships.parent_customer_id is null
          and customers.customer_id != 'LEN559852'
    union all
        select
            descendants.customer_id,
            customer_relationships.child_customer_id as descendant_customer_id
        from loans.customer_relationships
            inner join descendants
                on customer_relationships.parent_customer_id = descendants.descendant_customer_id
)

select
    descendants.customer_id,
    coalesce(sum(loans.loan_value), 0) as total_relative_capital
from descendants
    left join loans.loans
        on descendants.descendant_customer_id = loans.customer_id
group by descendants.customer_id
qualify total_relative_capital = max(total_relative_capital) over ()
;


/* Q13 */
select
    loan_id,
    balance
from loans.balances
qualify balance_date = max(balance_date) over (partition by loan_id)
order by all
;


/* Q14 */
select
    loan_id,
    balance
from loans.balances
where balance_date <= '2020-12-31'
qualify balance_date = max(balance_date) over (partition by loan_id)
order by all
;


/* Q15 -- approach 1 (asof with complete axis) */
with recursive

dates(next_month) as (
        select '2020-02-01'::date
    union all
        select next_month + interval '1 month'
        from dates
        where next_month <= '2023-03-01'
),

axis as (
    select
        dates.next_month,
        strftime(dates.next_month - interval '1 day', '%Y-%m') as reporting_month,
        loans.loan_id
    from dates
        cross join (select distinct loan_id from loans.balances) as loans
)

select
    axis.reporting_month,
    sum(balances.balance) as balance
from axis
    asof left join loans.balances
        on  axis.loan_id = balances.loan_id
        and axis.next_month > balances.balance_date
group by all
order by all
;


/* Q15 -- approach 2 (lateral) */
with recursive

dates(next_month) as (
        select '2020-02-01'::date
    union all
        select next_month + interval '1 month'
        from dates
        where next_month <= '2023-03-01'
),

date_axis as (
    select
        next_month,
        strftime(next_month - interval '1 day', '%Y-%m') as reporting_month
    from dates
)

select
    date_axis.reporting_month,
    sum(balances.balance) as balance
from date_axis
    cross join lateral (
        select balance
        from loans.balances
        where date_axis.next_month > balances.balance_date
        qualify balance_date = max(balance_date) over (partition by loan_id)
    ) as balances
group by all
order by all
;


------------------------------------------------------------------------
------------------------------------------------------------------------

/* Customer relationships */
copy (
        select 'flowchart TD'
    union all
        select
            format(
                '    {:s} -- {:s} --> {:s}',
                parent_customer_id,
                relationship_type,
                child_customer_id
            )
        from loans.customer_relationships
)
to 'sql_models/loans/solutions/customer-relationships.mermaid' (
    header false,
    quote '',
    delimiter E'\n'
);


/* Relationships with loans */
copy (
        select 'flowchart TD'
    union all
        select
            format(
                '    {:s} ---> {:s}',
                parent_customer_id,
                child_customer_id
            )
        from loans.customer_relationships
    union all
        select
            format(
                '    {:s} --- {:s}{{{{"{:s}\n({:t,})"}}}}',
                customer_id,
                loan_id,
                loan_id,
                loan_value::int
            )
        from loans.loans
)
to 'sql_models/loans/solutions/relationships-with-loans.mermaid' (
    header false,
    quote '',
    delimiter E'\n'
);


/* Described relationships with loans */
copy (
        select 'flowchart TD'
    union all
        select format(
            '    {:s} -- {:s} ---> {:s}',
            parent_customer_id, relationship_type, child_customer_id
        )
        from loans.customer_relationships
    union all
        select format(
            '    {:s} --- {:s}{{{{"{:s}\n({:t,})"}}}}',
            customer_id, loan_id, loan_id, loan_value::int
        )
        from loans.loans
)
to 'sql_models/loans/solutions/relationships-with-loans.mermaid' (
    header false, quote '', delimiter E'\n'
)
