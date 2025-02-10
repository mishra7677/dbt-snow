{{ config(
    materialized='incremental',
    unique_key='customer_id',
    incremental_strategy= 'merge'
) }}

SELECT 
    c.customer_id,
    c.customer_name,
    c.customer_address,
    c.customer_phone,
    c.market_segment,
    c.nation_id
FROM {{ ref('st_customer') }} c

{% if is_incremental() %}
WHERE c.customer_id NOT IN (SELECT customer_id FROM {this})
{% endif %}