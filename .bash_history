yum install compat-libcapl compat-libstdc++
yum install compat-libcap1 compat-libstdc++-33
yum install gcc
yum install gcc gcc-c++
yum install glibc glibc-devel
yum install libgcc
yum install libgcc++
yum install libstdc
yum install libstdc++ libstdc++-devel
yum install libaio libaio-devel
yum install make
yum install sysstat
vi /etc/security/limits.conf
groupadd oinstall
groupadd dba
useradd -g oinstall -G dba oracle
mkdir /u01
mkdir /u01/app
mkdir /u01/app/oracle/oradata
mkdir -p /u01/app/oracle/oradata
mkdir /u01/app/oracle/oradata_back
chown -R oracle.oinstall /u01/app
chmod 775 /u01/app
vi /etc/profile
source /etc/profile

