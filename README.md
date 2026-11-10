<div align="center">

<img src="assets/brand/banner-hero.svg" alt="基石服务栈 BasicStack —— 一条 docker compose up -d 拉起 25 件自托管开发基建" width="100%"/>

# 基石服务栈 BasicStack

**一条 `docker compose up -d` 拉起 25 件自托管开发基建（MySQL/Redis/PG/ES/ClickHouse/Milvus/Neo4j/RabbitMQ/MinIO/Nacos/Langfuse/MinerU 等），端口/密码/管理台全配好，开箱即连。**

![version](assets/brand/badge-version.svg)
![services](assets/brand/badge-services.svg)
![engine](assets/brand/badge-compose.svg)

**🌐 公网体验站：<https://topbat.github.io/basicstack/> · 仓库：[topbat/basicstack](https://github.com/topbat/basicstack) · 许可：MIT**

</div>

---

## 为什么是 BasicStack

搭一套本地开发基建，通常意味着逐个查镜像版本、背端口、配密码、找管理台。**基石服务栈**把这些一次做完：

- **一键拉起** —— 一条 `docker compose up -d`，25 个服务按依赖顺序自动就绪；
- **端口全规划** —— 所有端口已避让常见占用（23306/26379/15432…），容器间统一用服务名互访；
- **密码全统一** —— 初始密码统一 `admin123`，忘记密码等于没有忘记密码；
- **管理台全配好** —— 12 个 Web 控制台开箱即用，phpMyAdmin/RedisInsight/pgAdmin/Kibana/Attu/DBGate 已自动注册连接；
- **数据全落盘** —— 统一落盘 `${DATA_ROOT}`（默认 `D:\local\basic-service-data`，`.env` 一改全改），备份 = 复制目录；
- **最大化复用** —— Langfuse 复用本栈的 PostgreSQL/Redis/ClickHouse/MinIO，Nacos 元数据复用 MySQL，不为单件服务多起一个容器；
- **脚本工具箱** —— `scripts\*.bat` 覆盖启停/状态/日志/负载/重置，双击即用。

## 25 件基建一览

| 分组 | 组件 |
|---|---|
| 关系数据库 | MySQL 8.4 LTS（23306）· PostgreSQL 18 + pgvector（15432） |
| 缓存 / 队列 | Redis 8.8（26379）· RabbitMQ 4.3（25672/25673） |
| 搜索 / OLAP | Elasticsearch 9.2（9200）· ClickHouse 26.8（8123 / Native 9090） |
| 向量 / 图 | Milvus 2.6（19530）· Neo4j 2026.08（17474/17687） |
| 注册 / 配置 | Nacos 2.5.4（8848，元数据存本栈 MySQL） |
| 对象存储 | MinIO（9000/9001）· RustFS（9020） |
| AI / LLM | Langfuse v4（3000）· MinerU 3.4.5 文档解析（8900） |
| DevOps | Nginx（80）· Jenkins LTS（8180）· GitLab CE 19.3（8181/2222） |
| 管理台 ×6 | phpMyAdmin（8081）· RedisInsight（5540）· pgAdmin（8082）· Kibana（5601）· Attu（8086）· DBGate（8085） |
| 一次性任务 | minio-init（建 langfuse 桶）· es-init（建 kibana_server 账号），完成即退出 |

## 快速开始

### 前置要求

- Windows 10/11 + **Docker Desktop**（WSL2 后端）；本栈所有端口、内存、路径均在 Windows 环境校准
- WSL 虚拟机内存建议 ≥ 12GB（全栈约 8-9GB，见 FAQ §7.5）
- 磁盘空间 ≥ 30GB（含 MinerU 模型缓存约 1.1GB）

### 三步启动

```bash
git clone https://github.com/topbat/basicstack.git && cd basicstack

# ⓪ （可选）复制 .env.example 为 .env，自定义数据目录/网络名；不创建 .env 则使用默认值
copy .env.example .env & rem  # Windows；Linux/macOS 用 cp

# ① 需要跨项目互联时，按 .env 中的 ESG_NETWORK / QDATA_NETWORK 创建外部网络（不需要互联见下方"单机精简"）
docker network create esg-uat_esg     # = ${ESG_NETWORK}
docker network create docker_qdatanet # = ${QDATA_NETWORK}

# ② 首次构建 MinerU 镜像（官方无 Hub 镜像，本地构建）
docker compose build mineru

# ③ 拉起全部 25 件服务
docker compose up -d
```

