
select
  MD5(h.QUERY_ID) as QUERY_SK,
  h.QUERY_ID as QUERY_ID,
  'SNOWFLAKE' as SYS_SOURCE_ID,
  sysdate() as SYS_LOAD_TIME
from {{source('sf_source_tables','QUERY_HISTORY') }} h
