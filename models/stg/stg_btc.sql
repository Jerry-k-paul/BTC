{{ config(
    materialized = 'incremental',
    unique_key = 'HASH_KEY',
    incremental_strategy = 'merge'
) }}


select 
* 
from 
{{ source('btc', 'btc') }}



{% if is_incremental() %}

where BLOCK_TIMESTAMP >= (select coalesce(max(BLOCK_TIMESTAMP),'1900-01-01') from {{ this }} )

{% endif %}