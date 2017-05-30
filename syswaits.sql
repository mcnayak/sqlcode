set pagesize 999
set verify off
column event format a30


select e.inst_id,e.wait_class,count(e.TOTAL_WAITS)
from gv$system_event e   
where e.event like nvl('&event',e.event)
group by e.inst_id, e.wait_class
order by 3 desc;

select e.inst_id,e.EVENT,e.TOTAL_WAITS,e.TOTAL_TIMEOUTS, e.TIME_WAITED waited, e.AVERAGE_WAIT avg_wait
from gv$system_event e 
where event like nvl('&event',event)
order by 3 desc;
