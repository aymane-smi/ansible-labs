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

ansible app -b -m yum -a "name=mariadb-server state=present"
ansible app -b -m pip -a "name=mariadb state=started"