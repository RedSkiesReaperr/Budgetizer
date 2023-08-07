// Composables
import {createRouter, createWebHistory} from 'vue-router'

const routes = [
  {
    path: '/budget',
    component: () => import('@/layouts/budget/Default.vue'),
    children: [
      {
        path: 'overview',
        name: 'Overview',
        component: () => import('@/views/budget/Overview.vue')
      },
      {
        path: 'earnings',
        name: 'Earnings',
        component: () => import('@/views/budget/Earnings.vue')
      },
      {
        path: 'expenses',
        name: 'Expenses',
        component: () => import('@/views/budget/Expenses.vue')
      },
    ]
  }
]

const router = createRouter({
  history: createWebHistory(process.env.BASE_URL),
  routes,
})

export default router
