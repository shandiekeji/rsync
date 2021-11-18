#! /bin/bash

if [ -z $1 ]; then ## tips
  echo -e "\033[34m 
  bash rsync.sh <localpath/localfile> <remoteip> <remote_path>
  \033[0m"
fi

localpath=$1
remoteip=$2
remotepath=$3
host=`hostname -I | awk '{print $1}'`
localip=$host
echo localip=$localip  localpath=$localpath  remoteip=$remoteip  remotepath=$remotepath

# Dingding Msg
function SendMsgToDingding() {
  curl 'https://oapi.dingtalk.com/robot/send?access_token=0c8182a9de1645891a296574128323b74e2ac51c34453fbca82831a6c9e9d497' -H 'Content-Type: application/json' -d "
  {
    'msgtype': 'text',
    'text': {
      'content': 'rsync告警：\n  $1'
    },
    'at': {
      'isAtAll': true
    }
  }"
}

# ip地址有效性检测
#ip_check_valid=$(echo $remoteip|awk -F. '$1<=255&&$2<=255&&$3<=255&&$4<=255{print "yes"}')
# ip是否ping通
ip_ping_check=`ping $remoteip -c 2 | grep -q  'ttl='  && echo "yes" || echo "no"`
#echo $ip_ping_check

while [ $ip_ping_check == "yes" ]
do
  # 本地装rsync
  RESULT=$(rsync --version|head -1|awk '{print $3}')
  RESULT=${RESULT%.*}
  #echo $RESULT
  if [ -z $RESULT ] || [ `expr $RESULT \> 3.0` -eq 0 ]; then
    echo "rsync version must > 3.0 "
    apt install rsync -y
  fi
  # 远端装rsync
  RESULT=`ssh root@${remoteip} "rsync --version"|head -1|awk '{print $3}'`
  RESULT=${RESULT%.*}
  #echo $RESULT
  if [ -z $RESULT ] || [ `expr $RESULT \> 3.0` -eq 0 ]; then
    echo "rsync version must > 3.0 "
    RESULT=`ssh root@${remoteip} "yum install rsync -y"`
  fi

  # /var/log/rsync
  if [ ! -d "/var/log/rsync" ]; then
    mkdir /var/log/rsync
  fi

  # file or directory
  if [ -d $localpath ]; then
    #echo "$localpath is a directory."
    filerule="s-t0*"
  elif [ -f $localpath ]; then
    #echo "$localpath is a file."
    filerule=${localpath##*/}
    localpath=${localpath%/*}
  fi

  # 匹配文件
  for i in `ls $localpath/$filerule`
  do
    filename=${i##*/}
    
    echo "----------start $(date "+%Y-%m-%d %H:%M:%S")---------$oldpath"
    start_time=$(date +%s)
    
    oldpath="$localpath/$filename"
    oldbyte=`du $oldpath|awk '{print $1}'`
    echo "####old-info#### ${localip}"
    echo "oldpath：$oldpath"
    echo "oldbyte：$oldbyte"
    echo ""
    if [ $oldbyte -gt 0 ]; then
      # rsync --bwlimit kb/s  10240000=10Gb/s  1480000=180MB/s
      echo -e "\033[40;32m rsync -avP -e 'ssh -p 22' --bwlimit=1480000 $oldpath root@${remoteip}:$remotepath/ >> /var/log/rsync/rsync-$filename.log \033[0m"
      rsync -avP -e 'ssh -p 22' --bwlimit=1480000 $oldpath root@${remoteip}:$remotepath/ >> /var/log/rsync/rsync-$filename.log
      wait
      sleep 6
      newpath="$remotepath/$filename"
      newbyte=`ssh root@${remoteip} "du $newpath"|awk '{print $1}'`
      echo "####new-info#### ${remoteip}"
      echo "newpath：$newpath"
      echo "newbyte：$newbyte"
      echo ""
      if [ $newbyte -ne $oldbyte ]; then
        echo -e "\033[40;31m ERROR 402: 本地$localip文件$oldpath($oldbyte)与远端$remoteip文件$newpath($newbyte)大小不相等 \033[0m"
        # SendMsgToDingding "ERROR 402: 本地$localip文件$oldpath($oldbyte)与远端$remoteip文件$newpath($newbyte)大小不相等"
        sleep 3
      fi
    elif [ $oldbyte -eq 0 ]; then
      echo -e "\033[40;31m ERROR 401: 本地$localip文件$oldpath($oldbyte)大小为零 \033[0m"
      SendMsgToDingding "ERROR 401: 本地$localip文件$oldpath($oldbyte)大小为零"
      sleep 3
    fi
    
    end_time=$(date +%s)
    all_time=$[ $end_time-$start_time ]
    echo "----------end $(date "+%Y-%m-%d %H:%M:%S")---------$oldpath  cost_time: $all_time s"
    echo ""
  done
  exit
done
