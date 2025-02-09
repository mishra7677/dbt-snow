{{config(
    materialized='incremental',
    unique_key='region_id',
    incremental_strategy='merge'
)}}

    SELECT 
        r.r_regionkey as region_id,
        r.r_name as region_name,
        TRIM(r.r_comment) as region_comment
    FROM {{source('landing', 'REGION')}} r

{% if is_incremental() %}
WHERE r.r_regionkey NOT IN (SELECT region_id FROM {{ this }})  
{% endif %}