> **单机精简**：不需要与 esg/qData 项目互联时，删除 `docker-compose.yml` 顶部的 `esg`/`qdata` 网络声明、`x-networks-all` 中的引用及各服务的 `networks:` 外部网络项，即可免建外部网络直接 `up`。
>
> **路径与网络全部变量化**：数据目录、仓库目录、网络名由 `.env` 控制（见 `.env.example`）：`DATA_ROOT`（数据根目录）、`STACK_DIR`（仓库目录，nginx 发布页挂载用）、`NETWORK_NAME`（本栈网络，默认 `basic-net`）、`ESG_NETWORK` / `QDATA_NETWORK`（跨项目网络）。默认值即当前布局，不改 `.env` 也能直接跑；换机部署只需改 `.env`，无需动编排文件。注意 Docker Compose 项目名（`name: basic-service`）与 Docker 卷名（`basic-service_*`）保持原样——改动会重建卷导致 ClickHouse/GitLab 数据丢失。

### 验证

```bash
docker compose ps -a          # 25 个服务，healthy = 健康检查通过；minio-init/es-init Exited(0) 属正常
docker exec -it mysql mysql -uroot -padmin123 -e "SELECT VERSION();"
curl -u elastic:admin123 http://127.0.0.1:9200
```

### 首次访问清单（宿主机统一用 `127.0.0.1`）

| 入口 | 地址 | 账号 |
|---|---|---|
| Nacos 控制台 | <http://127.0.0.1:8848/nacos> | `nacos` / admin123 |
| MinIO 控制台 | <http://127.0.0.1:9001> | `admin` / admin123 |
| Kibana | <http://127.0.0.1:5601> | `elastic` / admin123（首次启动 2-5 分钟） |
| Langfuse | <http://127.0.0.1:3000> | `admin@basic.local` / admin123 |
| Neo4j Browser | <http://127.0.0.1:17474> | `neo4j` / admin123 |
| RabbitMQ 管理 UI | <http://127.0.0.1:25673> | `admin` / admin123 |
| Jenkins | <http://127.0.0.1:8180> | 初始密码见 §5 |
| GitLab | <http://127.0.0.1:8181> | `root` / admin123（首次启动 5-10 分钟） |
| phpMyAdmin / pgAdmin / RedisInsight / Attu / DBGate | :8081 / :8082 / :5540 / :8086 / :8085 | 见 §1.2 |
| MinerU Swagger | <http://127.0.0.1:8900/docs> | 免登录 |

> **服务总览页**：<http://127.0.0.1/overview.html>　·　**发布页**：<http://127.0.0.1/publish.html>（需先运行 `scripts\sync-site.bat` 同步并启动 nginx 后访问）

## 文档导航

| 章节 | 内容 |
|---|---|
| §1 服务清单 | 全部服务的镜像版本、容器名、端口、账号、数据目录 |
| §2 目录结构 | 编排目录与数据落盘目录 |
| §3 网络互通 | `basic-net` 服务名互访 + 跨项目直连 |
| §4 常用命令 | 脚本工具箱与排障命令 |
| §5 各服务连接信息 | 每个组件的连接串、控制台、注意事项 |
| §6 数据备份与恢复 | 各组件备份命令 |
| §7 已知说明与 FAQ | 端口冲突、内存、升级踩坑等 10 条经验 |
| §8 版本与组件关系 | 组件间依赖关系 |
| [docs/BRAND.md](docs/BRAND.md) | 品牌规范：名称、文案、标志、色彩、资产 |

---

## 1. 服务清单

### 1.1 基础组件

