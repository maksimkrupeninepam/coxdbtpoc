
{{
    config(
        materialized='incremental'
    )
}}

select
  MD5(hist.QUERY_ID||'^'||UPPER(objs.value:objectName)) as L_SF_QUERY_OBJECT_SK,
  'SNOWFLAKE' as SYS_SOURCE_ID,
  CURRENT_TIMESTAMP() as SYS_LOAD_TIME,
  MD5(hist.QUERY_ID) as QUERY_SK,
  MD5(objs.value:objectId) as SF_OBJECT_SK,
  hist.QUERY_START_TIME as QUERY_START_TIME,
  count(*) as ACCESSED_TIMES
from {{source('sf_source_tables','ACCESS_HISTORY') }} hist,
  lateral flatten (input => direct_objects_accessed) objs
  join {{ref('h_sf_object') }} o on objs.value:objectId = o.SF_OBJECT_ID
where exists(select 1 from {{ref('h_sf_sql_query') }} q where hist.QUERY_ID = q.QUERY_ID)
{% if is_incremental() %}
  -- this filter will only be applied on an incremental run
  and hist.QUERY_START_TIME > (select max(t.QUERY_START_TIME) from {{ this }} t)
{% endif %}

{{ dbt_utils.group_by(6) }}
