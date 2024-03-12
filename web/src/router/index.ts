// Composables
import {createRouter, createWebHistory, RouteLocationNormalized} from "vue-router";
import api from "@/api";

const UNAUTHENTICATED_ROUTES = ['root', 'login', 'any']

const router = createRouter({
  history: createWebHistory(process.env.BASE_URL),
  routes: [
    {
      path: "/",
      name: "root",
      redirect: { name: "login" },
    },
    {
      path: "/login",
      name: "login",
      component: () => import("@/views/Login.vue"),
    },
    {
      path: "/dashboard",
      name: "dashboardBase",
      component: () => import("@/layouts/Dashboard.vue"),
      children: [
        {
          path: "overview",
          name: "dashboardOverview",
          component: () => import("@/views/dashboard/Overview.vue"),
          meta: { titleKey: "overview", pluralized: false },
        },
        {
          path: "forecast",
          name: "dashboardForecast",
          component: () => import("@/views/dashboard/Forecasts.vue"),
          meta: { titleKey: "forecast", pluralized: true },
        },
        {
          path: "earnings",
          name: "dashboardEarnings",
          component: () => import("@/views/dashboard/Earnings.vue"),
          meta: { titleKey: "earning", pluralized: true },
        },
        {
          path: "expenses",
          name: "dashboardExpenses",
          component: () => import("@/views/dashboard/Expenses.vue"),
          meta: { titleKey: "expense", pluralized: true },
        },
        {
          path: "categories",
          name: "dashboardCategories",
          component: () => import("@/views/dashboard/Categories.vue"),
          meta: { titleKey: "category", pluralized: true },
        }
      ],
    },
    {
      path: '/:pathMatch(.*)*',
      name: 'any',
      component: () => import("@/views/errors/404.vue"),
    },
  ],
});

router.beforeEach(async (to: RouteLocationNormalized) => {
  if (to.name && !UNAUTHENTICATED_ROUTES.includes(to.name.toString())) {
    try {
      await api.auth.validateSession()
    } catch (e) {
      if (to.name !== "login") {
        return {name: 'login'}
      }
    }
  }
})

export default router;
