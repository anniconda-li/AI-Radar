<script setup lang="ts">
import { RouterLink } from 'vue-router'
</script>

<template>
  <main class="not-found-page">
    <p class="overline">404 · PAGE NOT FOUND</p>
    <h1>这个页面暂时不存在</h1>
    <p>检查一下地址，或者返回内容目录继续探索。</p>
    <RouterLink to="/explore">返回内容目录</RouterLink>
  </main>
</template>
