// Composables
import { createRouter, createWebHistory } from "vue-router";
import routes from "./routes";

const router = createRouter({
  history: createWebHistory(process.env.BASE_URL),
  routes: [
    {
      path: "/",
      redirect: { path: routes.login },
    },
    {
      path: routes.login,
      component: () => import("@/views/Login.vue"),
    },
    {
      path: routes.selector,
      component: () => import("@/views/BudgetSelector.vue"),
    },
    {
      path: routes.budget.base,
      component: () => import("@/layouts/budget/Default.vue"),
      children: [
        {
          path: "overview",
          name: "Overview",
          component: () => import("@/views/budget/Overview.vue"),
          meta: { titleKey: "overview", pluralized: false },
        },
        {
          path: "forecasts",
          name: "Forecasts",
          component: () => import("@/views/budget/Forecasts.vue"),
          meta: { titleKey: "forecast", pluralized: true },
        },
        {
          path: "earnings",
          name: "Earnings",
          component: () => import("@/views/budget/Earnings.vue"),
          meta: { titleKey: "earning", pluralized: true },
        },
        {
          path: "expenses",
          name: "Expenses",
          component: () => import("@/views/budget/Expenses.vue"),
          meta: { titleKey: "expense", pluralized: true },
        },
      ],
    },
  ],
});

export default router;
