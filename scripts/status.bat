@echo off
rem =====================================
rem  查看服务状态（容器是否运行、端口映射、健康检查结果）
rem  用法：status.bat
rem =====================================
cd /d %~dp0..
echo [状态] 容器运行状态（STATUS 含 Up/healthy 为正常）：
echo.
docker compose ps -a
echo.
echo [状态] 宿主机容器清单：
docker ps --format "table {{.Names}}\t{{.Image}}\t{{.Status}}\t{{.Ports}}"
