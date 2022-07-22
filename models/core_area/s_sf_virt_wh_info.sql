select
  distinct
  MD5(UPPER(r.WAREHOUSE_ID)) as VIRT_WH_SK,
  'SNOWFLAKE' as SYS_SOURCE_ID,
  sysdate() as SYS_LOAD_TIME,
  r.WAREHOUSE_NAME as WAREHOUSE_NAME,
  r.WAREHOUSE_ID as WAREHOUSE_ID
from {{source('sf_source_tables','WAREHOUSE_METERING_HISTORY') }} r