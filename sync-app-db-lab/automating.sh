#!/bin/bash

# 1 - install chrony on all hosts

ansible multi -b -m yum -a "name=chrony state=present"

# state variable can have to values <present|installed or installed>
# you can use this commmand instead of one above
# ansible multi -b -a "yum install -y chrony"

# 2 - start chrony in all hosts

ansible multi -b -m service -a "name=chronyd state=started enabled=yes"

# for service module the best practice is to use it instead of -a "systemctl start chronyd"

# 3 - check that all hosts are synced

ansible multi -b -a "chronyc tracking"

# 4 - install python3 and django for app group

ansible app -b -m yum -a "name=python3-pip state=present"
ansible app -b -m pip -a "name=django<4 state=present"

# 5 - install maria db for db group

ansible db -b -m yum -a "name=mariadb-server state=present"
ansible db -b -m pip -a "name=mariadb state=present"

# 6 - configure the firwall to enable only app group to access to database

ansible db -b -m yum -a "name=firewalld state=present"
ansible db -b -m service -a "name=firewalld state=started enabled=yes"
ansible db -b -m firewalld -a "zone=database state=present permanent=yes"
ansible db -b -m firewalld -a "source=192.168.60.0/24 zone=database state=enabled permanent=yes"
ansible db -b -m firewalld -a "port=3306/tcp zone=database state=enabled permanent=yes"
# configure mariadb to work as mysql since mariadb s default in RedHat

ansible db -b -m yum -a "name=python3-PyMySQL state=present"
ansible db -b -m mysql_user -a "name=django host=% password=12345 priv=*.*:ALL state=present"

# 7 - add a group called "admin"

ansible app -b -m group -a "name=admin state=present"

# 8 - add user called joedoe and added to group admin
ansible app -b -m user -a "name=johndoe group=admin createhome=yes"

# 9 - add git to app group

ansible app -b -m package -a "name=git state=present"

#10 - show logs
ansible multi -b -a "tail /var/log/messages"