spool catctxsys.log 
@$ORACLE_HOME/ctx/admin/catctx.sql CTXSYS SYSAUX TEMP NOLOCK;

connect system/Smartway1@FREE

alter user CTXSYS DISABLE DICTIONARY PROTECTION;
alter user CTXSYS account unlock;

connect system/Smartway1@FREEPDB1
alter user CTXSYS account unlock;

connect CTXSYS/CTXSYS@FREEPDB1
@$ORACLE_HOME/ctx/admin/defaults/drdefus.sql;

connect system/Smartway1@FREEPDB1

Create tablespace maxdata datafile '/opt/oracle/oradata/FREE/FREEPDB1/maxdata.dbf' size 1000M autoextend on;
Create tablespace maxindex datafile '/opt/oracle/oradata/FREE/FREEPDB1/maxindex.dbf' size 1000M autoextend on;
create temporary tablespace maxtemp tempfile '/opt/oracle/oradata/FREE/FREEPDB1/maxtemp.dbf' size 1000M autoextend on maxsize unlimited;

create user maximo identified by maximo default tablespace maxdata temporary tablespace maxtemp;
alter user maximo quota unlimited on maxindex;

grant connect to maximo;
grant create job to maximo;
grant create trigger to maximo;
grant create session to maximo;
grant create sequence to maximo;
grant create synonym to maximo;
grant create table to maximo;
grant create view to maximo;
grant create procedure to maximo;
grant alter session to maximo;
grant execute on ctxsys.ctx_ddl to maximo;
alter user maximo quota unlimited on maxdata;


create or replace 
TRIGGER ALTER_NLS 
AFTER LOGON ON DATABASE 
BEGIN
  execute immediate 'ALTER SESSION SET NLS_LENGTH_SEMANTICS="CHAR"';
END;
/

ALTER SYSTEM SET open_cursors=1000 scope=both;
