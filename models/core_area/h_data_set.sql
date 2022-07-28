{{
    config(
        materialized='table'
    )
}}

select
  MD5(ASSET_ID) as DATA_SET_SK,
  ASSET_ID as DATA_SET_COLLIBRA_ID,
  'COLLIBRA' as SYS_SOURCE_ID,
  sysdate() as SYS_LOAD_TIME
from {{source('collibra_source_tables','ASSET') }}
where ASSET_TYPE_NAME = 'Data Set'