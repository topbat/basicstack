@echo off
setlocal enabledelayedexpansion
rem =====================================
rem  危险操作！重置指定服务：停止并删除容器 + 删除其数据目录（恢复到首次安装状态）
rem  用法：reset.bat 服务名   支持：mysql redis postgres nacos minio rustfs es milvus neo4j jenkins rabbitmq nginx
rem  例：reset.bat mysql
rem  注：clickhouse/gitlab/mineru 的数据在 Docker 卷或模型卷中，重置方法见 README 第 7 节
rem =====================================
cd /d %~dp0..
if "%~1"=="" (
    echo 用法：reset.bat 服务名（mysql/redis/postgres/nacos/minio/rustfs/es/milvus/neo4j/jenkins/rabbitmq/nginx）
    exit /b 1
)
set SVC=%~1
echo 警告：将删除服务 [%SVC%] 的容器与全部数据（D:\local\basic-service-data\%SVC%）！
set /p CONF=确认请输入大写 YES：
if not "%CONF%"=="YES" (
    echo 已取消。
    exit /b 1
)
docker compose rm -sf %SVC%
if exist "D:\local\basic-service-data\%SVC%" rd /s /q "D:\local\basic-service-data\%SVC%"
echo [完成] %SVC% 已重置，执行 start.bat %SVC% 将按首次安装重新初始化。
