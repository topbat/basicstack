@echo off
rem =====================================
rem  启动基础组件服务（默认全部；也可指定单个服务）
rem  用法：start.bat [服务名...]   例：start.bat mysql redis
rem =====================================
cd /d %~dp0..
echo [启动] 正在启动基础组件服务（首次启动需等待初始化）...
docker compose up -d %*
if errorlevel 1 (
    echo [失败] 启动出错，请检查上方错误信息。
    exit /b 1
)
echo [完成] 可执行 status.bat 查看状态，logs.bat 服务名 跟踪日志。