| 服务 | 镜像与版本 | 容器名 | 宿主机端口 | 容器端口 | 账号 / 密码 | 数据目录 |
|---|---|---|---|---|---|---|
| MySQL | mysql:8.4（8.4.11 LTS） | `mysql` | **23306** ⚠️ | 3306 | `root` / admin123；业务账号 `nacos` / admin123 | `data\mysql` |
| Redis | redis:8.8-alpine（8.8.2） | `redis` | **26379** ⚠️ | 6379 | 密码 `admin123`（langfuse 使用 1 号库） | `data\redis` |
| PostgreSQL | pgvector/pgvector:pg18（18.6） | `postgres` | **15432** ⚠️ | 5432 | `postgres` / admin123 | `data\postgres\18\docker` |
| Nacos | nacos/nacos-server:v2.5.4 | `nacos` | **8848 / 9848 / 9849** | 同左 | 控制台 `nacos` / admin123 | 日志：`data\nacos\logs`（元数据在 MySQL） |
| MinIO | minio/minio:latest | `minio` | **9000 / 9001** | 9000(S3 API) / 9001(控制台) | `admin` / admin123 | `data\minio` |
| RustFS | rustfs/rustfs:latest | `rustfs` | **9020** | 9000 | AccessKey `admin` / SecretKey admin123 | `data\rustfs` |
| Elasticsearch | elasticsearch:9.2.3 | `es` | **9200 / 9300** | 同左 | `elastic` / admin123 | `data\es\data`、`data\es\logs` |
| ClickHouse | clickhouse-server:26.8（26.8.4） | `clickhouse` | **8123 / 9090** ⚠️ | 8123(HTTP) / 9000(Native) | `admin` / admin123 | Docker 卷（§7.1） |
| Milvus | milvusdb/milvus:v2.6.23 | `milvus` | **19530 / 9091** | 19530(gRPC) / 9091(HTTP) | 默认未开启认证 | `data\milvus` |
| **Neo4j** | neo4j:2026.08.1-community | `neo4j` | **17474 / 17687** ⚠️ | 7474(Browser) / 7687(Bolt) | `neo4j` / admin123 | `data\neo4j\data`、`data\neo4j\logs` |
| Langfuse Web | langfuse/langfuse:4 | `langfuse-web` | **3000** | 3000 | `admin@basic.local` / admin123 | 无本地目录 |
| Langfuse Worker | langfuse/langfuse-worker:4 | `langfuse-worker` | 不对外 | 3030 | — | 同上 |
| **Nginx** | nginx:stable-alpine（1.31.x stable） | `nginx` | **80** | 80 | 无 | `data\nginx\html`、`data\nginx\logs`；配置 `nginx\conf.d`（相对仓库根） |
| **Jenkins** | jenkins/jenkins:lts | `jenkins` | **8180** ⚠️ / 50000 | 8080 / 50000(Agent) | 首次用初始密码解锁（见 §5），之后自建管理员 | `data\jenkins` |
| **GitLab CE** | gitlab/gitlab-ce:19.3.2-ce.0 | `gitlab` | **8181 / 2222** | 8181 / 22(SSH) | `root` / admin123 | Docker 卷（§7.1，Windows 挂载不兼容） |
| **RabbitMQ** | rabbitmq:4.3-management（4.3.5） | `rabbitmq` | **25672 / 25673** ⚠️ | 5672(AMQP) / 15672(UI) | `admin` / admin123 | `data\rabbitmq` |
| **MinerU** | mineru-local:3.4.5（本地构建，见 §7.8） | `mineru` | **8900** | 8000 | 无（本地 API） | 模型缓存：`data\mineru\models` |
| MinIO 初始化 | minio/mc:latest | `minio-init` | 一次性任务 | — | — | 创建 `langfuse` 桶后自动退出 |
| ES 初始化 | curlimages/curl:latest | `es-init` | 一次性任务 | — | — | 为 Kibana 创建服务账号后自动退出 |

> ⚠️ **端口说明（与常规默认值不同之处）**
> - **MySQL 23306、Redis 26379、RabbitMQ 25672/25673、Neo4j 17474/17687**：宿主机上的标准端口（3306/6379/5672/15672/7474/7687）已被另一项目（docker-mysql、docker-redis、docker-rabbitmq、docker-neo4j 等容器）长期占用，本项目对应服务改用上述端口；容器内部端口不变，容器间互访不受影响。
> - PostgreSQL 宿主机端口为 **15432**：宿主机 5432 已被本机原生 PostgreSQL 服务占用。
> - ClickHouse Native 端口宿主机侧为 **9090**：宿主机 9000 已被 MinIO 占用（`9090->9000`）。
> - RustFS **9020**、Jenkins **8180**（宿主机 8080 被其他项目占用）、GitLab Web **8181**、MinerU **8900**：避开常用/已占端口。
> - Nacos 9848/9849 为 gRPC 端口（规则=8848+1000/1001），**客户端 SDK 必须能访问**。
> - 宿主机 `::1`(IPv6 localhost) 上有其他进程占用部分端口，浏览器/命令行访问请使用 `127.0.0.1`。

### 1.2 管理端工具（6 个）

| 工具 | 对应组件 | 镜像 | 容器名 | 访问地址 | 登录账号 |
|---|---|---|---|---|---|
| phpMyAdmin | MySQL | phpmyadmin:latest | `phpmyadmin` | <http://127.0.0.1:8081> | 数据库账号登录（root / admin123） |
| RedisInsight | Redis（官方） | redis/redisinsight:latest | `redisinsight` | <http://127.0.0.1:5540> | 免登录，已自动注册 redis |
| pgAdmin 4 | PostgreSQL | dpage/pgadmin4:latest | `pgadmin` | <http://127.0.0.1:8082> | `admin@basic-service.com` / admin123 |
| Kibana（中文） | Elasticsearch（官方） | kibana:9.2.3 | `kibana` | <http://127.0.0.1:5601> | `elastic` / admin123（首次启动 2-5 分钟） |
| Attu | Milvus（官方） | zilliz/attu:v3.0 | `attu` | <http://127.0.0.1:8086> | 免登录（ATTU_AUTH_MODE=none） |
| DBGate | ClickHouse 等 | dbgate/dbgate:7.2.6-alpine | `dbgate` | <http://127.0.0.1:8085> | `admin` / admin123 |

