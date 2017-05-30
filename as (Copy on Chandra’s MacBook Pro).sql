set pagesize 999
set lines 150
col username format a13
col prog format a10 trunc
col sql_text format a61 trunc
col sid format 9999
col child for 99999
col avg_etime for 999,999.99
break on sql_text
select /* astfox */ b.inst_id NODE
     , sid
     , serial#
     , b.sql_id 
     , child_number child
     , px_servers_executions/decode(nvl(executions,0),0,1,executions) avg_px
     , executions execs
     , 
(elapsed_time/decode(nvl(executions,0),0,1,executions))/1000000 avg_etime,
decode(IO_CELL_OFFLOAD_ELIGIBLE_BYTES,0,'No','Yes') OFFLOADED
     ,sql_text     
from gv$session a, gv$sql b
where status = 'ACTIVE'
and username is not null
and a.sql_id = b.sql_id
and a.inst_id = b.inst_id
and a.sql_child_number = b.child_number
and sql_text not like '%astfox%'          -- don't show this query
and sql_text not like '%MGMT_%'           -- don't show AWR queries
and sql_text not like '%EMD_NOTIFICATION%' -- don't show OEM queries
and sql_text not like 'declare%'          -- skip PL/SQL blocks
order by b.inst_id,sql_id,sid, child
/
exit;
