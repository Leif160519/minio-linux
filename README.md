## minio [官方中文文档](https://docs.minio.io/cn/)

## 1.文件结构
```
minio-linux
├── cluster                            # 集群
│   ├── docker-compose.yml               # 单主机集群方式，可用于测试
│   └── nginx.conf                       # nginx配置文件
└── single                             # 单节点
    ├── docker-compose.yml               # Docker部署方式
    └── minio.sh                         # Shell脚本方式
```

## 2.使用prometheus监控minio
[官方文档](https://docs.minio.io/docs/how-to-monitor-minio-using-prometheus.html)

- 1.为Prometheus指标配置身份验证类型
MinIO支持Prometheus `jwt`或两种身份验证模式`public`，默认情况下，MinIO在`jwt`模式下运行。要允许对普罗米修斯度量标准不进行身份验证就可以进行公共访问，请按如下所示设置环境。
```
export MINIO_PROMETHEUS_AUTH_TYPE="public"
```
配置之后重启minio服务

- 2.配置Public Prometheus:
```
  - job_name: minio-job
    metrics_path: /minio/prometheus/metrics
    scheme: http
    static_configs:
    - targets: ['<minio_server>:9000']
```
配置之后重启Prometheus

详细操作步骤和性能参数介绍请参看官方教程:[how-to-monitor-minio-using-prometheus](https://docs.minio.io/docs/how-to-monitor-minio-using-prometheus.html)

- 3.Grafana添加监控模板
可以使用官方手册推荐的[minio-overview.json](https://raw.githubusercontent.com/minio/minio/master/docs/metrics/prometheus/grafana/minio-overview.json),也可以使用grafana labs上的模板，分别为(部分模板无数据需要根据性能指标修改)：

[Minio Overview-12617](https://grafana.com/grafana/dashboards/12617)

![image.png](images/1.png)

[MinIO Object Storage-12563](https://grafana.com/grafana/dashboards/12563/reviews)

![image.png](images/2.png)

[Minio 监控-12063](https://grafana.com/grafana/dashboards/12063)

![image.png](images/3.png)

## 3.使用s3fs挂载minio对象存储

- 1.编辑docker-compose文件，挂载本机localtime文件保证容器与宿主机时间同步（时区不同步也会挂载失败）
```
volumes:
  - /etc/localtime:/etc/localtime

...
```

- 2.安装`s3fs-fuse`
```
# centos
yum -y install s3fs-fuse

# ubuntu
apt-get -y install s3fs
```

- 3.配置`.passwd-minio`
```
echo <MINIO_ACCESS_KEY>:<MINIO_SECRET_KEY> > .passwd-minio

# 注意修改文件权限为只读
chmod 600 .passwd-minio
```

- 4.去minio网页创建bucket

- 5.挂载文件系统
```
s3fs -o passwd_file=.passwd-minio -o use_path_request_style -o endpoint=us-east-1 -o url=http://<mionio_server>:9000 -o bucket=<bucket_name> <mount_dir>
```

> 参数解释：
- passed_file: 指定密码文件
- endpoint：节点，默认美国东一区
- url：minio服务端ip地址
- bucket：存储桶名称

参考：[使用s3fs-fuse 挂载minio s3 对象存储](https://www.cnblogs.com/rongfengliang/p/10790072.html)

## 4.windows安装minio
- [Running MinIO as a service on Windows](https://github.com/minio/minio-service/tree/master/windows)

## 5.客户端上传文件到服务端
- 安装mc客户端，下载地址:[mc](https://dl.min.io/client/mc/release/linux-amd64/mc)
- 安装minio服务端，下载地址:[minio](https://dl.min.io/server/minio/release/linux-amd64/minio)
- 启动服务端: `minio server /data`
- 进入minio页面，新建bucket:`share`
- 指定存储桶的名称:`mc alias set s3 http://127.0.0.1:9000 minio minio123 --api s3v4`
- 客户端复制文件到存储桶上:`mc cp --recursive <file_name> s3/share`

> 参考资料:[MinIO Client完全指南](https://docs.min.io/cn/minio-client-complete-guide.html)
