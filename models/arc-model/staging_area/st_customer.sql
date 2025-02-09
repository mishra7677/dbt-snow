{{ config(
    materialized='incremental',
    unique_key='customer_id',
    incremental_strategy='merge'
) }}
    SELECT
        c.c_custkey AS customer_id,
        TRIM(c.c_name) AS customer_name,  
        COALESCE(c.c_address, 'Unknown') AS customer_address,  
        c.c_phone AS customer_phone,
        CAST(COALESCE(c.c_acctbal, 0) AS INTEGER) AS account_balance,  
        UPPER(c.c_mktsegment) AS market_segment,  
        c.c_nationkey AS nation_id
    FROM {{ source('landing', 'CUSTOMER') }} c

{% if is_incremental() %}
WHERE c.c_custkey NOT IN (SELECT customer_id FROM {{ this }})  
{% endif %}
