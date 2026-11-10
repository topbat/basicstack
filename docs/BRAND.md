# 基石服务栈 BasicStack · 品牌规范（Brand Guide）

> 版本：v1.0.0　|　生效日期：2026-11-10　|　适用范围：本仓库全部文档、代码注释、发布物与社区物料
>
> 本规范为唯一品牌依据。**名称与核心文案必须逐字使用，不得自创变体**；视觉资产均为本项目原创矢量图形（`assets/brand/`），可自由修改尺寸，不得引入第三方版权图形。

---

## 1. 品牌名称

| 项目 | 规定 | 说明 |
|---|---|---|
| 中文名 | **基石服务栈** | 全角书写，用于中文文档标题与正式场合 |
| 英文名 / 显示名 | **BasicStack** | 驼峰拼写（B、S 大写），一个单词，不含空格、连字符或点号 |
| 默认仓库名 | **basicstack** | 全小写，GitHub / Gitee 等平台仓库名 |
| 项目代称（行文内） | 「本栈」 | 非正式行文可用，首次出现仍需用全称 |

书写规则：

- 中英混排时首次出现写全：「基石服务栈 BasicStack」，之后可单独使用任一名称。
- BasicStack 不得拆写为 Basic Stack、basicstack、Basic-stack；中文不得写作「基石栈」「基础服务栈」。
- 涉及 Docker Compose 项目名（compose `name:` 字段、Docker 卷名 `basic-service_*`）时保持 `basic-service` 原样，不替换为品牌名；数据目录默认值 `basic-service-data` 属于 `.env` 中 `DATA_ROOT` 的默认值，同样保持原样。

## 2. 核心文案（逐字使用）

### 2.1 一句话介绍（README tagline）

> 基石服务栈 BasicStack —— 一条 `docker compose up -d` 拉起 25 件自托管开发基建（MySQL/Redis/PG/ES/ClickHouse/Milvus/Neo4j/RabbitMQ/MinIO/Nacos/Langfuse/MinerU 等），端口/密码/管理台全配好，开箱即连。

（161 字符，含 Markdown 反引号。用于 README 首屏、宣传物料首句。）

### 2.2 GitHub 仓库描述（≤350 字符，纯文本，无 Markdown）

```text
基石服务栈 BasicStack —— 一条 docker compose up -d 拉起 25 件自托管开发基建（MySQL/Redis/PG/ES/ClickHouse/Milvus/Neo4j/RabbitMQ/MinIO/Nacos/Langfuse/MinerU 等），端口/密码/管理台全配好，开箱即连。
```

（实测 159 字符 ≤ 350。与 2.1 相同文案去掉反引号，粘贴到仓库 About / Description 即可。）

### 2.3 英文一句话（海外渠道备用）

> BasicStack — one `docker compose up -d` brings up 25 self-hosted dev infrastructure services. Ports, passwords and admin consoles are all pre-wired — ready out of the box.

### 2.4 短口号

- 中文：**一键拉起，开箱即连。**
- 英文：**One command. Ready to connect.**

### 2.5 文案语调

- 工程化、直接、可验证：说「25 件」「端口全配好」，就说得出清单和端口表；不使用「革命性」「颠覆」等虚词。
- 面向开发者第二人称 sparingly：多用动词开头的祈使句（`git clone`、`docker compose up -d`）。
- 中文为主，代码、镜像名、命令保持英文原样，不加翻译。

## 3. 标志（Logo）

### 3.1 设计语义

标志由**三层递进砌块 + 顶部楔块**构成：

- 三层砌块自下而上收窄 —— 「栈」（Stack）：一层层叠起的服务栈，也像 `docker compose` 的服务分层；
- 顶部**梯形楔块（窑金色）** —— 「基石」（Cornerstone）：拱心石锁合整座建筑，寓意本栈是开发基建的承重起点；
- 整体轮廓向上收拢 —— `up -d` 「拉起」的动势。

### 3.2 文件清单（`assets/brand/`）

