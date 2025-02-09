{{ config(
    materialized='incremental', 
    unique_key='part_id',
    incremental_strategy='merge'
) }}

SELECT
    p.p_partkey AS part_id,
    p.p_name AS part_name,
    p.p_mfgr AS manufacturer,
    p.p_brand AS brand,
    p.p_type AS part_type,
    p.p_size AS size,
    p.p_container AS container,
    p.p_retailprice AS retail_price
FROM {{ source('landing', 'PARTS') }} p

{% if is_incremental() %}
WHERE p.p_partkey NOT IN (SELECT part_id FROM {{ this }})
{% endif %}
