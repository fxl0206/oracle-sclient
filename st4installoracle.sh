source /etc/profile
su - oracle -c "cd /data/database && ./runInstaller -silent -ignorePrereq -responseFile /etc/db_install.rsp"
while true
do
   v_count=`ps -aux | grep install | grep java | grep -v grep |wc -l`
   if [ $v_count -eq  0 ]
   then
   break
   else
   echo "is installing database,sleep 10 minues!"
   sleep 10
   fi
done

while true
do
   if [ -f /u01/app/oracle/oraInventory/orainstRoot.sh ]; then
      break
   else
      echo "is installing database,sleep 10 minues!"
   fi
done
while true
do
   if [ -f /u01/app/oracle/product/11.2.0/db_1/root.sh ]; then
      break
   else
      echo "is installing database,sleep 10 minues!"
   fi
done

/u01/app/oracle/oraInventory/orainstRoot.sh
/u01/app/oracle/product/11.2.0/db_1/root.sh

su - oracle -c "netca /silent /responsefile /etc/netca.rsp"
while true
do
   v_count=`ps -aux | grep netca | grep -v grep | grep java |wc -l`
   if [ $v_count -eq  0 ]
   then
   break
   else
   echo "installing listener,sleep 10 minues!"
   sleep 10
   fi
done
su - oracle -c "lsnrctl status"
sleep 5
su - oracle -c "dbca -silent -responseFile /etc/dbca.rsp"

ps -ef | grep ora_ | grep -v grep
lsnrctl status
