@echo off
rem =====================================
rem  查看容器资源占用（CPU/内存/网络 IO，实时刷新，Ctrl+C 退出）
rem  用法：stats.bat   （查看单个：docker stats mysql）
rem =====================================
echo [负载] 容器 CPU/内存/IO 实时占用（Ctrl+C 退出）：
docker stats
