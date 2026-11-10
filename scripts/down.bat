@echo off
rem =====================================
rem  停止并删除全部容器（仅删容器/网络，不删除数据；数据仍在 D:\local\basic-service-data）
rem  用法：down.bat   重新创建容器：start.bat
rem =====================================
cd /d %~dp0..
echo [清理] 停止并移除容器与网络（数据目录不受影响）...
docker compose down
if errorlevel 1 (
    echo [失败] 执行出错，请检查上方错误信息。
    exit /b 1
)
echo [完成] 可随时用 start.bat 重新创建，数据不丢失。