> Nacos / MinIO / Neo4j / RabbitMQ / GitLab / Jenkins 管理端为组件自带（地址见快速开始与 §5）；RustFS 用 mc/aws-cli 管理；ClickHouse 内置 Play UI：<http://127.0.0.1:8123/play>。

## 2. 目录结构

```
${STACK_DIR}                           # 编排与管理目录（默认 D:\local\basic-service，.env 可改）
├── docker-compose.yml                 # 全部服务的编排定义（含中文注释，共 25 个服务）
├── README.md                          # 本文档
├── CHANGELOG.md                       # 版本变更日志（Keep a Changelog 格式）
├── site-manifest.json                 # 发布清单（scripts\gen-manifest.ps1 生成，发布页消费）
├── site\                              # Web 页面：overview.html 总览页 / publish.html 发布页
├── docs\BRAND.md                      # 品牌规范（名称/文案/标志/资产）
├── assets\brand\                      # 品牌资产（原创 SVG/PNG）
├── .github\workflows\                 # CI/CD：release.yml（打 tag 自动 Release+zip 包）/ pages.yml（Pages 部署）
├── mysql\init\01-nacos-init.sql       # MySQL 首次初始化：nacos 库/账号 + 官方表结构 + config_info_gray + 控制台账号
├── postgres\init\01-init.sql          # PostgreSQL 首次初始化：创建 langfuse 库
├── milvus\embedEtcd.yaml              # Milvus 内置 etcd 配置
├── clickhouse\config.d\zz-memory-limit.xml   # ClickHouse 内存限制(1.5GB)
├── pgadmin\servers.json               # pgAdmin 自动注册 postgres 连接
├── nginx\conf.d\default.conf          # Nginx 站点配置（含反向代理示例与 /repo/ 只读发布路由）
├── mineru\Dockerfile                  # MinerU 本地构建文件（官方无 Hub 镜像）
└── scripts\                           # 管理脚本（双击或命令行运行）
    ├── start.bat      # 启动（默认全部，可带服务名）
    ├── stop.bat       # 停止（数据保留）
    ├── restart.bat    # 重启
    ├── status.bat     # 查看状态/健康检查
    ├── logs.bat       # 跟踪日志：logs.bat 服务名
    ├── stats.bat      # 查看 CPU/内存负载
    ├── down.bat       # 停止并删除容器（数据保留）
    ├── reset.bat      # 【危险】重置单个服务（删容器+删数据）
    ├── sync-site.bat      # 同步总览页/发布页到本地站点并生成发布清单
    ├── overview-status.bat # 生成实时容器状态 JSON（总览页消费）
    └── gen-manifest.ps1    # 发布清单生成器（sync-site.bat 自动调用）

${DATA_ROOT}                           # 全部数据/日志落盘目录（默认 D:\local\basic-service-data，.env 可改）
├── mysql\  redis\  minio\  rustfs\  jenkins\  rabbitmq\
├── postgres\18\docker\                # PG18 数据（注意在子目录）
├── es\{data,logs}\  milvus\  neo4j\{data,logs}\  nacos\logs\
├── nginx\{html,logs}\                 # Nginx 静态站点与日志
├── mineru\models\                     # MinerU 模型缓存（首次解析自动下载约1.1GB）
└── gitlab\  clickhouse\               # 【不使用】二者数据在 Docker 卷中，见 §7.1
```

## 3. 网络互通

所有服务接入自定义网络 `basic-net`（网络名由 `.env` 的 `NETWORK_NAME` 控制，默认 `basic-net`），容器间使用**服务名**作为主机名：

| 容器内访问地址 | 用途 |
|---|---|
| `mysql:3306`（nacos/admin123） | 关系数据库、nacos 元数据 |
| `redis:6379`（密码 admin123） | 缓存/队列 |
| `postgres:5432`（postgres/admin123） | 关系数据库、langfuse |
| `nacos:8848` / `nacos:9848` | 注册/配置中心 |
| `minio:9000`（admin/admin123） | S3 对象存储（langfuse 使用） |
| `rustfs:9000`（admin/admin123） | S3 兼容存储 |
| `es:9200`（elastic/admin123） | 搜索引擎（kibana 用 kibana_server 账号） |
| `clickhouse:8123`(HTTP) / `clickhouse:9000`(Native) | OLAP（langfuse/dbgate 使用） |
| `milvus:19530` | 向量数据库 |
| `neo4j:7687`（neo4j/admin123） | 图数据库 |
| `langfuse-web:3000` | LLM 可观测 |
| `nginx:80` / `jenkins:8080` / `gitlab:8181` / `rabbitmq:5672` / `mineru:8000` | Web 入口 / CI / 代码仓 / 消息队列 / 文档解析 |

