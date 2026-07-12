<script setup lang="ts">
import { onMounted, ref } from 'vue'

type BrandVariant = 'icon' | 'wordmark'

const props = defineProps<{ variant: BrandVariant }>()
const canvas = ref<HTMLCanvasElement>()

const crops = {
  icon: { x: 66, y: 69, width: 104, height: 104 },
  wordmark: { x: 292, y: 87, width: 430, height: 91 },
} as const

const crop = crops[props.variant]

onMounted(() => {
  const target = canvas.value
  if (!target) return

  const source = new Image()
  source.addEventListener('load', () => {
    const context = target.getContext('2d')
    if (!context) return

    context.drawImage(
      source,
      crop.x,
      crop.y,
      crop.width,
      crop.height,
      0,
      0,
      crop.width,
      crop.height,
    )

    const image = context.getImageData(0, 0, crop.width, crop.height)
    const pixels = image.data

    for (let index = 0; index < pixels.length; index += 4) {
      const darkestChannel = Math.min(pixels[index]!, pixels[index + 1]!, pixels[index + 2]!)
      const backgroundOpacity = Math.max(0, Math.min(1, (248 - darkestChannel) / 18))
      pixels[index + 3] = Math.round(pixels[index + 3]! * backgroundOpacity)
    }

    context.putImageData(image, 0, 0)
  })
  source.src = '/ai-radar-brand.png'
})
</script>

<template>
  <canvas
    ref="canvas"
    class="brand-asset"
    :width="crop.width"
    :height="crop.height"
    aria-hidden="true"
  ></canvas>
</template>

<style scoped>
.brand-asset {
  display: block;
  width: 100%;
  height: auto;
}
</style>
