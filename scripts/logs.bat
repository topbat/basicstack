@echo off
rem =====================================
rem  跟踪服务日志（Ctrl+C 退出跟踪）
rem  用法：logs.bat 服务名   例：logs.bat mysql / logs.bat nacos / logs.bat langfuse-web
rem =====================================
cd /d %~dp0..
if "%~1"=="" (
    echo 用法：logs.bat 服务名。可选服务名：
    docker compose config --services
    exit /b 1
)
echo [日志] 正在跟踪 %* 最近 200 行日志（Ctrl+C 退出）...
docker compose logs -f --tail=200 %*
