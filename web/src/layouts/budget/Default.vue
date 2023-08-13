<script setup lang="ts">
import { useBudgetLayoutStore } from "@/stores/budgetLayout";
import LanguageSwitch from "@/components/LanguageSwitch.vue";

const store = useBudgetLayoutStore();
</script>

<template>
  <v-navigation-drawer
    floating
    location="left"
    elevation="0"
    expand-on-hover
    :rail="store.isRailMode"
    @update:rail="(_) => store.invertIsExpanded()"
  >
    <v-list>
      <v-list-item
        title="Budgetizer"
        prepend-icon="mdi-piggy-bank-outline"
      ></v-list-item>
    </v-list>

    <v-list density="compact" nav>
      <v-list-subheader v-if="store.isRailMode && !store.isExpanded">
        <v-icon icon="mdi-dots-horizontal" />
      </v-list-subheader>
      <v-list-subheader v-else>{{
        $t("budget.sidebar.general")
      }}</v-list-subheader>

      <v-list-item
        prepend-icon="mdi-all-inclusive"
        :title="$t('overview')"
        to="overview"
      />
      <v-list-item
        prepend-icon="mdi-bank-transfer-in"
        :title="$t('earning', 2)"
        to="earnings"
      />
      <v-list-item
        prepend-icon="mdi-bank-transfer-out"
        :title="$t('expense', 2)"
        to="expenses"
      />
    </v-list>
  </v-navigation-drawer>

  <v-app-bar flat color="background">
    <v-app-bar-nav-icon
      @click="(_) => store.invertIsRailMode()"
      elevation="0"
    ></v-app-bar-nav-icon>
    <v-spacer></v-spacer>
    <LanguageSwitch />
  </v-app-bar>

  <v-main>
    <div class="px-6 pb-6">
      <h5 class="text-h5 mb-6">{{ translatedTitle }}</h5>
      <router-view />
    </div>
  </v-main>
</template>

<script lang="ts">
export default {
  computed: {
    translatedTitle(): string {
      const count = this.$route.meta.pluralized === true ? 2 : 1;

      return this.$t(this.$route.meta.titleKey as string, count);
    },
  },
};
</script>
