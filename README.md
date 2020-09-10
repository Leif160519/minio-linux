## minio [官方中文文档](https://docs.minio.io/cn/)

## 文件结构
```
minio-linux                                 
├── cluster                            # 集群
│   ├── docker-compose-cluster2.yml      # 单主机集群方式，可用于测试
│   ├── docker-compose-cluster.yml       # 多主机集群方式，每台主机都需执行
│   └── minio-cluster.sh                 # 多主机集群方式，每台主机都需执行
└── single                             # 单节点
    ├── docker-compose.yml               # Docker部署方式
    └── minio.sh                         # Shell脚本方式
```