> ⚠️ 业务容器必须也加入 `basic-net` 网络才能通过服务名互访：
> `docker network connect basic-net <业务容器名>`，或业务自身 compose 中声明 `networks: [basic-net]`（外部网络需加 `external: true`）。

### 3.1 中间件跨项目直连（2026-10 新增）

11 个中间件（mysql / redis / postgres / nacos / minio / rustfs / es / clickhouse / milvus / neo4j / rabbitmq）
在 `basic-net` 之外，还接入了外部项目网络（网络名由 `.env` 的 `ESG_NETWORK` / `QDATA_NETWORK` 控制），其他项目容器**无需改任何配置**即可用容器名直连：

| 外部网络（compose 键） | 实际网络名 | 接入的中间件 |
|---|---|---|
| `esg` | `esg-uat_esg`（ESG 项目） | 全部 11 个 |
| `qdata` | `docker_qdatanet`（qData 项目） | 除 mysql / redis / rabbitmq / neo4j 外的 7 个 |

- mysql / redis / rabbitmq / neo4j **不接入 `docker_qdatanet`**：qData 项目在该网络自带这四个同名服务别名，接入会导致 DNS 轮询错乱、干扰对方项目；qData 容器需要时仍可通过 `host.docker.internal:23306/26379/25672/17474` 等宿主机端口访问。
- `external` 网络必须存在：若对方项目 `docker compose down` 删掉了网络，本编排 `up` 前需先 `docker network create <网络名>` 重建。
- 新增接入其他项目网络时：在 docker-compose.yml 的 `networks:` 与 `x-networks-all` 中声明，再 `docker compose up -d <服务>` 重建生效。

## 4. 常用命令

### 4.1 脚本方式（scripts 目录，双击即可）

> 脚本说明：
> - 脚本为 **ANSI/GBK 编码 + CRLF 换行**（中文 cmd 的原生格式），请勿用编辑器转存为 UTF-8，否则中文会变乱码且命令解析出错；
> - 脚本结尾不带 `pause`，在 PowerShell/CMD 终端运行不会阻塞，执行完直接返回。

| 操作 | 脚本 | 等价命令 |
|---|---|---|
| 启动全部 | `scripts\start.bat` | `docker compose up -d` |
| 启动单个 | `scripts\start.bat mysql redis` | `docker compose up -d mysql redis` |
| 停止（保数据） | `scripts\stop.bat` / `stop.bat mysql` | `docker compose stop [服务名]` |
| 重启 | `scripts\restart.bat` / `restart.bat nacos` | `docker compose restart [服务名]` |
| 查看状态 | `scripts\status.bat` | `docker compose ps -a` |
| 查看日志 | `scripts\logs.bat mysql` | `docker compose logs -f --tail=200 mysql` |
| 查看 CPU/内存负载 | `scripts\stats.bat` | `docker stats` |
| 停止并删容器（保数据） | `scripts\down.bat` | `docker compose down` |
| 重置单服务（删数据） | `scripts\reset.bat mysql`（需输入 YES） | `docker compose rm -sf mysql` + 删数据目录 |

### 4.2 查进程 / 负载 / 排障

```bash
docker compose ps -a                     # 各容器运行状态（healthy=健康检查通过）
docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"   # 宿主机容器进程清单
docker top mysql                         # 查看某容器内进程
docker stats                             # 实时 CPU/内存/IO 负载（Ctrl+C 退出）
docker stats --no-stream                 # 负载快照（刷一次即退）
docker logs --tail=100 nacos             # 查看最近 100 行日志
docker logs -f langfuse-web              # 持续跟踪日志
docker inspect gitlab --format "{{.State.Health.Status}}"        # 查询健康检查结果
docker exec -it mysql bash               # 进入容器
```

### 4.3 启动顺序说明

`docker compose up -d` 自动按依赖顺序启动：
mysql/redis/postgres/minio/es/clickhouse/neo4j/milvus/nginx/jenkins/gitlab/rabbitmq →（mysql 健康）nacos →（minio 健康）minio-init →（es 健康）es-init →（es-init 完成）kibana →（pg/ch/redis/minio 健康）langfuse-web/langfuse-worker → 管理端工具（phpmyadmin/redisinsight/pgadmin/attu/dbgate）→ mineru（首次需 `docker compose build mineru`，镜像已构建则直接启动）。

## 5. 各服务连接信息

