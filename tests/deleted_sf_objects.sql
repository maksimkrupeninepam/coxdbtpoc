
select
  q.ONAME as MISSED_SF_OBJECT,
  max(date_trunc('DAY', q.QUERY_START_TIME)) as MAX_QUERY_DATE,
  count(distinct QUERY_SK)
from {{ref('l_sf_query_object') }} q
left join {{ref('s_sf_object_info') }} o on q.SF_OBJECT_SK = o.SF_OBJECT_SK
where o.SF_OBJECT_SK is NULL
group by 1
order by 3 desc
