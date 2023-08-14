// Composables
import { createRouter, createWebHistory } from "vue-router";

const routes = [
  {
    path: "/",
    redirect: { path: "/selector" },
  },
  {
    path: "/selector",
    component: () => import("@/views/BudgetSelector.vue"),
  },
  {
    path: "/budget",
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
];

const router = createRouter({
  history: createWebHistory(process.env.BASE_URL),
  routes,
});

export default router;
