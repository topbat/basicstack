@echo off
rem =====================================
rem  重启基础组件服务（默认全部；也可指定单个服务）
rem  用法：restart.bat [服务名...]   例：restart.bat nacos
rem =====================================
cd /d %~dp0..
echo [重启] 正在重启服务...
docker compose restart %*
if errorlevel 1 (
    echo [失败] 重启出错，请检查上方错误信息。
    exit /b 1
)
echo [完成] 可执行 status.bat 查看服务状态。
