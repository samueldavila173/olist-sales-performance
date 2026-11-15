-- PROYECTO 1: Eres el nuevo

-- 1. cuantos registros tiene cada tabla?

select
	'customers' as table_name,
	count(*) as total_rows
from public.customers

union all

select
	'geolocation',
	count(*)
from public.geolocation

union all

select
	'order_items',
	count(*)
from public.order_items

union all

select
	'order_payments',
	count(*)
from public.order_payments

union all

select
	'order_reviews',
	count(*)
from public.order_reviews

union all

select
	'orders',
	count(*)
from public.orders

union all

select
	'products',
	count(*)
from public.products

union all

select
	'sellers',
	count(*)
from public.sellers

order by total_rows DESC;

-- 2. cuales son las columnas que hay por tabla?

select
	table_name,
	ordinal_position,
	column_name,
	data_type
from information_schema.columns
where table_schema = 'public'
order by
	table_name,
	ordinal_position;

-- 3. cuales vamos a usar para la peticion?
		-- evolucion mensual de ingresos
		-- ingresos por categoria
-- tablas a usar: orders, order_items, products

-- 4. como se relacionan esas tablas

select
	tc.table_name,
	tc.constraint_type,
	kcu.column_name
from information_schema.table_constraints as tc
join information_schema.key_column_usage as kcu
	on tc.constraint_name = kcu.constraint_name
	and tc.constraint_schema = kcu.constraint_schema
	and tc.table_name = kcu.table_name
where
	tc.table_schema = 'public'
	and tc.table_name in ('orders','order_items','products')
	and tc.constraint_type in ('PRIMARY KEY','FOREIGN KEY')
order by
	tc.table_name,
	tc.constraint_type;

-- 4a analisis de products

select
	count(*) as total_rows,
	count(distinct product_id) as unique_id,
	count(*)-count(product_id) as null_id
from products;

-- 4b analisis de order_items

select
	count(*) as total_rows,
	count(distinct order_id) as unique_id,
	count(*)-count(order_id) as null_id
from order_items;

select
	count(*) as total_rows,
	count(distinct(order_id,order_item_id)) as unique_combination,
	count(*) filter(
				where order_id is null
				or order_item_id is null
				) as combination_null
from order_items;

-- 4c validar relacion order_id y order_items_id

select
	count(*) as orphan_items
from order_items as oi
left join orders as o
	on oi.order_id = o.order_id
where o.order_id is null;

-- 4d relacion order_itmes y products

select
	count(*) as orphan_items
from order_items as oi
left join products as p
	on oi.product_id = p.product_id
where p.product_id is null;

-- 5. identificar ventas

select
	order_status,
	count(*) as frecuence
from orders
group by
	order_status
order by
	frecuence desc;

-- 6. productos sin categoria

select
	count(*) as total_products,
	count(*) filter(where product_category_name is null) as products_without_category
from products;

-- 6a. cuanto dinero representan los productos sin categoria

select
	count(*) as total_items,
	sum(oi.price) as total_sales
from orders as o
join order_items as oi
	on o.order_id = oi.order_id
join products as p
	on oi.product_id = p.product_id
where
	o.order_status in ('delivered','shipped','invoiced','approved')
	and p.product_category_name is null;

-- 7. ventas mensuales por categoria

select
	date_trunc('month', o.order_purchase_timestamp)::date as sales_month,
	coalesce(p.product_category_name, 'uncategorized') as category,
	round(sum(oi.price),2) as total_sales
from orders as o
join order_items as oi
	on o.order_id = oi.order_id
join products as p
	on oi.product_id = p.product_id
where
	o.order_status in ('delivered','shipped','invoiced','approved')
group by
	date_trunc('month', o.order_purchase_timestamp),
	coalesce(p.product_category_name, 'uncategorized')
order by
	sales_month,
	total_sales desc;

-- 8. guardar vista sql

create or replace view vw_monthly_sales_by_category AS
select
	date_trunc('month', o.order_purchase_timestamp)::date as sales_month,
	coalesce(p.product_category_name, 'uncategorized') as category,
	round(sum(oi.price),2) as total_sales
from orders as o
join order_items as oi
	on o.order_id = oi.order_id
join products as p
	on oi.product_id = p.product_id
where
	o.order_status in ('delivered','shipped','invoiced','approved')
group by
	date_trunc('month', o.order_purchase_timestamp),
	coalesce(p.product_category_name, 'uncategorized');
