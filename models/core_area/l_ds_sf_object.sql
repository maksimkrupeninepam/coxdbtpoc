{{
    config(
        materialized='table'
    )
}}

select
  MD5(ds.asset_id||'.'||d.asset_display_name||'.'||t.asset_display_name) as L_DS_SF_OBJECT_SK,
  'COLLIBRA' as SYS_SOURCE_ID,
  sysdate() as SYS_LOAD_TIME,
  MD5(ds.asset_id) as DATA_SET_SK,
  MD5(UPPER(d.asset_display_name||'.'||t.asset_display_name)) as SF_OBJECT_SK,
  ds.asset_id||'.'||d.asset_display_name||'.'||t.asset_display_name as ONAME
from {{source('collibra_source_tables','ASSET') }} ds
join {{source('collibra_source_tables','RELATION') }} rt on ds.ASSET_ID = rt.ASSET_ID1 and rt.ASSET_TYPE_NAME2 = 'Table'
join {{source('collibra_source_tables','ASSET') }} t on t.ASSET_ID = rt.ASSET_ID2
join {{source('collibra_source_tables','RELATION') }} rd on t.ASSET_ID = rd.ASSET_ID1 and rd.ASSET_TYPE_NAME2 = 'Database'
join {{source('collibra_source_tables','ASSET') }} d on d.ASSET_ID = rd.ASSET_ID2
where ds.ASSET_TYPE_NAME = 'Data Set'