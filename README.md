
# premise
- 脚本默认本地机器是Ubuntu环境，远程机器是CentOS环境
- 本地机器和远程机器需要配置免密登录
- 本地机器和远程机器需要rsync环境

# todo
- 支持传输文件或传输文件夹
- 支持自定义限速，默认180MB/s 【10Gb机器可以执行6个rsync任务,带宽总消耗:8.5Gb】
- 支持检测远程机器网络是否可达
- 支持本地和远程机器自动装rsync环境 【默认本地机器是Ubuntu环境，远程机器是CentOS环境】
- 支持钉钉告警

# usage
```
bash rsync.sh <localpath/localfile> <remoteip> <remote_path> [speed(MB/s)]

## 文件夹传输
bash rsync.sh /nfs/hd01/sealed 172.10.11.206 /nfs/hd01/sealed 180
## 文件传输
bash rsync.sh /nfs/hd01/sealed/s-t01000-11 172.10.11.206 /nfs/hd01/sealed 180
```

# batch
vi batch1.sh
```
bash rsync.sh /nfs/hd01/sealed 172.10.11.206 /nfs/hd01/sealed
bash rsync.sh /nfs/hd02/sealed 172.10.11.206 /nfs/hd02/sealed
bash rsync.sh /nfs/hd03/sealed 172.10.11.206 /nfs/hd03/sealed
bash rsync.sh /nfs/hd04/sealed 172.10.11.206 /nfs/hd04/sealed
bash rsync.sh /nfs/hd05/sealed 172.10.11.206 /nfs/hd05/sealed
bash rsync.sh /nfs/hd06/sealed 172.10.11.206 /nfs/hd06/sealed
```

vi batch2.sh
```
bash rsync.sh /nfs/hd07/sealed 172.10.11.206 /nfs/hd07/sealed
bash rsync.sh /nfs/hd08/sealed 172.10.11.206 /nfs/hd08/sealed
bash rsync.sh /nfs/hd09/sealed 172.10.11.206 /nfs/hd09/sealed
bash rsync.sh /nfs/hd10/sealed 172.10.11.206 /nfs/hd10/sealed
bash rsync.sh /nfs/hd11/sealed 172.10.11.206 /nfs/hd11/sealed
bash rsync.sh /nfs/hd12/sealed 172.10.11.206 /nfs/hd12/sealed
```

......

vi batch6.sh
```
bash rsync.sh /nfs/hd31/sealed 172.10.11.206 /nfs/hd31/sealed
bash rsync.sh /nfs/hd32/sealed 172.10.11.206 /nfs/hd32/sealed
bash rsync.sh /nfs/hd33/sealed 172.10.11.206 /nfs/hd33/sealed
bash rsync.sh /nfs/hd34/sealed 172.10.11.206 /nfs/hd34/sealed
bash rsync.sh /nfs/hd35/sealed 172.10.11.206 /nfs/hd35/sealed
bash rsync.sh /nfs/hd36/sealed 172.10.11.206 /nfs/hd36/sealed
```
