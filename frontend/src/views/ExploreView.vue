<script setup lang="ts">
import { computed, onBeforeUnmount, onMounted, ref } from 'vue'
import { RouterLink } from 'vue-router'
import { fetchProviders, type Provider } from '@/data/providers'

const slides = [
  {
    eyebrow: 'ONE PLACE, CLEARER CHOICES',
    title: '一站看清\n中国 AI 生态',
    description: '从厂商进入，顺着产品、模型和开发平台逐层了解，不再来回翻找。',
    cta: '浏览厂商',
    href: '#providers',
    stat: '6 家首批收录',
    image: '/carousel/provider-landscape.jpg',
    providerSlugs: ['deepseek', 'moonshot', 'zhipu', 'alibaba'],
    chips: ['厂商档案', '产品入口', '模型族'],
    tone: 'indigo',
  },
  {
    eyebrow: 'AGENTS, CODING & OFFICE',
    title: '不只看模型，\n也看真正能用的工具',
    description: '集中发现 Agent、编程助手、办公工具和模型平台，了解它们分别解决什么问题。',
    cta: '查看服务版图',
    href: '#capabilities',
    stat: '覆盖 4 类应用',
    image: '/carousel/tool-workbench.jpg',
    providerSlugs: ['moonshot', 'zhipu', 'alibaba', 'volcengine'],
    chips: ['Agent', 'Coding', 'Office'],
    tone: 'blue',
  },
  {
    eyebrow: 'INSTALL, API & SOURCES',
    title: '从了解产品，\n走到安装与 API 接入',
    description: '按系统查看官方安装步骤，沿着数据来源进入 API、SDK、计价与开发文档。',
    cta: '了解资料方法',
    href: '#sources',
    stat: '来源可追溯',
    image: '/carousel/api-map.jpg',
    providerSlugs: ['deepseek', 'baidu', 'volcengine', 'moonshot'],
    chips: ['Windows / macOS / Linux', 'API / SDK', '官方来源'],
    tone: 'violet',
  },
]

const query = ref('')
const providers = ref<Provider[]>([])
const catalogLoading = ref(true)
const catalogError = ref('')
const activeCategory = ref('全部')
const activeSlide = ref(0)
const carouselPaused = ref(false)
const categories = ['全部', 'AI 助手', 'Agent', '办公工具', '编程工具', '大模型', 'API', '云平台']
let slideTimer = 0

const filteredProviders = computed(() => {
  const keyword = query.value.trim().toLowerCase()

  return providers.value.filter((provider) => {
    const matchesCategory =
      activeCategory.value === '全部' ||
      provider.categories.includes(activeCategory.value) ||
      provider.products.some((product) => product.type.includes(activeCategory.value))
    const searchable = [
      provider.name,
      provider.englishName,
      provider.description,
      ...provider.categories,
      ...provider.products.map((product) => product.name),
      ...provider.models.map((model) => model.name),
    ]
      .join(' ')
      .toLowerCase()

    return matchesCategory && (!keyword || searchable.includes(keyword))
  })
})

function getSlideProviders(slugs: string[]) {
  return slugs
    .map((slug) => providers.value.find((provider) => provider.slug === slug))
    .filter((provider) => provider !== undefined)
}

async function loadCatalog() {
  catalogLoading.value = true
  catalogError.value = ''
  try {
    providers.value = await fetchProviders()
  } catch (error) {
    catalogError.value = error instanceof Error ? error.message : '目录服务暂时不可用'
  } finally {
    catalogLoading.value = false
  }
}

function selectSlide(index: number) {
  activeSlide.value = (index + slides.length) % slides.length
}

function clearFilters() {
  query.value = ''
  activeCategory.value = '全部'
}

onMounted(() => {
  void loadCatalog()
  slideTimer = window.setInterval(() => {
    if (!carouselPaused.value) selectSlide(activeSlide.value + 1)
  }, 5200)
})

onBeforeUnmount(() => window.clearInterval(slideTimer))
</script>

