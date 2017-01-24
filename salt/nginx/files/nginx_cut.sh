#!/bin/bash
#Nginx 日志文件存放的路径
nginx_access_log="/application/nginx/logs/access"
nginx_error_log="/application/nginx/logs/error" 

#备份存放的路径
access_log_path="/logs/nginx_log/access/"
error_log_path="/logs/nginx_log/error/"

# backup access_log_path
if [ ! -e ${access_log_path} ]
	then
		mkdir -p ${access_log_path}
fi

# backup error_log_path
if [ ! -e ${error_log_path}  ]
	then
		mkdir -p ${error_log_path}
fi

#访问日志备份
backup_access="${access_log_path}$(date -d "yesterday" +"%Y")/$(date -d "yesterday" +"%m")/$(date -d "yesterday" +"%d")"
if [ ! -e ${backup_access}  ]
	then
		mkdir -p ${backup_access}
fi

mv ${nginx_access_log}/*  ${backup_access}
#错误日志备份
backup_error="${error_log_path}$(date -d "yesterday" +"%Y")/$(date -d "yesterday" +"%m")/$(date -d "yesterday" +"%d")"
if [ ! -e ${backup_error}  ]
	then
		mkdir -p ${backup_error}
fi
mv ${nginx_error_log}/* ${backup_error}

#重新生成日志
kill -USR1 `cat /application/nginx/logs/nginx.pid`
