#!/bin/sh
# RMAN Backup Rate MOS 2066528.1  
# Pull an AWR report based on Note 785730.1 

sqlplus -s rasys/ra << EOF
SELECT  DB_NAME
      , SESSION_KEY
     , TO_CHAR(START_TIME,'mm/dd/yy hh24:mi') start_time
     , TO_CHAR(END_TIME,'mm/dd/yy hh24:mi')   end_time
     , ELAPSED_SECONDS/3600                   hrs     
     , INPUT_TYPE
     , COMPRESSION_RATIO
     , INPUT_BYTES_DISPLAY in_size
     , OUTPUT_BYTES_DISPLAY out_size
  FROM RC_RMAN_BACKUP_JOB_DETAILS 
 WHERE DB_NAME = 'DB1212' 
   AND TRUNC(START_TIME) BETWEEN  TO_DATE('01-10-2015','DD-MM-YYYY') AND TO_DATE('04-10-2015','DD-MM-YYYY') 
 ORDER BY SESSION_KEY;
 
 exit;
 EOF
 