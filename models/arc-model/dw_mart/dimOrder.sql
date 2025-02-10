{{ config(
    materialized='incremental',
    unique_key='order_id',
    incremental_strategy='merge'
) }}

SELECT 
    o.order_id,
    o.order_status,
    o.order_date,
    o.order_priority,
    o.ship_priority
FROM {{ ref('stg_orders') }} o

{% if is_incremental() %}
WHERE o.order_date > (SELECT MAX(order_date) FROM {{ this }})
{% endif %}