<template>
  <main>
    <section
      class="feature-carousel"
      :class="`tone-${slides[activeSlide]?.tone}`"
      aria-label="本站功能介绍"
      @mouseenter="carouselPaused = true"
      @mouseleave="carouselPaused = false"
    >
      <Transition name="carousel-slide" mode="out-in">
        <article :key="activeSlide" class="carousel-panel">
          <div class="carousel-copy">
            <p class="carousel-eyebrow">{{ slides[activeSlide]?.eyebrow }}</p>
            <h1>{{ slides[activeSlide]?.title }}</h1>
            <p class="carousel-description">{{ slides[activeSlide]?.description }}</p>
            <a class="carousel-cta" :href="slides[activeSlide]?.href">
              <span>{{ slides[activeSlide]?.cta }}</span>
              <svg viewBox="0 0 24 24" aria-hidden="true">
                <path d="M5 12h14m-5-5 5 5-5 5" />
              </svg>
            </a>
          </div>

          <div class="carousel-visual" aria-hidden="true">
            <img class="carousel-art" :src="slides[activeSlide]?.image" alt="" />
            <div class="visual-brand-row">
              <span
                v-for="provider in getSlideProviders(slides[activeSlide]?.providerSlugs ?? [])"
                :key="provider.slug"
                :title="provider.name"
              >
                <img :src="provider.logoUrl" :alt="provider.logoAlt" />
              </span>
            </div>
            <div class="visual-summary">
              <small>{{ String(activeSlide + 1).padStart(2, '0') }}</small>
              <strong>{{ slides[activeSlide]?.stat }}</strong>
              <div>
                <span v-for="chip in slides[activeSlide]?.chips" :key="chip">{{ chip }}</span>
              </div>
            </div>
          </div>
        </article>
      </Transition>

      <button
        class="carousel-arrow prev"
        type="button"
        aria-label="上一项"
        @click="selectSlide(activeSlide - 1)"
      >
        <svg viewBox="0 0 24 24" aria-hidden="true"><path d="m15 5-7 7 7 7" /></svg>
      </button>
      <button
        class="carousel-arrow next"
        type="button"
        aria-label="下一项"
        @click="selectSlide(activeSlide + 1)"
      >
        <svg viewBox="0 0 24 24" aria-hidden="true"><path d="m9 5 7 7-7 7" /></svg>
      </button>

      <div class="carousel-tabs">
        <button
          v-for="(slide, index) in slides"
          :key="slide.eyebrow"
          :class="{ active: activeSlide === index }"
          type="button"
          @click="selectSlide(index)"
        >
          <span>{{ String(index + 1).padStart(2, '0') }}</span>
          <strong>{{ ['发现', '比较', '溯源'][index] }}</strong>
        </button>
      </div>
    </section>

    <section class="directory-intro">
      <div>
        <p class="overline">PROVIDER DIRECTORY</p>
        <h2>从厂商开始探索</h2>
      </div>
      <p>首批资料来自厂商官方网站与开发文档，后续会继续补充套餐、参数和产品动态。</p>
    </section>

    <section id="capabilities" class="capability-map">
      <article>
        <span>01</span>
        <p>AGENT</p>
        <h3>把任务交给 AI 执行</h3>
        <strong>Kimi · 百度千帆 Agent · 火山 AgentKit</strong>
      </article>
      <article>
        <span>02</span>
        <p>CODING</p>
        <h3>进入真实开发工作流</h3>
        <strong>Kimi Code · Qwen Code · GLM Coding Plan</strong>
      </article>
      <article>
        <span>03</span>
        <p>OFFICE</p>
        <h3>处理文档、表格与演示</h3>
        <strong>Kimi Docs · Kimi Sheets · Slides · 工作流应用</strong>
      </article>
      <article>
        <span>04</span>
        <p>DEVELOPER</p>
        <h3>安装、API 与 SDK</h3>
        <strong>跨平台安装入口 · 开放平台 · 官方接口文档 · 数据来源</strong>
      </article>
    </section>

    <section id="providers" class="catalog-section">
      <label id="catalog-search" class="search-box">
        <svg viewBox="0 0 24 24" aria-hidden="true">
          <path d="m21 21-4.35-4.35m2.35-5.65a8 8 0 1 1-16 0 8 8 0 0 1 16 0Z" />
        </svg>
        <input v-model="query" type="search" placeholder="搜索厂商、产品或模型" />
        <span>搜索</span>
      </label>

      <div class="catalog-toolbar">
        <div class="category-filter" aria-label="厂商类别筛选">
          <button
            v-for="category in categories"
            :key="category"
            :class="{ active: activeCategory === category }"
            type="button"
            @click="activeCategory = category"
          >
            {{ category }}
          </button>
        </div>
        <span class="result-count">{{ filteredProviders.length }} 个结果</span>
      </div>

      <div v-if="catalogLoading" class="no-results">
        <span>正在读取目录</span>
        <p>厂商、产品和模型资料正在从后端加载。</p>
      </div>

      <div v-else-if="catalogError" class="no-results">
        <span>目录暂时无法加载</span>
        <p>{{ catalogError }}</p>
        <button type="button" @click="loadCatalog">重新加载</button>
      </div>

      <div v-else-if="filteredProviders.length" class="provider-grid">
        <RouterLink
          v-for="(provider, index) in filteredProviders"
          :key="provider.slug"
          class="provider-card"
          :style="{
            '--accent': provider.accent,
            '--aura': provider.aura,
            '--delay': `${index * 70}ms`,
          }"
          :to="`/providers/${provider.slug}`"
        >
          <div class="provider-card-top">
            <span class="provider-logo"
              ><img :src="provider.logoUrl" :alt="provider.logoAlt"
            /></span>
            <span class="verified-source">官方来源</span>
          </div>
          <div class="provider-name">
            <h3>{{ provider.name }}</h3>
            <span>{{ provider.englishName }}</span>
          </div>
          <p>{{ provider.description }}</p>
          <div class="tag-list">
            <span v-for="category in provider.categories" :key="category">{{ category }}</span>
          </div>
          <div class="card-cta">
            <span>查看详情</span>
            <svg viewBox="0 0 24 24" aria-hidden="true"><path d="M4 12h16m-6-6 6 6-6 6" /></svg>
          </div>
        </RouterLink>
      </div>

      <div v-else class="no-results">
        <span>没有匹配结果</span>
        <p>换个关键词，或者选择“全部”分类试试。</p>
        <button type="button" @click="clearFilters">清除筛选</button>
      </div>
    </section>

    <section id="sources" class="about-index">
      <div>
        <p class="overline">HOW IT WORKS</p>
        <h2>资料会持续核对，不把展示页当作最终答案。</h2>
      </div>
      <div class="about-points">
        <article>
          <strong>官方优先</strong>
          <p>产品、模型和价格尽量引用厂商官网与开发文档。</p>
        </article>
        <article>
          <strong>标注时间</strong>
          <p>价格和模型会变化，详情页保留最近核对日期。</p>
        </article>
        <article>
          <strong>直接跳转</strong>
          <p>提供官网、体验入口和开发文档，方便继续确认。</p>
        </article>
      </div>
    </section>
  </main>
</template>
