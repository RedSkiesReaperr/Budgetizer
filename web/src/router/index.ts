// Composables
import {createRouter, createWebHistory} from 'vue-router'
import i18n from "@/plugins/vue-i18n";

const routes = [
  {
    path: '/budget',
    component: () => import('@/layouts/budget/Default.vue'),
    children: [
      {
        path: 'overview',
        name: 'Overview',
        component: () => import('@/views/budget/Overview.vue'),
        meta: {title: i18n.global.t('overview')}
      },
      {
        path: 'earnings',
        name: 'Earnings',
        component: () => import('@/views/budget/Earnings.vue'),
        meta: {title: i18n.global.t('earning', 2)}
      },
      {
        path: 'expenses',
        name: 'Expenses',
        component: () => import('@/views/budget/Expenses.vue'),
        meta: {title: i18n.global.t('expense', 2)}
      },
    ]
  }
]

const router = createRouter({
  history: createWebHistory(process.env.BASE_URL),
  routes,
})

export default router
