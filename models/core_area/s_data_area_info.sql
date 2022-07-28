{{
    config(
        materialized='table'
    )
}}

select
  MD5(a.ASSET_ID) as DATA_AREA_SK,
  'COLLIBRA' as SYS_SOURCE_ID,
  sysdate() as SYS_LOAD_TIME,
  a.ASSET_ID as DATA_AREA_COLLIBRA_ID,
  a.ASSET_DISPLAY_NAME as DISPLAY_NAME,
  a.ASSET_FULL_NAME as FULL_NAME,
  a.STATUS_NAME
from {{source('collibra_source_tables','ASSET') }} a
where ASSET_TYPE_NAME = 'Data Area'