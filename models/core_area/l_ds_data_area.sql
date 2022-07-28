{{
    config(
        materialized='table'
    )
}}

select
  MD5(a.ASSET_ID||'^'||da.ASSET_ID) as L_DS_DATA_AREA_SK,
  'COLLIBRA' as SYS_SOURCE_ID,
  sysdate() as SYS_LOAD_TIME,
  MD5(a.ASSET_ID) as DATA_SET_SK,
  MD5(da.ASSET_ID) as DATA_AREA_SK
from {{source('collibra_source_tables','ASSET') }} a
join {{source('collibra_source_tables','RELATION') }} r on a.ASSET_ID = r.ASSET_ID1 and r.ASSET_TYPE_NAME2 = 'Data Area'
join {{source('collibra_source_tables','ASSET') }} da on da.ASSET_ID = r.ASSET_ID2
where a.ASSET_TYPE_NAME = 'Data Set'