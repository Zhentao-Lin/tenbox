<template>
  <nav class="navbar" :class="{ scrolled }">
    <div class="container nav-inner">
      <a href="#" class="nav-brand">
        <img src="../assets/logo.png" alt="TenBox" class="nav-logo" />
        <span class="nav-name">TenBox</span>
      </a>
      <div class="nav-actions">
        <button class="lang-toggle" @click="toggleLocale" :title="localeName">
          {{ localeName }}
        </button>
      </div>
    </div>
  </nav>
</template>

<script setup>
import { ref, computed, onMounted, onUnmounted } from 'vue'
import { useI18n } from 'vue-i18n'

const { locale } = useI18n()
const scrolled = ref(false)

const localeName = computed(() => (locale.value === 'zh-CN' ? 'EN' : '中文'))

function toggleLocale() {
  const next = locale.value === 'zh-CN' ? 'en-US' : 'zh-CN'
  locale.value = next
  localStorage.setItem('tenbox-locale', next)
  document.documentElement.lang = next === 'zh-CN' ? 'zh' : 'en'
}

function onScroll() {
  scrolled.value = window.scrollY > 10
}

onMounted(() => window.addEventListener('scroll', onScroll, { passive: true }))
onUnmounted(() => window.removeEventListener('scroll', onScroll))
</script>

<style scoped>
.navbar {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  height: var(--nav-height);
  z-index: 100;
  transition: all var(--transition);
  background: transparent;
}

.navbar.scrolled {
  background: rgba(15, 23, 42, 0.95);
  backdrop-filter: blur(12px);
  box-shadow: 0 1px 4px rgba(0, 0, 0, 0.15);
}

.nav-inner {
  display: flex;
  align-items: center;
  justify-content: space-between;
  height: 100%;
}

.nav-brand {
  display: flex;
  align-items: center;
  gap: 10px;
}

.nav-logo {
  width: 32px;
  height: 32px;
  border-radius: 6px;
}

.nav-name {
  font-size: 1.25rem;
  font-weight: 700;
  color: #fff;
}

.nav-actions {
  display: flex;
  align-items: center;
  gap: 12px;
}

.lang-toggle {
  padding: 6px 14px;
  border-radius: 6px;
  font-size: 0.875rem;
  font-weight: 600;
  color: rgba(255, 255, 255, 0.8);
  border: 1px solid rgba(255, 255, 255, 0.2);
  transition: all var(--transition);
}

.lang-toggle:hover {
  color: #fff;
  border-color: rgba(255, 255, 255, 0.5);
  background: rgba(255, 255, 255, 0.1);
}

@media (max-width: 768px) {
  .nav-name {
    font-size: 1.1rem;
  }
}
</style>
