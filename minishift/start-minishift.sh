#!/bin/sh

echo '##############################################################'
echo '##  CHANGE DEFAULT VARS'
echo '##############################################################'
export HOMEPATH=G:\\minishift_home
export USERPROFILE=G:\\minishift_home
export MINISHIFT_ENABLE_EXPERIMENTAL=y
echo 'HOMEPATH : ' $HOMEPATH
echo 'USERPROFILE : ' $USERPROFILE

 

echo ''
echo '##############################################################'
echo '##  create dev profile for minishift'
echo '## using the following iso to ensure static ip : https://github.com/minishift/minishift-centos-iso'
echo '##############################################################'

minishift profile set dev
minishift config set memory 8092
minishift config set cpus 4
minishift config set vm-driver virtualbox
minishift config set openshift-version v3.11.0
minishift config set iso-url file://G:/minishift/minishift-centos7.iso

minishift config view


echo ''
echo '##############################################################'
echo '##  start minishift with profile dev'
echo '##############################################################'
minishift start

 
echo ''
echo '##############################################################'
echo '##  exporting required vars'
echo '##############################################################'
eval $(minishift oc-env)



echo ''
echo '##############################################################'
echo '##  Openshift cluster configuration'
echo '##############################################################'
echo 'login to system'
oc login -u system:admin
echo 'add-cluster-role-to-user admin'
oc adm policy add-cluster-role-to-user cluster-admin admin