### MySQL（8.4 LTS）
```bash
mysql -h 127.0.0.1 -P 23306 -uroot -padmin123              # 宿主机
docker exec -it mysql mysql -uroot -padmin123              # 容器内
```
- 内置库：`nacos`（13 张表，含 2.5 必需的 config_info_gray）；管理端 phpMyAdmin :8081

### Redis（8.8）
```bash
docker exec -it redis redis-cli -a admin123
# 宿主机（注意端口 26379）：redis-cli -h 127.0.0.1 -p 26379 -a admin123
```
- AOF 持久化；langfuse 使用 db1；管理端 RedisInsight :5540

### PostgreSQL（18 + pgvector）
```bash
docker exec -it postgres psql -U postgres -d langfuse
# 宿主机（注意端口 15432）：psql -h 127.0.0.1 -p 15432 -U postgres
```
- 内置库：`langfuse`；管理端 pgAdmin :8082（admin@basic-service.com / admin123）

### Nacos（2.5.4，元数据存 MySQL）
- 控制台：<http://127.0.0.1:8848/nacos> —— `nacos` / `admin123`
- Spring Boot 客户端：`server-addr: 127.0.0.1:8848`，账号密码同上（容器网络内 `nacos:8848`）

### MinIO / RustFS
- MinIO 控制台：<http://127.0.0.1:9001>（admin/admin123）；S3 API：`http://127.0.0.1:9000`（容器内 `http://minio:9000`）
- RustFS S3 API：<http://127.0.0.1:9020>（AK `admin` / SK `admin123`），管理用 mc/aws-cli

### Elasticsearch（9.2）
```bash
curl -u elastic:admin123 http://127.0.0.1:9200
```
- 管理端 Kibana：<http://127.0.0.1:5601>（elastic/admin123，中文界面；服务账号 kibana_server 由 es-init 自动创建）

### ClickHouse（26.8）
```bash
curl "http://127.0.0.1:8123/?query=SELECT%20version()" --user admin:admin123
docker exec -it clickhouse clickhouse-client --user admin --password admin123
```
- Native 端口（宿主机）= 9090；管理端 DBGate :8085；Play UI :8123/play

### Milvus（2.6） / Neo4j（2026.08）
- Milvus：`127.0.0.1:19530`（容器内 `milvus:19530`），无认证；健康检查 :9091/healthz；管理端 Attu :8086
- Neo4j Browser：<http://127.0.0.1:17474>（neo4j/admin123）；Bolt `bolt://127.0.0.1:17687`

### Langfuse（v4）
- 控制台：<http://127.0.0.1:3000> —— `admin@basic.local` / `admin123`
- API Key：Public `pk-lf-a4319cc54b96853d83883323d3c0863084a10c9c` / Secret `sk-lf-97bb0faaaa7e8a935c8569a25a91410d29247640`

### Nginx（stable）
- 入口：<http://127.0.0.1:80>（默认欢迎页，站点根目录 `data\nginx\html`）
- 配置：`nginx\conf.d\default.conf`（相对仓库根，含 GitLab/Jenkins/Nacos 等反向代理示例），修改后 `docker exec nginx nginx -s reload`
- 健康检查：<http://127.0.0.1/healthz>

### Jenkins（LTS）
- 入口：<http://127.0.0.1:8180>（宿主机 8080 被其他项目占用，故映射 8180）
- **首次初始化**：用初始密码解锁（当前实例为 `674ab8a315c54c8f8cfd9e1f13e413e5`），随后创建自己的管理员账号
- 查询初始密码：`docker exec jenkins cat /var/jenkins_home/secrets/initialAdminPassword`（仅首次未创建管理员前存在）
- Agent 接入端口：50000；数据目录 `data\jenkins`（任务/插件全在内）
- 插件安装走国内更新源：进入容器编辑 `/var/jenkins_home/hudson.model.UpdateCenter.xml` 将地址换为清华镜像 `https://mirrors.tuna.tsinghua.edu.cn/jenkins/updates/update-center.json` 后重启

### GitLab CE（19.3.2）
- 入口：<http://127.0.0.1:8181> —— 账号 `root` / `admin123`
- SSH 克隆：`git clone ssh://git@127.0.0.1:2222/group/repo.git`
- 首次启动/大版本升级需 reconfigure（约 5-10 分钟，期间 502 属正常）
- 密码说明：GitLab 弱密码策略会拒绝 `admin123` 表单设置，本栈已直接注入密码哈希绕过；若重置数据后需重设，执行：
```bash
docker exec gitlab gitlab-rails runner "u=User.find_by(username:'root'); u.update_columns(encrypted_password: Devise::Encryptor.digest(User, 'admin123'), password_automatically_set: false); puts u.reload.valid_password?('admin123')"
```
- 内存已调优（puma 单进程、sidekiq 并发 8、关闭 prometheus/kas/registry）；数据在 Docker 卷（Windows 挂载不兼容，见 §7.1）；备份：
```bash
docker exec gitlab gitlab-backup create                          # 备份到卷内 /var/opt/gitlab/backups
docker exec gitlab gitlab-backup restore BACKUP=<时间戳>          # 恢复（需先停 puma/sidekiq）
```

