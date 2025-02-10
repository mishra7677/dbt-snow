{{ config(
    materialized='table',
    unique_key='order_id'
) }}

SELECT 
    o.order_id,
    o.customer_id,
    o.order_date,
    SUM(li.revenue) AS total_revenue,
    SUM(li.quantity) AS total_quantity,
    COUNT(li.lineitem_id) AS total_items
FROM {{ ref('st_order') }} o
JOIN {{ ref('st_lineitem') }} li 
    ON o.order_id = li.order_id
GROUP BY o.order_id, o.customer_id, o.order_date
