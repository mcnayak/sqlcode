#!/bin/sh
# Recovery appliance restore rates 

sqlplus -s / as sysdba << EOF
SET TERMOUT ON DEFINE "&" TAB OFF PAGES 0 EMB ON LINES 32767 TRIMSPOOL ON FEEDBACK OFF COLSEP "," NUMFORMAT 9999999999999999999999
COLUMN stamp NEW_VALUE stamp
SELECT TO_CHAR(SYSDATE, 'YYYYMMDDHH24MISS') stamp FROM dual;
SELECT * FROM rai_gvstatistics ORDER BY inst_id, indx;
#SPOOL rai_gvstat_&&stamp..lst
/
SPOOL OFF
exit
EOF