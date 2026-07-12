# AI Radar Frontend

Vue 3、Vite、TypeScript 和 Vue Router 构成的前端项目。

## 常用命令

```powershell
npm.cmd install
npm.cmd run dev
npm.cmd run lint
npm.cmd run build
```

开发服务器默认运行在 `http://localhost:5173`。

`vite.config.ts` 在 Vite 启动时读取，将浏览器的 `/api` 请求代理到 `http://localhost:8080`。业务代码因此只使用 `/api`，不直接写后端主机和端口。

## 主要目录

```text
src/
├─ assets/       全局样式
├─ components/   可复用组件
├─ data/         当前阶段的静态厂商资料
├─ router/       前端路由
└─ views/        首页、目录页和详情页
```

`node_modules` 和 `dist` 都是生成目录，不应提交到 Git。
