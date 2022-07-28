{{
    config(
        materialized='table'
    )
}}

select
  MD5(ds.asset_id||'^'||UPPER(EXPRESSION_LONG)) as L_DS_TECH_POC_SK,
  'COLLIBRA' as SYS_SOURCE_ID,
  sysdate() as SYS_LOAD_TIME,
  MD5(ds.asset_id) as DATA_SET_SK,
  MD5(UPPER(EXPRESSION_LONG)) as USER_SK
from {{source('collibra_source_tables','ASSET') }} ds
join {{source('collibra_source_tables','RELATION') }} rt on ds.ASSET_ID = rt.ASSET_ID1 and rt.ASSET_TYPE_NAME2 = 'Point of Contact' and rt.ROLE_OR_COROLE = 'Technical Point of Contact'
join {{source('collibra_source_tables','ASSET') }} t on t.ASSET_ID = rt.ASSET_ID2
join {{source('collibra_source_tables','ATTRIBUTE') }} a on a.ASSET_ID = t.ASSET_ID
where ds.ASSET_TYPE_NAME = 'Data Set'
