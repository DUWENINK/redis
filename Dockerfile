FROM redis:7.0

# 安装必要的工具
RUN apt-get update && apt-get install -y procps

# 创建工作目录
WORKDIR /usr/local/etc/redis

# 复制配置文件
COPY redis.conf /usr/local/etc/redis/redis.conf
COPY sentinel.conf /usr/local/etc/redis/sentinel.conf

# 设置权限
RUN chown redis:redis /usr/local/etc/redis/redis.conf /usr/local/etc/redis/sentinel.conf

# 暴露端口
EXPOSE 6379 6380 6381 26379

# 设置启动命令，使用 host 网络模式
CMD ["redis-server", "--network", "host", "/usr/local/etc/redis/redis.conf"] 