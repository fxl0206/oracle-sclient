groupadd oinstall 
groupadd dba
useradd -g oinstall -G dba oracle
mkdir /u01
mkdir /u01/app
mkdir -p /u01/app/oracle/oradata
mkdir /u01/app/oracle/oradata_back
chown -R oracle.oinstall /u01/app
chmod 775 /u01/app
