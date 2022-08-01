{{
    config(
        materialized='table'
    )
}}

select 
  q.QUERY_ID,
  q.QUERY_TEXT,
  q.START_TIME,
  q.END_TIME,
  q.TOTAL_ELAPSED_TIME,
  q.EXECUTION_STATUS,
  q.WAREHOUSE_SIZE,
  -- /1000/60/60 - ms -> hours; *3 - 3$ per hours (Snowflake Enterprise Edition w/o discount; /2 - adjustment koefficient)
    (ifnull(q.TOTAL_ELAPSED_TIME/1000/60/60 * c.CREDITS_PER_HOUR * 3/2, 0)
   + ifnull(q.CREDITS_USED_CLOUD_SERVICES * 3, 0))
   /(count(*) over (partition by q.QUERY_ID)) as ALLOCATED_QUERY_COST_USD,
  u.LOGIN_NAME,
  r.ROLE_NAME,
  w.WAREHOUSE_NAME,
  ds.DISPLAY_NAME,
  sf.SF_OBJECT_NAME,
  count(*) over (partition by q.QUERY_ID) as TABLE_DS_COUNT
from {{ref('l_sf_sql_query') }} lq 
join {{ref('s_sf_sql_query_info') }} q on q.QUERY_SK = lq.QUERY_SK
left join {{ref('s_user_pii_info') }} u on u.USER_SK = lq.USER_SK
left join {{ref('s_sf_role_info') }} r on r.ROLE_SK = lq.ROLE_SK
left join {{ref('s_sf_virt_wh_info') }} w on w.VIRT_WH_SK = lq.VIRT_WH_SK
left join {{ref('r_virt_wh_credits') }} c on c.WAREHOUSE_SIZE = q.WAREHOUSE_SIZE
join {{ref('l_sf_query_object') }} qo on qo.QUERY_SK = lq.QUERY_SK
join {{ref('l_ds_sf_object') }} dso on dso.SF_OBJECT_SK = qo.SF_OBJECT_SK
join {{ref('s_data_set_info') }} ds on ds.DATA_SET_SK = dso.DATA_SET_SK
join {{ref('s_sf_object_info') }} sf on sf.SF_OBJECT_SK = dso.SF_OBJECT_SK
