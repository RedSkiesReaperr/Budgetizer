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
      path: "/selector",
      name: "budgetSelector",
      component: () => import("@/views/BudgetSelector.vue"),
    },
    {
      path: "/dashboard",
      name: "dashboardBase",
      component: () => import("@/layouts/Dashboard.vue"),
      children: [
        {
          path: "overview",
          name: "dashboardOverview",
          component: () => import("@/views/budget/Overview.vue"),
          meta: { titleKey: "overview", pluralized: false },
        },
        {
          path: "forecast",
          name: "dashboardForecast",
          component: () => import("@/views/budget/Forecasts.vue"),
          meta: { titleKey: "forecast", pluralized: true },
        },
        {
          path: "earnings",
          name: "dashboardEarnings",
          component: () => import("@/views/budget/Earnings.vue"),
          meta: { titleKey: "earning", pluralized: true },
        },
        {
          path: "expenses",
          name: "dashboardExpenses",
          component: () => import("@/views/budget/Expenses.vue"),
          meta: { titleKey: "expense", pluralized: true },
        },
        {
          path: "categories",
          name: "dashboardCategories",
          component: () => import("@/views/budget/Categories.vue"),
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
