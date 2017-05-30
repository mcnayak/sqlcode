#!/bin/sh
sqlplus -s "/as sysdba" << EOF
declare
  h1   NUMBER;
begin
     h1 := dbms_datapump.open (operation => 'EXPORT', job_mode => 'DATABASE', job_name => 'EXPORT000763', version => 'COMPATIBLE'); 
    dbms_datapump.set_parallel(handle => h1, degree => 8); 
    dbms_datapump.add_file(handle => h1, filename => 'EXPDAT.LOG', directory => 'RASYS_DUMP', filetype => 3); 
    dbms_datapump.set_parameter(handle => h1, name => 'KEEP_MASTER', value => 0); 
    dbms_datapump.metadata_filter(handle => h1, name => 'TABLESPACE_EXPR', value => 'IN(''RTL'')'); 
    dbms_datapump.add_file(handle => h1, filename => 'EXPDAT%U.DMP', directory => 'EXPDP_DIR', filetype => 1); 
    dbms_datapump.set_parameter(handle => h1, name => 'INCLUDE_METADATA', value => 1); 
    dbms_datapump.set_parameter(handle => h1, name => 'DATA_ACCESS_METHOD', value => 'AUTOMATIC'); 
    dbms_datapump.set_parameter(handle => h1, name => 'ESTIMATE', value => 'BLOCKS'); 
    dbms_datapump.start_job(handle => h1, skip_current => 0, abort_step => 0); 
    dbms_datapump.detach(handle => h1); 
end;
/
EOF
exit

# script to make full export of Oracle db using Data Pump

STARTTIME=`date`
export ORACLE_SID=zdlra011
export EXPLOG=raexp.log
export EXPDIR=rasys_dump
DATEFORMAT=`date +%Y%m%d`
STARTTIME=`date`

# Data Pump export
#expdp "'/ as sysdba'" content=ALL directory=rasys_dump filesize=10g dumpfile=expdp_%U.dmp full=Y logfile=$EXPLOG nologfile=N parallel=8 estimate_only=y

expdp "'/ as sysdba'" content=ALL directory=rasys_dump filesize=10g  full=Y logfile=$EXPLOG nologfile=N parallel=8 estimate_only=y
ENDTIME=`date`

