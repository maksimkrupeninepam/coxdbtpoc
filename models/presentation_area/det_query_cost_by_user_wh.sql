select 
  q.QUERY_ID,
  q.QUERY_TEXT,
  q.START_TIME,
  q.END_TIME,
  q.TOTAL_ELAPSED_TIME,
  q.CREDITS_USED_CLOUD_SERVICES,
  q.EXECUTION_STATUS,
  q.WAREHOUSE_SIZE,
  ifnull(q.TOTAL_ELAPSED_TIME/1000/60/60 * c.CREDITS_PER_HOUR * 3, 0) + ifnull(q.CREDITS_USED_CLOUD_SERVICES * 3, 0) as QUERY_APPROX_COST_USD,
  u.LOGIN_NAME,
  r.ROLE_NAME,
  w.WAREHOUSE_NAME
from {{ref('l_sf_sql_query') }} lq 
join {{ref('s_sf_sql_query_info') }} q on q.QUERY_SK = lq.QUERY_SK
left join {{ref('s_user_pii_info') }} u on u.USER_SK = lq.USER_SK
left join {{ref('s_sf_role_info') }} r on r.ROLE_SK = lq.ROLE_SK
left join {{ref('s_sf_virt_wh_info') }} w on w.VIRT_WH_SK = lq.VIRT_WH_SK
left join {{ref('r_virt_wh_credits') }} c on c.WAREHOUSE_SIZE = q.WAREHOUSE_SIZE
