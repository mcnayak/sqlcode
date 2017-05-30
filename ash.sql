-- Active Session History 
set verify off
select sample_time, event, wait_time, sql_id||'.'||sql_child_number sql_id_child
from gv$active_session_history
where session_id = &session_id
and session_serial# = &serialno
/
