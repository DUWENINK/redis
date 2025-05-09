# Redis哨兵模式集群

这是一个基于Docker的Redis哨兵模式集群配置，包含一个主节点、两个从节点和三个哨兵节点。

## 架构说明

### 节点配置
- 主节点（Master）：端口 6379
- 从节点1（Slave1）：端口 6380
- 从节点2（Slave2）：端口 6381
- 哨兵节点1：端口 26379
- 哨兵节点2：端口 26380
- 哨兵节点3：端口 26381

### 认证信息
- 所有Redis节点密码：bjtest123

## 快速开始

### 1. 环境要求
- Docker
- Docker Compose

### 2. 启动集群
```bash
# 构建并启动所有服务
docker-compose up -d

# 查看服务状态
docker-compose ps
```

### 3. 验证集群状态

#### 连接主节点
```bash
redis-cli -p 6379 -a bjtest123
```

#### 连接从节点
```bash
# 从节点1
redis-cli -p 6380 -a bjtest123

# 从节点2
redis-cli -p 6381 -a bjtest123
```

#### 连接哨兵节点
```bash
redis-cli -p 26379
```

### 4. 常用命令

#### 查看主从状态
```bash
# 在主节点执行
info replication
```

#### 查看哨兵状态
```bash
# 在哨兵节点执行
info sentinel
```

## 配置说明

### Redis主节点配置（redis.conf）
- 端口：6379
- 密码：bjtest123
- 启用AOF持久化
- 允许远程连接

### 哨兵配置（sentinel.conf）
- 监控主节点
- 故障转移超时：10秒
- 主观下线时间：5秒
- 需要2个哨兵同意才能进行故障转移

## 数据持久化

所有Redis节点都配置了AOF持久化，数据存储在Docker卷中：
- redis-master-data
- redis-slave1-data
- redis-slave2-data

## 故障转移

当主节点发生故障时，哨兵节点会自动进行故障转移：
1. 哨兵检测到主节点不可用
2. 选举新的主节点
3. 其他从节点切换到新的主节点
4. 原主节点恢复后成为从节点

## 注意事项

1. 生产环境部署时，建议：
   - 修改默认密码
   - 调整内存限制
   - 配置适当的持久化策略
   - 考虑网络隔离

2. 数据安全：
   - 定期备份数据
   - 监控集群状态
   - 设置适当的访问控制

## 维护命令

```bash
# 停止集群
docker-compose down

# 查看日志
docker-compose logs

# 重启特定服务
docker-compose restart redis-master

# 查看容器状态
docker-compose ps
```

## 故障排查

1. 检查容器状态：
```bash
docker-compose ps
```

2. 查看容器日志：
```bash
docker-compose logs redis-master
docker-compose logs redis-slave1
docker-compose logs sentinel1
```

3. 进入容器：
```bash
docker exec -it redis-master bash
```

## 许可证

MIT 