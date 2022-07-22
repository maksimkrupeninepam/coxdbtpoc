
select
  MD5(hist.QUERY_ID||'^'||UPPER(objs.value:objectName)) as L_SF_QUERY_OBJECT_SK,
  'SNOWFLAKE' as SYS_SOURCE_ID,
  sysdate() as SYS_LOAD_TIME,
  MD5(hist.QUERY_ID) as QUERY_SK,
  MD5(objs.value:objectId) as SF_OBJECT_SK,
  hist.QUERY_START_TIME as QUERY_START_TIME
from {{source('sf_source_tables','ACCESS_HISTORY') }} hist,
  lateral flatten (input => direct_objects_accessed) objs