| 文件 | 内容 | 用途 |
|---|---|---|
| `logo-mark.svg` | 徽章版标志（深底圆角方） | 头像、favicon 源、App 图标 |
| `logo-mark-transparent.svg` | 裸标志（透明底） | 浅色/深色文档内嵌、图示 |
| `logo-mark-mono.svg` | 单色版（白，透明底） | 水印、压印、单色印刷（浅底反白时将白色替换为 `#0B1626`） |
| `logo-horizontal.svg` | 横版组合：标志 + 中英标准字（浅底） | 文档页眉、站点导航 |
| `logo-horizontal-dark.svg` | 横版组合（深底） | 深色页眉、幻灯片 |
| `favicon.svg` / `favicon-64.png` | 站点图标 | 浏览器标签 |
| `banner-hero.svg` / `.png` | README 头图 1200×300（含 2400×600 @2x） | README 首屏 |
| `social-preview.svg` / `.png` | 社交预览 1280×640 | GitHub Settings → Social preview（上传 PNG） |
| `badge-version.svg` `badge-services.svg` `badge-compose.svg` | 自托管徽章 | README 状态栏（不依赖外部徽章服务） |

### 3.3 使用规则

- **留白**：标志四周保留不小于「底层砌块高度（12 个标志单位）」的净空，即约为标志高度的 1/8。
- **最小尺寸**：徽章版 24px；裸标志 20px；横版组合宽度 240px。小于该尺寸请只用徽章版或 favicon。
- **背景**：徽章版可放任何背景；裸标志要求背景对比充分（深底用原色版/反白版，浅底用原色版）。
- **禁止**：
  - 不拉伸、旋转、加投影/描边/发光；
  - 不更换标志配色（楔块恒为窑金、砌块恒为基石蓝系）;
  - 不把标志塞进其他容器图形或与其项目 logo 组合成立即联名样式；
  - 不用旧文件名或自绘变体替代 `assets/brand/` 中的正式文件。

## 4. 色彩系统

| Token | 色值 | 名称 | 用途 |
|---|---|---|---|
| `--bs-ink` | `#0B1626` | 夜岩黑 | 深色底、标志徽章底、正文标题（浅底模式） |
| `--bs-panel` | `#101E33` / `#14233B` | 岩板蓝 | 卡片、终端芯片、表格深色行 |
| `--bs-primary` | `#1E6FE8` | 基石蓝 | 主色：链接、按钮、徽章右段、中层砌块 |
| `--bs-primary-deep` | `#0F4FB5` | 深基石蓝 | 主色按压态/渐变深端 |
| `--bs-sky` | `#7EB3F7` | 天青 | 浅色砌块、深底次级文字、图表辅助 |
| `--bs-amber` | `#F5A93C` | 窑金 | 唯一强调色：楔块、命令提示 `$`、关键数字 |
| `--bs-mist` | `#EAF0F7` | 雾白 | 深底正文 |
| `--bs-gray` | `#64748B` | 岩灰 | 注释、次级标签 |
| `--bs-line` | `#22334F` / `#2A3B55` | 岩脉线 | 深色界面描边、分隔线 |

规则：

- **一个强调色**：窑金每版面只用于 1-2 处焦点（楔块、`$` 提示符、关键数字），不得大面积铺陈。
- 蓝色系渐变仅允许 `#7EB3F7 → #1E6FE8 → #0F4FB5` 同轴过渡；禁止引入紫红渐变等其他色相。
- 深色界面底色恒为夜岩黑系（`#0B1626`±），浅色文档正文恒为白底 + 夜岩黑标题。
- 对比度：正文用色对底色 ≥ 4.5:1（雾白/夜岩黑、夜岩黑/白均满足）；岩灰只用于辅助信息。

## 5. 字体

