{{
    config(
        materialized="ephemeral", unique_key="part_id", incremental_strategy="merge"
    )
}}

select
    p.p_partkey as part_id,
    p.p_name as part_name,
    p.p_mfgr as manufacturer,
    p.p_brand as brand,
    p.p_type as part_type,
    p.p_size as size,
    p.p_container as container,
    p.p_retailprice as retail_price
from {{ source("landing", "PART") }} p

{% if is_incremental() %}
    where p.p_partkey not in (select part_id from {{ this }})
{% endif %}
