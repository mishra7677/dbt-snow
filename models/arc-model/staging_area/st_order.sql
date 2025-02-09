{{ config(
    materialized='incremental',
    unique_key='order_id',
    incremental_strategy='merge'
) }}

SELECT
    o.o_orderkey AS order_id,
    o.o_custkey AS customer_id,
    o.o_orderdate AS order_date,
    o.o_totalprice AS total_price,
    o.o_orderstatus AS order_status
FROM {{ source('landing', 'ORDERS') }} o

{% if is_incremental() %}
WHERE o.o_orderdate > (SELECT MAX(order_date) FROM {{ this }}) 
{% endif %}

