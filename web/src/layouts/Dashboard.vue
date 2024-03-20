<script setup lang="ts">
import {useDashboardLayoutStore} from "@/stores/dashboardLayout";
import LanguageSwitch from "@/components/LanguageSwitch.vue";

const dashboardLayoutStore = useDashboardLayoutStore();
</script>

<template>
  <v-navigation-drawer floating location="left" elevation="0" expand-on-hover :rail="dashboardLayoutStore.isRailMode"
                       @update:rail="(_) => dashboardLayoutStore.invertIsExpanded()">
    <v-list>
      <v-list-item title="Budgetizer" prepend-icon="mdi-piggy-bank-outline"></v-list-item>
    </v-list>

    <v-list density="compact" nav>
      <v-list-subheader v-if="dashboardLayoutStore.isRailMode && !dashboardLayoutStore.isExpanded">
        <v-icon icon="mdi-dots-horizontal"/>
      </v-list-subheader>
      <v-list-subheader v-else>{{
          $t("dashboard.sidebar.general")
        }}
      </v-list-subheader>

      <v-list-item prepend-icon="mdi-all-inclusive" :title="$t('overview')" :to="{name: 'dashboardOverview'}"/>
      <v-list-item prepend-icon="mdi-weather-partly-cloudy" :title="$t('forecast', 2)"
                   :to="{name: 'dashboardForecast'}"/>
      <v-list-item prepend-icon="mdi-bank-transfer-in" :title="$t('earning', 2)" :to="{name: 'dashboardEarnings'}"/>
      <v-list-item prepend-icon="mdi-bank-transfer-out" :title="$t('expense', 2)" :to="{name: 'dashboardExpenses'}"/>
      <v-list-item prepend-icon="mdi-shape-plus" :title="$t('category', 2)" :to="{name: 'dashboardCategories'}"/>
    </v-list>
  </v-navigation-drawer>

  <v-app-bar flat color="background">
    <v-app-bar-nav-icon @click="dashboardLayoutStore.invertIsRailMode" elevation="0"></v-app-bar-nav-icon>
    <v-spacer></v-spacer>

    <div class="w6">
      <VueDatePicker v-model="selectedDate" month-picker required :clearable="false" month-name-format="short"
                     @update:model-value="onDateChanged" :locale="$i18n.locale" :select-text="$t('actions.select')"
                     :cancel-text="$t('actions.cancel')"></VueDatePicker>
    </div>
    <v-spacer></v-spacer>

    <LanguageSwitch/>

    <v-tooltip :text="$t('dashboard.appbar.logout')" location="bottom">
      <template v-slot:activator="{ props }">
        <v-btn v-bind="props" icon="mdi-logout" @click="logout"></v-btn>
      </template>
    </v-tooltip>

  </v-app-bar>

  <v-main>
    <div class="px-6 pb-6">
      <h5 class="text-h5 mb-6">{{ translatedTitle }}</h5>
      <router-view/>
    </div>
  </v-main>
</template>

<style>
header.v-toolbar {
  overflow: visible !important;
}
</style>
<script lang="ts">
import {useAppStore} from "@/stores/app";

const appStore = useAppStore();

export default {
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
    logout() {
      appStore.logout().finally(() => this.$router.push({name: 'login'}))
    }
  },
};
</script>
