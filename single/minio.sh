docker run -d \
     --name minio\
     -p 9000:9000 \
     --restart=always \
     -v /minio/data:/data \
     -v /minio/config:/root/.minio
     -v /minio/prometheus/metrics:/minio/prometheus/metrics
     -e "MINIO_ACCESS_KEY=AKIAIOSFODNN7EXAMPLE" \
     -e "MINIO_SECRET_KEY=JalrXUtnFEMIK7MDENGbPxRfiCYEXAMPLEKEY" \
     -e "MINIO_PROMETHEUS_AUTH_TYPE=public" \
     minio/minio \
     server /data
