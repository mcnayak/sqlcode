--------------------------------------------------------
-- db_size.sql
--
-- This SQL Plus script lists freespace by tablespace
--------------------------------------------------------

column dummy noprint
column  pct_used format 999.9       heading "%|Used"
column  name    format a16      heading "Tablespace Name"
column  Kbytes   format 999,999,999,999    heading "KBytes"
column  used    format 999,999,999,999   heading "Used"
column  free    format 999,999,999,999  heading "Free"
column  largest    format 999,999,999,999  heading "Largest"
break   on report
compute sum of kbytes on report
compute sum of free on report
compute sum of used on report

select nvl(b.tablespace_name,
             nvl(a.tablespace_name,'UNKOWN')) name,
       kbytes_alloc kbytes,
       kbytes_alloc-nvl(kbytes_free,0) used,
       nvl(kbytes_free,0) free,
       ((kbytes_alloc-nvl(kbytes_free,0))/
                          kbytes_alloc)*100 pct_used,
       nvl(largest,0) largest
from ( select sum(bytes)/1024 Kbytes_free,
              max(bytes)/1024 largest,
              tablespace_name
       from  sys.dba_free_space
       group by tablespace_name ) a,
     ( select sum(bytes)/1024 Kbytes_alloc,
              tablespace_name
       from sys.dba_data_files
       group by tablespace_name )b
where a.tablespace_name (+) = b.tablespace_name
order by &1
/
-----------------------------------------------------