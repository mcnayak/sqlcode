--------------------------------------------------------------------------------
-- SCCS INFO : ses_wait.sql [1.25] 10/29/02 08:02:18
-- FILE INFO : ses_wait.sql
-- CREATED   : ckarthik
-- DATE      : 07/02/2000
-- DESC      : Displays Tablespace Datafile.
--------------------------------------------------------------------------------
CLEAR  COL BREAK COMPUTE
SET    PAGES 100 PAUSE OFF VERIFY OFF FEEDBACK ON ECHO OFF

COLUMN usrinfo FORMAT A42  HEADING "SID / ORAUSER / OSUSER / STATE" TRUNC
COLUMN event   FORMAT A30
COLUMN wt_m    FORMAT 9999
COLUMN state   FORMAT A20
PROMPT

BREAK on event  SKIP 1

SELECT b.event, a.inst_id || '/' || a.sid||'/'||a.username||'/'||a.osuser||' '||a.state  usrinfo,
       ROUND(a.seconds_in_wait/60) Wt_M, ROUND(a.wait_time_micro) total_wait
FROM   gv$session a, gv$session_wait b
WHERE a.inst_id = b.inst_id
AND    a.status = 'ACTIVE'
AND    a.username NOT in ('DBSNMP','SYSMAN','SYS')
AND    a.username IS NOT NULL
AND    b.sid  = NVL('&___Sid', b.sid)
AND    a.sid  = b.sid
ORDER  BY b.event
/

CLEAR COL BREAK
COL   event FORMAT A40

break on report
compute sum of cnt on report

SELECT b.event, count(*) cnt
FROM   gv$session a, gv$session_wait b
WHERE  a.username IS NOT NULL
AND    a.status = 'ACTIVE'
AND    a.username NOT in ('DBSNMP','SYSMAN','SYS')
AND    a.inst_id = b.inst_id
AND    a.sid  = b.sid
GROUP  BY  b.event
ORDER  BY 2
/

SET    PAGES 32 PAUSE OFF VERIFY OFF FEEDBACK ON ECHO OFF
PROMPT

/*
SELECT a.event, a.sid, b.sql_text FROM gv$session a, gv$sql b
WHERE a.sid in ( SELECT sid FROM gv$session a WHERE a.state in ('WAITING') and wait_class != 'Idle' AND    a.username NOT in ('DBSNMP','SYSMAN','SYS')  ) 
and ( b.sql_id = a.sql_id or b.sql_id = a.prev_sql_id) 
and a.inst_id = b.inst_id;
*/







exit;