### RabbitMQ（4.3）
- 管理 UI：<http://127.0.0.1:25673> —— `admin` / `admin123`
- AMQP 连接：`amqp://admin:admin123@127.0.0.1:25672/`（容器网络内 `amqp://admin:admin123@rabbitmq:5672/`）
```python
import pika
conn = pika.BlockingConnection(pika.URLParameters('amqp://admin:admin123@127.0.0.1:25672/'))
```

### MinerU（3.4.5，PDF/文档解析，CPU 版）
- API：<http://127.0.0.1:8900> —— Swagger 文档 `/docs`，健康检查 `/health`，解析接口 `POST /file_parse`
```bash
# 同步解析（大文件建议走 /tasks 异步接口）
curl -X POST http://127.0.0.1:8900/file_parse -F "files=@demo.pdf" -F "backend=pipeline" -F "output_format=markdown"
```
- 镜像为本地构建（官方无 Hub 镜像）：`docker compose build mineru`；版本升级改 `mineru\Dockerfile` 中版本号后重建
- 模型走 ModelScope 国内源，缓存在 `data\mineru\models`（已下载 1.1GB，首次解析慢属正常：含模型加载与 CPU 推理）

## 6. 数据备份与恢复

```bash
# MySQL / PostgreSQL
docker exec mysql mysqldump -uroot -padmin123 --all-databases > %DATA_ROOT%\backup-mysql.sql
docker exec postgres pg_dumpall -U postgres > %DATA_ROOT%\backup-pg.sql
# ClickHouse（Docker 卷）
docker run --rm -v basic-service_clickhouse_data:/data -v %DATA_ROOT%:/backup alpine tar czf /backup/backup-clickhouse.tar.gz -C /data .
# GitLab（Docker 卷）
docker exec gitlab gitlab-backup create
# 文件型服务（redis/minio/rustfs/es/milvus/neo4j/jenkins/rabbitmq/nginx/mineru）：
# 先 docker compose stop 对应服务，再复制 %DATA_ROOT% 下对应子目录
# （命令中的 %DATA_ROOT% 即 .env 的 DATA_ROOT 数据根目录，cmd 下可先 set DATA_ROOT=D:\local\basic-service-data 再执行）
```

## 7. 已知说明与 FAQ

1. **ClickHouse / GitLab 数据为何不在 `basic-service-data` 目录？**
   两者都无法在 Windows 目录挂载（drvfs）上正常工作（实测：ClickHouse rename 报 Permission denied；GitLab reconfigure 海量文件属主操作超时导致反复退出）。数据分别存于 Docker 卷 `basic-service_clickhouse_data/logs`、`basic-service_gitlab_config/data/logs`，备份方式见 §5/§6。

2. **镜像拉取失败/卡住？**
   Docker Desktop 已配置**手动代理模式**指向 `http://127.0.0.1:7897`（settings-store.json `ProxyHTTPMode: "manual"`；`system` 模式会忽略手动代理字段）。曾踩坑：配置指向失效的 7890 端口导致拉取卡死；`wsl --shutdown` 后代理子系统偶发失灵，重启 Docker Desktop 恢复。`~/.docker/daemon.json` 的 registry-mirrors 已移除（镜像源直连依赖虚机 DNS，部分环境不可靠）。

3. **重置服务**
   `scripts\reset.bat 服务名`（删容器+数据后重新初始化）。GitLab/ClickHouse 额外删卷：`docker volume rm basic-service_gitlab_config basic-service_gitlab_data basic-service_gitlab_logs`；MinerU 重置镜像：`docker compose build --no-cache mineru`。

4. **端口冲突自检**
   `netstat -ano | findstr :端口号`。已占用：5432（本机原生 PG）、8080（ppt-generate-v2 项目 web）、3306/6379/5672/15672/7474/7687（另一项目 docker-mysql/docker-redis/docker-rabbitmq/docker-neo4j 等容器，本项目已改用 §1.1 ⚠️ 中的替代端口）、`::1` 部分端口。本机同时运行其他 Docker 项目时注意端口规划；若另一项目停用后想改回标准端口，编辑 compose 端口映射并 `docker compose up -d` 重建对应服务即可。

