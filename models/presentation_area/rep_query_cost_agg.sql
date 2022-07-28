{{
    config(
        materialized='table'
    )
}}

select
  date_trunc('DAY', d.START_TIME) as QUERY_DAY,
  d.WAREHOUSE_SIZE as WAREHOUSE_SIZE,
  d.LOGIN_NAME,
  d.ROLE_NAME,
  d.WAREHOUSE_NAME,
  sum(d.TOTAL_ELAPSED_TIME) as TOTAL_ELAPSED_TIME,
  sum(d.CREDITS_USED_CLOUD_SERVICES) as CREDITS_USED_CLOUD_SERVICES,
  sum(QUERY_APPROX_COST_USD) as QUERY_APPROX_COST_USD
from {{ref('det_query_cost_by_user_wh') }} d 
group by 1,2,3,4,5
