
{{
    config(
        materialized='incremental'
    )
}}
select
  MD5(h.QUERY_ID) as QUERY_SK,
  'SNOWFLAKE' as SYS_SOURCE_ID,
  CURRENT_TIMESTAMP() as SYS_LOAD_TIME,
  h.QUERY_ID as QUERY_ID,
  h.QUERY_TEXT as QUERY_TEXT,
  h.QUERY_TYPE as QUERY_TYPE,
  h.WAREHOUSE_SIZE as WAREHOUSE_SIZE,
  h.EXECUTION_STATUS as EXECUTION_STATUS,
  h.ERROR_CODE as ERROR_CODE,
  h.START_TIME as START_TIME,
  h.END_TIME as END_TIME,
  h.TOTAL_ELAPSED_TIME as TOTAL_ELAPSED_TIME,
  h.CREDITS_USED_CLOUD_SERVICES as CREDITS_USED_CLOUD_SERVICES
from {{source('sf_source_tables','QUERY_HISTORY') }} h

{% if is_incremental() %}
  -- this filter will only be applied on an incremental run
  where h.START_TIME > (select max(t.START_TIME) from {{ this }} t)
{% endif %}
