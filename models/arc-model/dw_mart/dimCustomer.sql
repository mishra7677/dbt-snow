{{ config(
    materialized='table',
    unique_key='customer_id'
) }}

SELECT 
    c.customer_id,
    c.customer_name,
    c.customer_address,
    c.customer_phone,
    c.market_segment,
    c.nation_id
FROM {{ ref('st_customer') }} c
