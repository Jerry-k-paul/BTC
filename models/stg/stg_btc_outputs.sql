{{ config(
    materialized = 'incremental',
    incremental_strategy = 'append'
) }}


with cte as (
select 
tx.HASH_KEY,
tx.BLOCK_NUMBER,
tx.BLOCK_TIMESTAMP,
tx.IS_COINBASE,
f.value:address::string as OUTPUT_ADDRESS,
f.value:value::float as OUTPUT_VALUE

from {{ref('stg_btc') }} tx,

LATERAL FLATTEN(INPUT => OUTPUTS) f

where f.value:address is not null

{% if is_incremental() %}

and tx.BLOCK_TIMESTAMP >= (select max(BLOCK_TIMESTAMP) from {{ this }} )

{% endif %}

)

select 
hash_key,
block_number,
block_timestamp,
is_coinbase,
output_address,
output_value

from cte