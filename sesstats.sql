column name format a40
select sn.inst_id,
       sn.name, 
       ss.value
from gv$statname sn, gv$sesstat ss
where sn.statistic#=ss.statistic#
and sn.inst_id = ss.inst_id
and ss.sid='&sid'
and ss.value != 0
and lower(sn.name) like lower('%&name%')
/
exit;
