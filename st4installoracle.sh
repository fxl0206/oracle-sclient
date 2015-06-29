su - oracle -c "cd /data/database && ./runInstaller -silent -ignorePrereq -responseFile /etc/db_install.rsp"
/u01/app/oracle/oraInventory/orainstRoot.sh
/u01/app/oracle/product/11.2.0/db_1/root.sh

su - oracle -c "netca /silent /responsefile /etc/netca.rsp"
su - oracle -c "lsnrctl status"
su - oracle -c "dbca -silent -responseFile /etc/dbca.rsp"

ps -ef | grep ora_ | grep -v grep
