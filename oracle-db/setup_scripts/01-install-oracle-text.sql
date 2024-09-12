ALTER SESSION SET CONTAINER=FREEPDB1;

spool catctxsys.log 
@$ORACLE_HOME/ctx/admin/catctx.sql CTXSYS SYSAUX TEMP NOLOCK;
@$ORACLE_HOME/ctx/admin/defaults/drdefus.sql;