import { createI18n } from 'vue-i18n'
import zhCN from './zh-CN.json'
import enUS from './en-US.json'

function getDefaultLocale() {
  const saved = localStorage.getItem('tenbox-locale')
  if (saved && ['zh-CN', 'en-US'].includes(saved)) return saved
  const nav = navigator.language || navigator.userLanguage || 'en'
  return nav.startsWith('zh') ? 'zh-CN' : 'en-US'
}

const i18n = createI18n({
  legacy: false,
  locale: getDefaultLocale(),
  fallbackLocale: 'en-US',
  messages: {
    'zh-CN': zhCN,
    'en-US': enUS,
  },
})

export default i18n
