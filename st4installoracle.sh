sudo cp rsps/db_install.rsp /etc
cd /data/database
./runInstaller -silent -ignorePrereq -responseFile /etc/db_install.rsp
