# AI Radar

一个用于学习 Vue、Spring Boot、前后端联调、构建和后续部署流程的全栈项目。

当前业务原型用于集中展示中国 AI 厂商、产品、模型和官方资料。第一版不接数据库，后端数据保存在内存中。

## 当前进度

已经完成：

- Spring Boot 最小后端和内存 Product REST API
- Vue 3 + Vite + TypeScript 前端
- Vue Router 多页面导航
- Vite 将 `/api` 代理到本地 Spring Boot
- 厂商目录、详情页和首版展示数据
- 前后端本地构建与联调验证

暂未开始：

- 数据库
- 用户注册和登录
- GitHub 首次提交与推送
- Docker、Docker Compose
- GitHub Actions、GHCR
- 服务器部署

## 项目结构

```text
AI-Radar/
├─ backend/    Spring Boot 后端
├─ frontend/   Vue 前端
└─ README.md   当前项目说明
```

## 本地启动

使用两个本地 PowerShell 终端分别启动。

后端：

```powershell
cd C:\Users\17377\Desktop\Web-test\AI-Radar\backend
.\mvnw.cmd spring-boot:run
```

前端：

```powershell
cd C:\Users\17377\Desktop\Web-test\AI-Radar\frontend
npm.cmd run dev
```

访问 `http://localhost:5173`。浏览器向 `/api` 发出的请求由 Vite 代理到 `http://localhost:8080`。

## 验证命令

后端测试：

```powershell
cd backend
.\mvnw.cmd test
```

前端检查与构建：

```powershell
cd frontend
npm.cmd run lint
npm.cmd run build
```

## 开发时的自动更新

- 修改 Vue、TypeScript 或 CSS 后，Vite 通常会自动热更新浏览器。
- 当前后端没有引入 Spring Boot DevTools；修改 Java 代码后需要停止并重新启动后端。
- 重启后端会清空内存数据，这是当前阶段的预期行为。

## 不应提交的生成目录

以下目录由工具生成，不属于源码：

```text
frontend/node_modules/
frontend/dist/
backend/target/
```

正式进入 Git 阶段时会在根目录统一检查 `.gitignore`。
