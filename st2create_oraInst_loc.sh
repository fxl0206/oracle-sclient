echo "inventory_loc=$ORACLE_BASE/oraInventory" >> /etc/oraInst.loc
echo "inst_group=oinstall" >> /etc/oraInst.loc
chown oracle:oinstall oraInst.loc
chmod 664 oraInst.loc

