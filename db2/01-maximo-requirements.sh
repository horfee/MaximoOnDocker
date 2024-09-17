su - db2inst1 << EOF
db2 create db $DBNAME ALIAS $DBNAME using codeset UTF-8 territory US pagesize 32 K
db2 connect to $DBNAME
db2 connect reset

db2 update db cfg for $DBNAME using SELF_TUNING_MEM ON
db2 update db cfg for $DBNAME using APPGROUP_MEM_SZ 16384 DEFERRED
db2 update db cfg for $DBNAME using APPLHEAPSZ 2048 AUTOMATIC DEFERRED
db2 update db cfg for $DBNAME using AUTO_MAINT ON DEFERRED
db2 update db cfg for $DBNAME using AUTO_TBL_MAINT ON DEFERRED
db2 update db cfg for $DBNAME using AUTO_RUNSTATS ON DEFERRED
db2 update db cfg for $DBNAME using AUTO_REORG ON DEFERRED
db2 update db cfg for $DBNAME using AUTO_DB_BACKUP ON DEFERRED
db2 update db cfg for $DBNAME using CATALOGCACHE_SZ 800 DEFERRED
db2 update db cfg for $DBNAME using CHNGPGS_THRESH 40 DEFERRED
db2 update db cfg for $DBNAME using DBHEAP AUTOMATIC
db2 update db cfg for $DBNAME using LOCKLIST AUTOMATIC DEFERRED
db2 update db cfg for $DBNAME using LOGBUFSZ 1024 DEFERRED
db2 update db cfg for $DBNAME using LOCKTIMEOUT 300 DEFERRED
db2 update db cfg for $DBNAME using LOGPRIMARY 20 DEFERRED
db2 update db cfg for $DBNAME using LOGSECOND 100 DEFERRED
db2 update db cfg for $DBNAME using LOGFILSIZ 8192 DEFERRED
db2 update db cfg for $DBNAME using SOFTMAX 1000 DEFERRED
db2 update db cfg for $DBNAME using MAXFILOP 61440 DEFERRED
db2 update db cfg for $DBNAME using PCKCACHESZ AUTOMATIC DEFERRED
db2 update db cfg for $DBNAME using STAT_HEAP_SZ AUTOMATIC DEFERRED
db2 update db cfg for $DBNAME using STMTHEAP AUTOMATIC DEFERRED
db2 update db cfg for $DBNAME using UTIL_HEAP_SZ 10000 DEFERRED
db2 update db cfg for $DBNAME using DATABASE_MEMORY AUTOMATIC DEFERRED
db2 update db cfg for $DBNAME using AUTO_STMT_STATS OFF DEFERRED
db2 update db cfg for $DBNAME using STMT_CONC LITERALS DEFERRED
db2 update alert cfg for database on $DBNAME using db.db_backup_req SET THRESHOLDSCHECKED YES
db2 update alert cfg for database on $DBNAME using db.tb_reorg_req SET THRESHOLDSCHECKED YES
db2 update alert cfg for database on $DBNAME using db.tb_runstats_req SET THRESHOLDSCHECKED YES
db2 update dbm cfg using PRIV_MEM_THRESH 32767 DEFERRED
db2 update dbm cfg using KEEPFENCED NO DEFERRED
db2 update dbm cfg using NUMDB 2 DEFERRED
db2 update dbm cfg using RQRIOBLK 65535 DEFERRED
db2 update dbm cfg using HEALTH_MON OFF DEFERRED
db2 update dbm cfg using AGENT_STACK_SZ 1000 DEFERRED
db2 update dbm cfg using MON_HEAP_SZ AUTOMATIC DEFERRED
db2set DB2_SKIPINSERTED=ON
db2set DB2_INLIST_TO_NLJN=YES
db2set DB2_MINIMIZE_LISTPREFETCH=Y
db2set DB2_EVALUNCOMMITTED=YES
db2set DB2_FMP_COMM_HEAPSZ=65536
db2set DB2_SKIPDELETED=ON
db2set DB2_USE_ALTERNATE_PAGE_CLEANING=ON

db2stop force
db2start