<script setup lang="ts">
import { computed, onBeforeUnmount, ref } from 'vue'
import { RouterLink, RouterView, useRoute } from 'vue-router'
import BrandMark from '@/components/BrandMark.vue'

const route = useRoute()
const accountOpen = ref(false)
const exploreActive = computed(() => route.name === 'explore' && !route.hash)
const providersActive = computed(
  () => ['provider', 'guide'].includes(String(route.name)) || route.hash === '#providers',
)
const sourcesActive = computed(() => route.name === 'explore' && route.hash === '#sources')

function closeAccount() {
  accountOpen.value = false
}

function handleEscape(event: KeyboardEvent) {
  if (event.key === 'Escape') closeAccount()
}

function handleAccountBlur(event: FocusEvent) {
  const menu = event.currentTarget as HTMLElement
  const next = event.relatedTarget as Node | null
  if (!next || !menu.contains(next)) closeAccount()
}

window.addEventListener('keydown', handleEscape)
onBeforeUnmount(() => window.removeEventListener('keydown', handleEscape))
</script>

<template>
  <div class="site-shell">
    <header v-if="route.name !== 'home'" class="site-header">
      <RouterLink class="brand" to="/explore" aria-label="AI Radar 内容目录">
        <BrandMark class="nav-brand-mark" />
        <span>AI Radar</span>
      </RouterLink>

      <nav class="main-nav" aria-label="主导航">
        <RouterLink :class="{ active: exploreActive }" to="/explore">探索</RouterLink>
        <RouterLink :class="{ active: providersActive }" to="/explore#providers">厂商</RouterLink>
        <RouterLink :class="{ active: sourcesActive }" to="/explore#sources">资料来源</RouterLink>
      </nav>

      <div class="header-actions">
        <RouterLink class="header-search" to="/explore#catalog-search" aria-label="搜索目录">
          <svg viewBox="0 0 24 24" aria-hidden="true">
            <path d="m21 21-4.35-4.35m2.35-5.65a8 8 0 1 1-16 0 8 8 0 0 1 16 0Z" />
          </svg>
        </RouterLink>

        <div
          class="account-menu"
          @mouseenter="accountOpen = true"
          @mouseleave="accountOpen = false"
          @focusin="accountOpen = true"
          @focusout="handleAccountBlur"
        >
          <button
            class="account-trigger"
            type="button"
            :aria-expanded="accountOpen"
            @click="accountOpen = true"
          >
            <span class="account-avatar" aria-hidden="true">
              <svg viewBox="0 0 24 24">
                <circle cx="12" cy="8" r="3.5" />
                <path d="M5.5 20c.7-4 3-6 6.5-6s5.8 2 6.5 6" />
              </svg>
            </span>
            <span class="account-copy"><strong>游客</strong><small>账户</small></span>
            <svg class="account-chevron" viewBox="0 0 20 20" aria-hidden="true">
              <path d="m6 8 4 4 4-4" />
            </svg>
          </button>

          <Transition name="account-popover">
            <div v-if="accountOpen" class="account-popover">
              <strong>当前以游客身份浏览</strong>
              <p>登录与注册会在后续版本接入，现在所有目录内容都可直接查看。</p>
              <span>账户功能 · 即将开放</span>
            </div>
          </Transition>
        </div>
      </div>
    </header>

    <RouterView v-slot="{ Component }">
      <Transition name="page" mode="out-in">
        <component :is="Component" />
      </Transition>
    </RouterView>

    <footer v-if="route.name !== 'home'" class="site-footer">
      <div>
        <strong>AI Radar</strong>
        <p>持续整理中国 AI 厂商、产品与模型信息。</p>
      </div>
      <p>商标与 Logo 归各权利人所有 · 信息以厂商官方页面为准</p>
    </footer>
  </div>
</template>
