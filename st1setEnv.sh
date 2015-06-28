export TMP=/tmp
export TMPDIR=$TMP
export ORACLE_BASE=/u01/app/oracle
export ORACLE_HOME=$ORACLE_BASE/product/11.2.0/db_1
export ORACLE_SID=orcl
export ORACLE_TERM=xterm
export PATH=$ORACLE_HOME/bin:/usr/sbin:$PATH
export LD_LIBRARY_PATH=$ORACLE_HOME/lib:/lib:/usr/lib
export CLASSPATH=$ORACLE_HOME/JRE:$ORACLE_HOME/jlib:$ORACLE_HOME/rdbms/jlib
echo "export TMP=/tmp" >> /etc/profile
echo "export TMPDIR=$TMP" >> /etc/profile
echo "export ORACLE_BASE=/u01/app/oracle" >> /etc/profile
echo "export ORACLE_HOME=$ORACLE_BASE/product/11.2.0/db_1" >> /etc/profile
echo "export ORACLE_SID=orcl" >> /etc/profile
echo "export ORACLE_TERM=xterm" >> /etc/profile
echo "export PATH=$ORACLE_HOME/bin:/usr/sbin:$PATH" >> /etc/profile
echo "export LD_LIBRARY_PATH=$ORACLE_HOME/lib:/lib:/usr/lib" >> /etc/profile
echo "export CLASSPATH=$ORACLE_HOME/JRE:$ORACLE_HOME/jlib:$ORACLE_HOME/rdbms/jlib" >> /etc/profile
source /etc/profile
echo $ORACLE_SID

echo "oracle soft nproc 2047" >> /etc/security/limits.conf
echo "oracle hard nproc 16384" >> /etc/security/limits.conf
echo "oracle soft nofile 1024" >> /etc/security/limits.conf
echo "oracle hard nofile 65536" >> /etc/security/limits.conf
echo "oracle soft stack 102405" >> /etc/security/limits.conf
