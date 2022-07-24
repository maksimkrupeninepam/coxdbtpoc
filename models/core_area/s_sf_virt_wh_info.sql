
{{
    config(
        materialized='incremental',
        unique_key='VIRT_WH_SK'
    )
}}

select
  distinct
  MD5(UPPER(r.WAREHOUSE_ID)) as VIRT_WH_SK,
  'SNOWFLAKE' as SYS_SOURCE_ID,
  CURRENT_TIMESTAMP() as SYS_LOAD_TIME,
  r.WAREHOUSE_NAME as WAREHOUSE_NAME,
  r.WAREHOUSE_ID as WAREHOUSE_ID
from {{source('sf_source_tables','WAREHOUSE_METERING_HISTORY') }} r

{% if is_incremental() %}
  -- this filter will only be applied on an incremental run
  where r.START_TIME >= (select dateadd(hour,-3, max(t.SYS_LOAD_TIME)) from {{ this }} t)
{% endif %}

