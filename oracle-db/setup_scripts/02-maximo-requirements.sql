
ALTER SYSTEM SET open_cursors=3000 scope=both;
ALTER SYSTEM SET cursor_sharing=FORCE scope=both;
ALTER SYSTEM SET processes=4000 scope=spfile;
ALTER SYSTEM SET session_cached_cursors=400 scope=spfile;
ALTER SYSTEM SET session_max_open_files=300 scope=spfile;
ALTER SYSTEM SET sessions=4000 scope=spfile;
ALTER SYSTEM SET transactions=2425 scope=spfile;

--open cursors: 3000
--processes: 4000
--session_cached_cursors: 400
--session_max_open_files: 300
--sessions: 4000
--transactions: 2425
--workarea_size_policy: AUTO (default)
--https://www.ibm.com/support/pages/maximo-76x-manually-configuring-oracle-database

SHUTDOWN IMMEDIATE;
STARTUP;

ALTER SESSION SET CONTAINER=FREEPDB1;


create or replace 
TRIGGER ALTER_NLS 
AFTER LOGON ON DATABASE 
BEGIN
  execute immediate 'ALTER SESSION SET NLS_LENGTH_SEMANTICS="CHAR"';
END;
/

