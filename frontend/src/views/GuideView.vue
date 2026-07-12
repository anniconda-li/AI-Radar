<script setup lang="ts">
import { computed, nextTick, ref, watch } from 'vue'
import { RouterLink } from 'vue-router'
import { marked } from 'marked'
import { fetchArticle, fetchProvider, type CatalogArticle, type Provider } from '@/data/providers'

const props = defineProps<{ slug: string; kind: string; index: string }>()
const provider = ref<Provider>()
const article = ref<CatalogArticle>()
const articleBody = ref<HTMLElement>()
const loading = ref(true)
const loadError = ref('')

const offeringIndex = computed(() => Number(props.index))
const item = computed(() => provider.value?.products[offeringIndex.value])
const articleHtml = computed(() =>
  article.value ? (marked.parse(article.value.contentMarkdown, { async: false }) as string) : '',
)

watch(
  () => [props.slug, props.kind, props.index] as const,
  async ([slug, kind, index]) => {
    loading.value = true
    loadError.value = ''
    provider.value = undefined
    article.value = undefined
    const numericIndex = Number(index)
    if (kind !== 'product' || !Number.isInteger(numericIndex) || numericIndex < 0) {
      loading.value = false
      loadError.value = '产品地址无效'
      return
    }
    try {
      const [loadedProvider, loadedArticle] = await Promise.all([
        fetchProvider(slug),
        fetchArticle(slug, numericIndex),
      ])
      provider.value = loadedProvider
      article.value = loadedArticle
    } catch (error) {
      loadError.value = error instanceof Error ? error.message : '文章暂时无法加载'
    } finally {
      loading.value = false
    }
  },
  { immediate: true },
)

watch(articleHtml, async () => {
  await nextTick()
  decorateCodeBlocks()
  decorateImages()
})

function decorateCodeBlocks() {
  articleBody.value?.querySelectorAll('pre').forEach((pre) => {
    if (pre.parentElement?.classList.contains('markdown-code-block')) return
    const wrapper = document.createElement('div')
    wrapper.className = 'markdown-code-block'
    const toolbar = document.createElement('div')
    const code = pre.querySelector('code')
    const language = code?.className.replace('language-', '') || 'command'
    const label = document.createElement('span')
    label.textContent = language
    const button = document.createElement('button')
    button.type = 'button'
    button.dataset.copyCommand = 'true'
    button.textContent = '复制'
    button.addEventListener('click', () => void copyCommand(code?.textContent ?? '', button))
    toolbar.append(label, button)
    pre.parentNode?.insertBefore(wrapper, pre)
    wrapper.append(toolbar, pre)
  })
}

function decorateImages() {
  articleBody.value?.querySelectorAll('img').forEach((image) => {
    const container = image.parentElement
    if (!container || container.classList.contains('article-image')) return
    container.classList.add('article-image')
    if (image.alt) {
      const caption = document.createElement('span')
      caption.textContent = image.alt
      container.append(caption)
    }
  })
}

async function copyCommand(code: string, button: HTMLButtonElement) {
  if (!code) return
  let copied = false
  try {
    await navigator.clipboard.writeText(code)
    copied = true
  } catch {
    const textarea = document.createElement('textarea')
    textarea.value = code
    textarea.style.position = 'fixed'
    textarea.style.opacity = '0'
    document.body.append(textarea)
    textarea.select()
    copied = document.execCommand('copy')
    textarea.remove()
  }
  button.textContent = copied ? '已复制' : '复制失败'
  window.setTimeout(() => (button.textContent = '复制'), 1500)
}
</script>

<template>
  <main
    v-if="provider && item && article"
    class="guide-page"
    :style="{ '--accent': provider.accent }"
  >
    <RouterLink class="guide-back" :to="`/providers/${provider.slug}`">
      <svg viewBox="0 0 24 24" aria-hidden="true"><path d="m15 5-7 7 7 7" /></svg>
      返回 {{ provider.name }}
    </RouterLink>

    <section class="guide-hero article-hero">
      <div class="guide-provider">
        <span><img :src="provider.logoUrl" :alt="provider.logoAlt" /></span>
        <div>
          <small>{{ item.type }}</small
          ><strong>{{ provider.name }}</strong>
        </div>
      </div>
      <h1>{{ article.title }}</h1>
      <p>{{ article.summary }}</p>
      <div class="guide-platforms">
        <span v-for="platform in item.platforms" :key="platform">{{ platform }}</span>
      </div>
    </section>

    <section class="guide-layout">
      <article
        ref="articleBody"
        class="guide-article markdown-article"
        v-html="articleHtml"
      ></article>

      <aside class="guide-aside">
        <div class="guide-official-card">
          <p class="overline">OFFICIAL SOURCES</p>
          <h2>继续查看官方资料</h2>
          <p>本文负责把产品和操作路径讲清楚；版本、价格、协议和完整参数仍以厂商页面为准。</p>
          <div class="article-source-links">
            <a
              v-for="source in article.sourceLinks"
              :key="source.url"
              :href="source.url"
              target="_blank"
              rel="noreferrer"
            >
              {{ source.label }}
              <svg viewBox="0 0 24 24" aria-hidden="true"><path d="M7 17 17 7M9 7h8v8" /></svg>
            </a>
          </div>
          <div class="official-notes">
            <strong>资料状态</strong>
            <p>产品能力和使用入口会变化，涉及购买或上线决策时请再次核对。</p>
            <small>最近核对：{{ article.verifiedAt }}</small>
          </div>
        </div>
      </aside>
    </section>
  </main>

  <main v-else-if="loading" class="not-found-page">
    <p class="overline">LOADING ARTICLE</p>
    <h1>正在读取完整文章</h1>
  </main>

  <main v-else class="not-found-page">
    <p class="overline">ARTICLE NOT READY</p>
    <h1>这篇内容尚未完成</h1>
    <p>{{ loadError || '文章没有发布，不使用通用模板代替。' }}</p>
    <RouterLink :to="`/providers/${slug}`">返回厂商页面</RouterLink>
  </main>
</template>
