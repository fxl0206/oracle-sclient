#!/bin/bash
#su - oracle -s /bin/bash install.sh
SERVER_NAME=oracle11g

status(){
   echo "==========status======="
   lsnrctl status
}
start() {
        echo "================ start ${SERVER_NAME} ===========";
        lsnrctl start
        sqlplus / as sysdba @ script/start.sql
        echo "==========${SERVER_NAME} start success===========";
}
stop() {
        sqlplus / as sysdba @ script/stop.sql
        lsnrctl stop
        echo "===========${SERVER_NAME} stop success !============";
}
restart() {
    stop;
    echo "sleeping.........";
    sleep 3;
    start;
}
install(){
  initEvn;
  installServer;
  installListener;
  installdb;
}
initEvn(){
   echo "install rpms.................."
  yum install -y binutils compat-libcap1 compat-libstdc++-33 gcc-c++ glibc glibc-devel 
  yum install -y ksh libgcc libstdc++ libstdc++-devel libaio libaio-devel make sysstat unixODBC unixODBC-devel
  echo "init Env.................."

  echo "export TMP=/tmp" >> /etc/profile
  echo "export TMPDIR=\$TMP" >> /etc/profile
  echo "export ORACLE_BASE=/u01/app/oracle" >> /etc/profile
  echo "export ORACLE_HOME=\$ORACLE_BASE/product/11.2.0/db_1" >> /etc/profile
  echo "export ORACLE_SID=orcl" >> /etc/profile
  echo "export ORACLE_TERM=xterm" >> /etc/profile
  echo "export PATH=\$ORACLE_HOME/bin:/usr/sbin:\$PATH" >> /etc/profile
  echo "export LD_LIBRARY_PATH=\$ORACLE_HOME/lib:/lib:/usr/lib" >> /etc/profile
  echo "export CLASSPATH=\$ORACLE_HOME/JRE:\$ORACLE_HOME/jlib:\$ORACLE_HOME/rdbms/jlib" >> /etc/profile
  source /etc/profile
  echo $ORACLE_SID
  echo "init Env success~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
  
  echo "oracle soft nproc 2047" >> /etc/security/limits.conf
  echo "oracle hard nproc 16384" >> /etc/security/limits.conf
  echo "oracle soft nofile 1024" >> /etc/security/limits.conf
  echo "oracle hard nofile 65536" >> /etc/security/limits.conf
  echo "oracle soft stack 102405" >> /etc/security/limits.conf
  systemctl stop firewalld.service
  systemctl disable firewalld.service
  
  echo "init user.................."
  cp -R rsps/* /etc
  groupadd oinstall 
  groupadd dba
  useradd -g oinstall -G dba oracle
  mkdir /u01
  mkdir /u01/app
  mkdir -p /u01/app/oracle/oradata
  mkdir /u01/app/oracle/oradata_back
  chown -R oracle.oinstall /u01/app
  chmod 775 /u01/app
}
installServer(){
  echo "install database.................."
  source /etc/profile
  su - oracle -c "source /etc/profile && cd /data/database && ./runInstaller -silent -ignorePrereq -responseFile /etc/db_install.rsp"
  #cd /data/database 
  #./runInstaller -silent -ignorePrereq -responseFile /etc/db_install.rsp
  while true
  do
     v_count=`ps -aux | grep install | grep java | grep -v grep |wc -l`
     if [ $v_count -eq  0 ]
     then
     break
     else
     echo "is installing database,sleep 30 minues!"
     sleep 30
     fi
  done
  
  while true
  do
     if [ -f /u01/app/oracle/oraInventory/orainstRoot.sh ]; then
        break
     else
        echo "is installing database,sleep 10 minues!"
        sleep 10
     fi
  done
  while true
  do
     if [ -f /u01/app/oracle/product/11.2.0/db_1/root.sh ]; then
        break
     else
        echo "is installing database,sleep 10 minues!"
        sleep 10
     fi
  done
  
  /u01/app/oracle/oraInventory/orainstRoot.sh
  /u01/app/oracle/product/11.2.0/db_1/root.sh
  echo "install database successful!.................."
  sleep 30
}
installListener(){
  echo "install listener.................."
  su - oracle -c "source /etc/profile && netca /silent /responsefile /etc/netca.rsp"
  #netca /silent /responsefile /etc/netca.rsp
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
  echo "install listener successful!.................."
  su - oracle -c "source /etc/profile && lsnrctl stop"
  echo "SID_LIST_LISTENER =" > /u01/app/oracle/product/11.2.0/db_1/network/admin/listener.ora
  echo " (SID_LIST =" >> /u01/app/oracle/product/11.2.0/db_1/network/admin/listener.ora
  echo " (SID_DESC =" >> /u01/app/oracle/product/11.2.0/db_1/network/admin/listener.ora
  echo " (SID_NAME = PLSExtProc)" >> /u01/app/oracle/product/11.2.0/db_1/network/admin/listener.ora
  echo " (ORACLE_HOME = /u01/app/oracle/product/11.2.0/db_1)" >> /u01/app/oracle/product/11.2.0/db_1/network/admin/listener.ora
  echo " (PROGRAM = extproc)" >> /u01/app/oracle/product/11.2.0/db_1/network/admin/listener.ora
  echo " )" >> /u01/app/oracle/product/11.2.0/db_1/network/admin/listener.ora
  echo " (SID_DESC =" >> /u01/app/oracle/product/11.2.0/db_1/network/admin/listener.ora
  echo " (GLOBAL_DBNAME =orcl)" >> /u01/app/oracle/product/11.2.0/db_1/network/admin/listener.ora
  echo " (ORACLE_HOME = /u01/app/oracle/product/11.2.0/db_1)" >> /u01/app/oracle/product/11.2.0/db_1/network/admin/listener.ora
  echo " (SID_NAME =orcl)" >> /u01/app/oracle/product/11.2.0/db_1/network/admin/listener.ora
  echo " )" >> /u01/app/oracle/product/11.2.0/db_1/network/admin/listener.ora
  echo " )" >> /u01/app/oracle/product/11.2.0/db_1/network/admin/listener.ora
  echo "#LISTENER =" >> /u01/app/oracle/product/11.2.0/db_1/network/admin/listener.ora
  echo "#  (DESCRIPTION_LIST =" >> /u01/app/oracle/product/11.2.0/db_1/network/admin/listener.ora
  echo "#    (DESCRIPTION =" >> /u01/app/oracle/product/11.2.0/db_1/network/admin/listener.ora
  echo "#      (ADDRESS = (PROTOCOL = IPC)(KEY = EXTPROC1521))" >> /u01/app/oracle/product/11.2.0/db_1/network/admin/listener.ora
  echo "#      (ADDRESS = (PROTOCOL = TCP)(HOST = 20.26.1.21)(PORT = 1521))" >> /u01/app/oracle/product/11.2.0/db_1/network/admin/listener.ora
  echo "#    )" >> /u01/app/oracle/product/11.2.0/db_1/network/admin/listener.ora
  echo "#  )" >> /u01/app/oracle/product/11.2.0/db_1/network/admin/listener.ora
  echo "#ADR_BASE_LISTENER = /u01/app/oracle" >> /u01/app/oracle/product/11.2.0/db_1/network/admin/listener.ora
  su - oracle -c "source /etc/profile && lsnrctl start"
  su - oracle -c "source /etc/profile && lsnrctl status"
}
installdb(){
  echo "install DB.................."
  source /etc/profile
  su - oracle -c "source /etc/profile && dbca -silent -responseFile /etc/dbca.rsp"
  source /etc/profile
  ps -ef | grep ora_ | grep -v grep
  lsnrctl status
  echo "install DB successful.................."
}
case "$1" in
    'start')
        start
        ;;
    'stop')
        stop
        ;;
    'status')
        status
        ;;
    'restart')
        restart
        ;;
    'install')
        install
        ;;
    'installServer')
        installServer
        ;;
    'installListener')
        installListener
        ;;
   'installdb')
        installdb
        ;;
    *)
    echo "usage: $0 {start|stop|restart|status|link|install}"
    exit 1
        ;;
    esac
