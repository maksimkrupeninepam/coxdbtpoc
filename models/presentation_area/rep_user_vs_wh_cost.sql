{{ dbt_profiler.get_profile(relation=ref("r_virt_wh_credits")) }}

with A as(
select 
date_trunc('DAY', "START_TIME") d,
sum(
ifnull(q.TOTAL_ELAPSED_TIME/1000/60/60 * c.CREDITS_PER_HOUR * 3, 0)
   + ifnull(q.CREDITS_USED_CLOUD_SERVICES * 3, 0)
  ) as Cost
from {{source('sf_source_tables','QUERY_HISTORY') }} q
join {{ref('r_virt_wh_credits') }} c on c.WAREHOUSE_SIZE = q.WAREHOUSE_SIZE
group by date_trunc('DAY', "START_TIME"))
, B as
(select
 date_trunc('DAY', "START_TIME") d,
 SUM(CREDITS_USED) * 3 as Cost
from {{source('sf_source_tables','WAREHOUSE_METERING_HISTORY') }}
group by date_trunc('DAY', "START_TIME"))
select 
  A.D as DATE, A.Cost as QUERY_APPROX_COST_USD, B.Cost as WH_COST_USD, A.Cost/B.Cost as COST_RATIO
from A
join B on A.D = B.D

