#!/bin/bash

ret=$(/opt/oracle/checkDBStatus.sh)
ret=$?

if [[ "$ret" == "0" ]]; then

    ret=$(sqlplus -s / as sysdba << EOF
set heading off;
set pagesize 0;
ALTER SESSION SET CONTAINER=FREEPDB1;
SELECT COUNT(*) FROM dba_users WHERE username='MAXIMO';
exit;
EOF
)

fi

# sqlplus will display "Session altered. " and 1 if the maximo user exists (else 0)
# we then need to substring to get only the numeric value
ret=${ret:17}

exit $ret