| 场景 | 首选（开源） | 系统回退 |
|---|---|---|
| 中文标题/正文 | Noto Sans SC（思源黑体） | Microsoft YaHei / PingFang SC |
| 西文标题/正文 | Inter | Segoe UI / Helvetica Neue / Arial |
| 代码与命令 | JetBrains Mono | Cascadia Code / Consolas |

- SVG 资产内置了上述字体栈；换机器渲染不一致时，优先安装 Noto Sans SC 与 JetBrains Mono（均为开源授权）。
- 标题字重 700-800，正文 400-500；BasicStack 标准字恒为 800 字重、-0.5 至 -1 字距。

## 6. 视觉语言

- **工程暗色**：夜岩黑底 + 4% 白细网格（40px 栅格）+ 单侧蓝色微光，可加 ≤10% 窑金氛围光。
- **终端芯片**：圆角 14 深色面板 + 三个岩脉线圆点 + 一行命令（`$` 用窑金）+ 一行天青状态输出。是本品牌最具识别度的组件，banner/社交图/幻灯片均复用此样式。
- **芯片药丸（chips）**：`#14233B` 底 + `#24364F` 描边、全圆角，用于服务名清单。
- **圆角体系**：徽章 22/96，卡片 14，药丸全圆角，终端 14；不使用直角硬边容器。
- **插图规则**：只使用本仓库原创几何图形与终端界面示意；**不得**出现任何第三方项目 logo、吉祥物或官方素材（各组件名称仅以文字芯片形式出现）。

## 7. 品牌资产索引与变更

- 全部资产集中于 `assets/brand/`，源文件为 SVG（唯一事实源），PNG 为导出产物。
- 导出命令（ImageMagick 7）：

```bash
cd assets/brand
magick -density 144 -background none social-preview.svg social-preview.png
magick social-preview.png -resize 1280x640^ -gravity center -extent 1280x640 social-preview.png
magick -density 192 -background none logo-mark.svg logo-mark.png && magick logo-mark.png -resize 512x512 logo-mark.png
magick -density 144 -background none banner-hero.svg banner-hero.png
magick banner-hero.png -resize 1200x banner-hero.png && magick banner-hero.png -resize 2400x banner-hero@2x.png
magick -density 192 -background none favicon.svg favicon-64.png && magick favicon-64.png -resize 64x64 favicon-64.png
```

- 修改任何标志/文案前，先改本规范并同步 README，再改资产；版本号随仓库主版本走。

## 8. GitHub 仓库配置速查

| 设置项 | 值 |
|---|---|
| Repository name | `basicstack` |
| Description | 粘贴 §2.2 文本（159 字符） |
| Website | （部署文档站后填写，暂留空或指向 README 锚点） |
| Topics | `docker-compose` `self-hosted` `devops` `infrastructure` `mysql` `redis` `postgresql` `elasticsearch` `clickhouse` `milvus` `neo4j` `rabbitmq` `minio` `rustfs` `nacos` `langfuse` `mineru` `vector-database` `llm-observability` `developer-tools` |
| Social preview | 上传 `assets/brand/social-preview.png`（1280×640） |
| Releases | 标签格式 `v1.0.0`（语义化版本），标题「基石服务栈 BasicStack v1.0.0」 |

## 9. 原创性与第三方商标声明

1. 本项目全部品牌资产（标志、横幅、社交预览图、徽章、配色系统）为原创矢量设计，不复制、不改绘任何第三方标识。
2. 文档中出现的 MySQL、Redis、PostgreSQL、Elasticsearch、ClickHouse、Milvus、Neo4j、RabbitMQ、MinIO、RustFS、Nacos、Langfuse、MinerU、Nginx、Jenkins、GitLab、Kibana、phpMyAdmin、pgAdmin、RedisInsight、Attu、DBGate、Docker 等均为其各自所有者的商标或产品名，在本项目中仅用于**指代对应组件**（指示性使用），不构成亦不暗示任何背书或隶属关系。
3. 第三方组件名称在品牌物料中一律以**纯文字**出现（见 §6 插图规则），不使用其官方 logo 图形，避免商标与版权风险。
