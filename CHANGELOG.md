# 更新日志 Changelog

基石服务栈 BasicStack 的全部显著变更将记录在本文件。

格式遵循 [Keep a Changelog](https://keepachangelog.com/zh-CN/1.1.0/) 惯例，版本号采用语义化版本（`v主版本.次版本.修订号`），与 README 徽章及发布标签保持一致 —— 当前版本线：**v1.0.0**。

## [1.0.0] - 2026-11-10

首个正式版本：一条 `docker compose up -d` 拉起 25 件自托管开发基建（MySQL/Redis/PG/ES/ClickHouse/Milvus/Neo4j/RabbitMQ/MinIO/Nacos/Langfuse/MinerU 等），端口/密码/管理台全配好，开箱即连。

### Added

- **25 服务编排**：`docker-compose.yml` 统一编排 25 个服务（17 个组件 + 6 个管理台工具 + 2 个一次性初始化任务），统一网络 `basic-net` 按服务名互访并接入跨项目网络、统一初始密码 `admin123`、数据/日志统一落盘 `basic-service-data`，配套 `scripts\*.bat` 管理脚本工具箱（启停/状态/日志/负载/重置）
- **服务总览页**：本机 <http://127.0.0.1/overview.html>，全部服务端口/账号/管理台入口一页速查（`scripts\sync-site.bat` 同步发布）
- **发布页**：本机 <http://127.0.0.1/publish.html>，版本发布信息一页速览（`scripts\sync-site.bat` 同步发布）
- **CI/CD**：本地持续集成/交付基建 —— Jenkins（LTS，含 Agent 端口 50000 与国内插件源）+ GitLab CE（Web 8181 / SSH 2222）
- **品牌资产**：原创标志系统（徽章/透明/单色/横版）、README 头图、GitHub 社交预览图、自托管徽章（`assets/brand/`），以及品牌规范 `docs/BRAND.md`（名称/文案/色彩/字体/使用规则）

### Changed

- README 重写为品牌化文档：采用「基石服务栈 BasicStack」规范名称与核心文案、品牌头图与自托管徽章，新增「为什么是 BasicStack」「25 件基建一览」「快速开始」「首次访问清单」「文档导航」，完整保留运维手册八章（服务清单/目录结构/网络互通/常用命令/连接信息/备份恢复/FAQ/组件关系）

## [Unreleased]

### 计划中

- **v1.1** 一键备份脚本：全栈数据目录打包归档（含 Docker 卷）
- **v1.2** 监控栈：Prometheus + Grafana + 告警
- **v1.3** Kafka / RabbitMQ 集群与 HA
- **v1.4** Arm64 / WSL2 一键安装器
- **v1.5** HTTPS / 域名接入向导