5. **资源占用**
   全栈约 8-9GB 内存（GitLab ~2GB、MinerU 模型加载后 ~1.6GB、ES ~1.1GB、Kibana ~0.7GB）。WSL 虚拟机已扩至 **12GB**（`C:\Users\HQ\.wslconfig`，`memory=12GB`、`swap=8GB`），修改后需 `wsl --shutdown` 并重启 Docker Desktop。若同时运行其他大型 Docker 项目，建议按需 `stop.bat` 停用部分服务（如 gitlab、mineru）。

6. **nacos 鉴权**：控制台与 SDK 均需 nacos/admin123；JWT/identity 配置见 compose `NACOS_AUTH_*`。nacos 2.5.x 运行时需要 `config_info_gray` 表（初始化脚本已内置）。

7. **首次初始化只发生一次**：MySQL（nacos 库/表/账号）、PostgreSQL（langfuse 库）初始化脚本仅在数据目录为空时执行；GitLab 的 root 密码仅首次初始化生效（compose 已写 `initial_root_password='admin123'`）。

8. **MinerU 镜像为本地构建**：官方不发布 Hub 镜像，`mineru\Dockerfile` 基于 python:3.11-slim + pip（清华源）构建，FROM 使用国内镜像源引用（BuildKit 不走代理，直接引用 docker.io 会失败）。升级版本：改 Dockerfile 中 `mineru[core]==3.4.5` 版本号 → `docker compose build mineru` → `docker compose up -d mineru`。

9. **为什么建议用 127.0.0.1 而不是 localhost**：本机 `::1`（IPv6 localhost）被其他进程绑定占用了部分端口（如 8181），`localhost` 解析优先走 IPv6 会导致偶发无法访问；`127.0.0.1` 始终指向 Docker 端口转发。

10. **大版本升级踩坑记录**（已固化到编排）：
    - PostgreSQL 16→18：挂载点改为父目录 `/var/lib/postgresql`；
    - Milvus 2.4→2.6：必须 `DEPLOY_MODE=STANDALONE`，跨版本清空 `data\milvus`；
    - Kibana 9：需 kibana_system 角色专用账号（es-init 自动创建），禁用 elastic 超级用户；
    - pgAdmin 新版：登录邮箱不接受 `.local` 等保留域名；
    - Attu v3：默认带登录页，已设 `ATTU_AUTH_MODE=none`；
    - GitLab 19：`GITLAB_ROOT_PASSWORD` 环境变量不可靠，root 用户为首次访问网页时懒创建且弱密码策略拒绝 admin123 表单设置，最终通过 rails 注入密码哈希（命令见 §5 GitLab 小节）。

## 8. 版本与组件关系

- nacos → mysql（元数据，库 `nacos`）
- langfuse-web / worker → postgres(langfuse) + clickhouse + redis(db1) + minio(langfuse 桶)
- kibana → es（服务账号 kibana_server，es-init 一次性创建）
- minio-init → minio（一次性初始化 langfuse 桶，Exited(0) 正常）
- milvus → 内置 etcd + 本地存储（独立运行）
- 管理端：phpmyadmin→mysql、redisinsight→redis、pgadmin→postgres、kibana→es、attu→milvus、dbgate→clickhouse（无状态）
- 独立服务：nginx（Web 入口/反代）、jenkins（CI）、gitlab（代码仓）、rabbitmq（消息队列）、mineru（文档解析）

---

## 品牌与文档

- 品牌规范（名称 / 核心文案 / 标志 / 色彩 / 字体 / 使用规则）：[docs/BRAND.md](docs/BRAND.md)
- 品牌资产（原创 SVG 源文件 + PNG 导出物）：`assets/brand/`
- 当前版本 **v1.0.0**（2026-11-10）；发布标签格式 `vX.Y.Z`

> 本项目品牌资产均为原创设计；文中出现的第三方组件名仅用于指代对应软件，各自归其所有者所有。详见 [docs/BRAND.md §9](docs/BRAND.md)。

## Roadmap（路线图）

> 小版本迭代、按期聚合发布；以下为计划项，不构成交付承诺，实际交付以 [CHANGELOG.md](CHANGELOG.md) 为准。

- [ ] **v1.1** 一键备份脚本：全栈数据目录（`basic-service-data` + Docker 卷）打包归档，支持按服务恢复
- [ ] **v1.2** 监控栈：Prometheus + Grafana + 告警，覆盖容器与核心组件指标看板
- [ ] **v1.3** Kafka / RabbitMQ 集群与 HA：高可用消息队列拓扑与接管方案
- [ ] **v1.4** Arm64 / WSL2 一键安装器：跨架构镜像选择、环境自检与引导式初始化
- [ ] **v1.5** HTTPS / 域名接入向导：Nginx 反代 + 证书签发与自动续期
- [ ] **持续** 随每个版本更新 README 与服务总览页数据
