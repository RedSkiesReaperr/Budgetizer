import {createI18n} from 'vue-i18n'
import messages from '@/i18n/locales'

const i18n = createI18n({
  legacy: false,
  locale: 'fr',
  default: 'fr',
  fallbackLocale: 'en',
  messages
})

export default i18n
