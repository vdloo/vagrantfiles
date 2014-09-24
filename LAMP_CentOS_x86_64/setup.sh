#!/bin/bash
type -p yum \
	&& (
		yum -y install wget vim-enhanced git mysql-server mysql php php-mysql httpd;\
		chkconfig httpd on ;\
		chkconfig mysqld on ;\
		apachectl start ;\
	)
