{{ config(
    materialized='ephemeral',
    unique_key='order_id',
    
) }}

SELECT
    o.o_orderkey AS order_id,
    o.o_custkey AS customer_id,
    o.o_orderdate AS order_date,
    o.o_totalprice AS total_price,
    o.o_orderstatus AS order_status,
    o.O_ORDERPRIORITY AS order_priority,
    o.o_shippriority AS ship_priority
FROM {{ source('landing', 'ORDERS') }} o

{% if is_incremental() %}
WHERE o.o_orderdate > (SELECT MAX(order_date) FROM {{ this }}) 
{% endif %}

