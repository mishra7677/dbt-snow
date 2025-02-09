{{config(
    materialized='incremental',
    unique_key='nation_id',
    incremental_strategy= 'merge'
)}}

    SELECT 
        n.n_nationkey AS nation_id,
        n.n_name AS NAME,
        n.n_regionkey AS region_id,
        TRIM(n.n_comment) AS nation_comment

    FROM {{source('landing', 'NATION')}} n

{% if is_incremental() %}
WHERE p.n_nationkey NOT IN (SELECT nation_id FROM {{ this }})
{% endif %}
