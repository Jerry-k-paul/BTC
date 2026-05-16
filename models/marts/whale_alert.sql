with whale_alert as (

select
output_address,
sum(output_value) as total_sent,
count(*)as tx_count

from {{ ref('stg_btc_transactions') }}
where output_value > 10

group by output_address
order by total_sent desc

)

select
w.output_address,
w.total_sent,
w.tx_count,
{{ convert_to_usd('w.total_sent') }} as total_sent_usd

from whale_alert w
order by total_sent desc