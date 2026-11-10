@echo off
rem =====================================
rem  停止基础组件服务（默认停止全部；数据保留，重启后数据仍在）
rem  用法：stop.bat [服务名...]   例：stop.bat gitlab mineru
rem =====================================
cd /d %~dp0..
echo [停止] 正在停止服务（数据保留）...
docker compose stop %*
if errorlevel 1 (
    echo [失败] 停止出错，请检查上方错误信息。
    exit /b 1
)
echo [完成] 数据已保留，可用 start.bat 重新启动。
