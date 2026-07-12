<script setup lang="ts">
import { ref, watch } from 'vue'
import { RouterLink } from 'vue-router'
import { fetchProvider, type Provider } from '@/data/providers'

const props = defineProps<{ slug: string }>()
const provider = ref<Provider>()
const loading = ref(true)

watch(
  () => props.slug,
  async (slug) => {
    loading.value = true
    provider.value = undefined
    try {
      provider.value = await fetchProvider(slug)
    } catch {
      provider.value = undefined
    } finally {
      loading.value = false
    }
  },
  { immediate: true },
)
</script>

<template>
  <main
    v-if="provider"
    class="detail-page"
    :style="{ '--accent': provider.accent, '--aura': provider.aura }"
  >
    <section class="detail-hero">
      <div class="detail-aura" aria-hidden="true"></div>
      <div class="breadcrumb">
        <RouterLink to="/explore#providers">
          <svg viewBox="0 0 24 24" aria-hidden="true"><path d="m15 5-7 7 7 7" /></svg>
          全部厂商
        </RouterLink>
        <span>/</span>
        <strong>{{ provider.name }}</strong>
      </div>

      <div class="detail-heading">
        <span class="detail-logo"><img :src="provider.logoUrl" :alt="provider.logoAlt" /></span>
        <div class="detail-brand-copy">
          <p class="overline">PROVIDER PROFILE</p>
          <h1>{{ provider.name }}</h1>
          <p class="english-name">{{ provider.englishName }}</p>
        </div>
      </div>
      <p class="detail-intro">{{ provider.introduction }}</p>
      <div class="detail-actions">
        <a
          class="official-link primary"
          :href="provider.officialUrl"
          target="_blank"
          rel="noreferrer"
        >
          访问官网
          <svg viewBox="0 0 24 24" aria-hidden="true"><path d="M7 17 17 7M9 7h8v8" /></svg>
        </a>
        <a class="official-link" :href="provider.docsUrl" target="_blank" rel="noreferrer">
          开发文档
          <svg viewBox="0 0 24 24" aria-hidden="true"><path d="M7 17 17 7M9 7h8v8" /></svg>
        </a>
      </div>
    </section>

    <section class="detail-content">
      <div class="content-main">
        <div class="block-heading">
          <div>
            <p class="overline">PRODUCTS</p>
            <h2>产品与平台</h2>
          </div>
          <span>{{ provider.products.length }} 个官方入口</span>
        </div>

        <div class="product-grid">
          <RouterLink
            v-for="(product, index) in provider.products"
            :key="product.name"
            class="detail-product-card"
            :to="`/providers/${provider.slug}/guides/product/${index}`"
          >
            <div class="product-index">0{{ index + 1 }}</div>
            <span class="product-type">{{ product.type }}</span>
            <h3>{{ product.name }}</h3>
            <p>{{ product.description }}</p>
            <div v-if="product.platforms?.length" class="product-platforms">
              <span v-for="platform in product.platforms" :key="platform">{{ platform }}</span>
            </div>
            <span class="product-link">
              查看详情
              <svg viewBox="0 0 24 24" aria-hidden="true">
                <path d="M4 12h16m-6-6 6 6-6 6" />
              </svg>
            </span>
          </RouterLink>
        </div>

        <div class="block-heading models-heading">
          <div>
            <p class="overline">MODEL FAMILIES</p>
            <h2>代表模型</h2>
          </div>
          <span>价格以每百万 Tokens 计，特殊说明除外</span>
        </div>

        <div class="model-list">
          <article v-for="model in provider.models" :key="model.name">
            <span class="model-orbit" aria-hidden="true"><i></i></span>
            <div class="model-main">
              <h3>{{ model.name }}</h3>
              <p>{{ model.ability }}</p>
            </div>
            <div class="model-fact">
              <small>上下文</small><strong>{{ model.context }}</strong>
            </div>
            <div class="model-price">
              <small>参考价格</small><strong>{{ model.pricing }}</strong>
            </div>
          </article>
        </div>
      </div>

      <aside class="detail-sidebar">
        <div class="info-panel">
          <p class="overline">AT A GLANCE</p>
          <h2>快速了解</h2>
          <ul>
            <li v-for="highlight in provider.highlights" :key="highlight">
              <span>✓</span>{{ highlight }}
            </li>
          </ul>
        </div>

        <div class="source-panel">
          <span>最近核对</span>
          <strong>{{ provider.sourceUpdated }}</strong>
          <p>模型与价格更新频繁，做决策前请再次查看官方文档。</p>
          <div class="source-links">
            <a
              v-for="source in provider.sourceLinks"
              :key="source.url"
              :href="source.url"
              target="_blank"
              rel="noreferrer"
            >
              {{ source.label }}<b aria-hidden="true">↗</b>
            </a>
          </div>
        </div>
      </aside>
    </section>
  </main>

  <main v-else-if="loading" class="not-found-page">
    <p class="overline">LOADING PROVIDER</p>
    <h1>正在读取厂商资料</h1>
  </main>

  <main v-else class="not-found-page">
    <p class="overline">404 · PROVIDER NOT FOUND</p>
    <h1>暂时没有这个厂商的资料</h1>
    <p>可能是地址有误，也可能是资料尚未收录。</p>
    <RouterLink to="/explore">返回厂商目录</RouterLink>
  </main>
</template>
