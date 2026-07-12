<script setup lang="ts">
import { onBeforeUnmount, onMounted, ref } from 'vue'
import { RouterLink } from 'vue-router'
import BrandAsset from '@/components/BrandAsset.vue'
import BrandMark from '@/components/BrandMark.vue'

const flowCanvas = ref<HTMLCanvasElement>()
let animationFrame = 0
let lastFrame = 0

function drawFlow(time: number) {
  const canvas = flowCanvas.value
  if (!canvas) return

  const reducedMotion = window.matchMedia('(prefers-reduced-motion: reduce)').matches
  if (!reducedMotion && time - lastFrame < 32) {
    animationFrame = window.requestAnimationFrame(drawFlow)
    return
  }
  lastFrame = time

  const width = 180
  const height = Math.max(100, Math.round(width / (window.innerWidth / window.innerHeight)))
  if (canvas.width !== width || canvas.height !== height) {
    canvas.width = width
    canvas.height = height
  }

  const context = canvas.getContext('2d')
  if (!context) return

  const image = context.createImageData(width, height)
  const pixels = image.data
  const seconds = time / 1000
  const directionShift = Math.sin(seconds * 0.3) * 0.7

  for (let y = 0; y < height; y += 1) {
    const v = (y / height - 0.5) * Math.PI * 2

    for (let x = 0; x < width; x += 1) {
      const u = (x / width - 0.5) * Math.PI * 2
      const weights = [
        Math.exp(
          Math.sin(
            u * 1.05 +
              v * (0.56 + directionShift * 0.14) +
              seconds * 1.36 +
              Math.sin(v * 0.9 - seconds * 0.54) * 0.68,
          ) * 1.02,
        ),
        Math.exp(
          Math.sin(
            -u * 0.86 + v * 1.06 - seconds + Math.sin(u * 0.72 + seconds * 0.42) * 0.72 + 1.25,
          ) * 1.02,
        ),
        Math.exp(
          Math.sin(
            u * 1.18 -
              v * 0.62 +
              seconds * 0.8 +
              Math.cos((u + v) * 0.62 - seconds * 0.68) * 0.66 +
              2.55,
          ) * 1.02,
        ),
        Math.exp(
          Math.sin(
            -u * 1.05 - v * 0.8 + seconds * 1.16 + Math.cos(v * 0.92 + seconds * 0.48) * 0.7 + 3.85,
          ) * 1.02,
        ),
        Math.exp(
          Math.sin(
            u * 0.7 +
              v * 1.2 -
              seconds * 0.68 +
              Math.sin((u - v) * 0.7 + seconds * 0.6) * 0.7 +
              5.1,
          ) * 1.02,
        ),
        Math.exp(
          Math.sin(
            -u * 0.78 +
              v * 0.46 +
              seconds * 0.92 +
              Math.cos((u + v) * 0.54 - seconds * 0.38) * 0.65 +
              0.6,
          ) * 1.02,
        ) * 0.4,
        Math.exp(
          Math.sin(
            u * 0.94 - v * 1.1 - seconds * 1.12 + Math.sin(u * 0.6 + seconds * 0.52) * 0.7 + 4.5,
          ) * 1.02,
        ) * 0.25,
      ]
      const palette = [
        [126, 177, 255],
        [190, 218, 255],
        [116, 116, 229],
        [184, 145, 244],
        [248, 170, 216],
        [255, 225, 154],
        [255, 164, 104],
      ]
      const totalWeight = weights.reduce((sum, weight) => sum + weight, 0)
      const highlight = 1 + Math.sin(u * 0.55 + v * 0.42 + seconds * 0.6) * 0.07
      const offset = (y * width + x) * 4

      for (let channel = 0; channel < 3; channel += 1) {
        const mixed = weights.reduce(
          (sum, weight, index) => sum + palette[index]![channel]! * weight,
          0,
        )
        pixels[offset + channel] = Math.min(255, (mixed / totalWeight) * highlight + 10)
      }
      pixels[offset + 3] = 255
    }
  }

  context.putImageData(image, 0, 0)
  if (!reducedMotion) animationFrame = window.requestAnimationFrame(drawFlow)
}

onMounted(() => {
  animationFrame = window.requestAnimationFrame(drawFlow)
})

onBeforeUnmount(() => window.cancelAnimationFrame(animationFrame))
</script>

<template>
  <main class="landing-page">
    <canvas ref="flowCanvas" class="flow-canvas" aria-hidden="true"></canvas>
    <div class="landing-grid" aria-hidden="true"></div>
    <div class="landing-ray-field" aria-hidden="true"></div>

    <header class="landing-header">
      <div class="landing-header-left">
        <BrandMark class="landing-brand-mark" />

        <div class="landing-service-menu">
          <span class="service-trigger">
            服务
            <svg viewBox="0 0 20 20" aria-hidden="true"><path d="m6 8 4 4 4-4" /></svg>
          </span>
          <div class="service-dropdown">
            <p>我们提供什么</p>
            <article>
              <span>01</span>
              <div><strong>厂商档案</strong><small>集中了解产品与官方入口</small></div>
            </article>
            <article>
              <span>02</span>
              <div><strong>模型信息</strong><small>查看定位、上下文与能力</small></div>
            </article>
            <article>
              <span>03</span>
              <div><strong>API 价格</strong><small>追踪官方计价与更新时间</small></div>
            </article>
          </div>
        </div>
      </div>

      <div class="landing-header-meta">
        <span><strong>中文</strong> / EN</span>
        <i></i>
        <span>GUEST MODE</span>
      </div>
    </header>

    <section class="landing-center-v2">
      <div class="landing-full-logo" aria-label="AI Radar">
        <BrandAsset variant="wordmark" />
      </div>

      <h1>一站式了解中国 AI 产品生态</h1>
      <p class="landing-lead">汇总主流厂商的产品、模型能力、API 接入与价格信息。</p>

      <RouterLink class="enter-button guest-enter-button" to="/explore">
        <span>以游客账户开始</span>
        <svg viewBox="0 0 24 24" aria-hidden="true">
          <path d="M5 12h14m-5-5 5 5-5 5" />
        </svg>
      </RouterLink>

      <div class="landing-scope" aria-label="本站内容范围">
        <span>厂商档案</span><i></i><span>产品入口</span><i></i><span>模型信息</span><i></i
        ><span>API 价格</span>
      </div>

      <p class="landing-description">
        资料优先取自厂商官网与开发文档，并标注最近核对时间，便于继续查证。
      </p>
    </section>
  </main>
</template>
