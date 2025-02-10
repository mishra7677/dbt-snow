{{ config(
    materialized='ephemeral', 
    unique_key='lineitem_id',
    
) }}

    SELECT 
        CONCAT(l.l_orderkey, '-', l.l_linenumber) AS lineitem_id,  -- Composite key
        l.l_orderkey AS order_id,
        l.l_partkey AS part_id,
        l.l_suppkey AS supplier_id,
        CAST(COALESCE(l.l_quantity, 0) AS INTEGER) AS quantity,
        l.l_discount AS discount,
        l.l_extendedprice AS revenue,
        l.l_shipdate AS ship_date,
        l.l_commitdate AS commit_date,
        l.l_receiptdate AS receipt_date
    FROM {{ source('landing', 'LINEITEM') }} l
    {% if is_incremental() %}
    WHERE l.l_shipdate > (SELECT MAX(ship_date) FROM {{ this }})  -- Load only new records
    {% endif %}
    

