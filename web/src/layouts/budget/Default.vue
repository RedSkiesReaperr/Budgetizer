<script setup lang="ts">
import { useBudgetLayoutStore } from "@/stores/budgetLayout";
import LanguageSwitch from "@/components/LanguageSwitch.vue";
import routes from "@/router/routes";

const budgetLayoutStore = useBudgetLayoutStore();
</script>

<template>
  <v-navigation-drawer
    floating
    location="left"
    elevation="0"
    expand-on-hover
    :rail="budgetLayoutStore.isRailMode"
    @update:rail="(_) => budgetLayoutStore.invertIsExpanded()"
  >
    <v-list>
      <v-list-item
        title="Budgetizer"
        prepend-icon="mdi-piggy-bank-outline"
      ></v-list-item>
    </v-list>

    <v-list density="compact" nav>
      <v-list-subheader
        v-if="budgetLayoutStore.isRailMode && !budgetLayoutStore.isExpanded"
      >
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
        prepend-icon="mdi-weather-partly-cloudy"
        :title="$t('forecast', 2)"
        to="forecasts"
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
      @click="(_) => budgetLayoutStore.invertIsRailMode()"
      elevation="0"
    ></v-app-bar-nav-icon>
    <v-spacer></v-spacer>

    <div class="w6">
      <VueDatePicker
        v-model="selectedDate"
        month-picker
        required
        :clearable="false"
        month-name-format="short"
        @update:model-value="onDateChanged"
        :locale="$i18n.locale"
        :select-text="$t('actions.select')"
        :cancel-text="$t('actions.cancel')"
      ></VueDatePicker>
    </div>
    <v-spacer></v-spacer>

    <v-tooltip :text="$t('budget.appbar.change_budget')" location="bottom">
      <template v-slot:activator="{ props }">
        <v-btn
          :to="routes.selector"
          v-bind="props"
          icon="mdi-swap-horizontal"
        ></v-btn>
      </template>
    </v-tooltip>

    <LanguageSwitch />
  </v-app-bar>

  <v-main>
    <div class="px-6 pb-6">
      <h5 class="text-h5 mb-6">{{ translatedTitle }}</h5>
      <router-view />
    </div>
  </v-main>
</template>

<style>
header.v-toolbar {
  overflow: visible !important;
}
</style>
<script lang="ts">
import { useAppStore } from "@/stores/app";

const appStore = useAppStore();

export default {
  beforeCreate() {
    if (Object.keys(appStore.currentBudget).length <= 0) {
      this.$router.push(routes.selector);
    }
  },
  data: () => ({
    selectedDate: {
      month: appStore.currentDateStartAt.month(),
      year: appStore.currentDateEndAt.year(),
    },
  }),
  computed: {
    translatedTitle(): string {
      const count = this.$route.meta.pluralized === true ? 2 : 1;

      return this.$t(this.$route.meta.titleKey as string, count);
    },
  },
  methods: {
    onDateChanged: (modelDate: { month: any; year: any }) => {
      appStore.selectDate(modelDate.month, modelDate.year);
    },
  },
};
</script>
