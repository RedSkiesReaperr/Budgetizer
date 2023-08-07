<script setup lang="ts">
import {useBudgetLayoutStore} from "@/stores/budgetLayout";

const store = useBudgetLayoutStore()
</script>

<template>
  <v-navigation-drawer expand-on-hover :rail="store.isRailMode"
                       @update:rail="e => store.invertIsExpanded(!e)">
    <v-list>
      <v-list-item
        title="Budgetizer"
        prepend-icon="mdi-piggy-bank-outline"
      ></v-list-item>
    </v-list>

    <!--    <v-divider></v-divider>-->
    <v-list density="compact" nav>
      <v-list-subheader v-if="store.isRailMode && !store.isExpanded">
        <v-icon icon="mdi-dots-horizontal"/>
      </v-list-subheader>
      <v-list-subheader v-else>{{ $t('budget.sidebar.general') }}</v-list-subheader>

      <v-list-item
        v-for="(link, i) in generalLinks"
        :key="i"
        :prepend-icon="link.icon"
        :title="link.title"
        :to="link.route"
      />
    </v-list>
  </v-navigation-drawer>

  <v-app-bar flat color="background">
    <v-app-bar-nav-icon @click="e => store.invertIsRailMode()" elevation="0"></v-app-bar-nav-icon>
    <!--    <v-toolbar-title>Budgetizer</v-toolbar-title>-->
    <!--    <v-spacer></v-spacer>-->
    <!--    <v-btn icon>-->
    <!--      <v-icon>mdi-export</v-icon>-->
    <!--    </v-btn>-->
  </v-app-bar>

  <v-main>
    <router-view/>
  </v-main>
</template>

<script lang="ts">
export default {
  data() {
    return {
      generalLinks: [
        {
          title: this.$t('overview'),
          icon: 'mdi-all-inclusive',
          route: 'overview'
        },
        {title: this.$tc('earning', 2), icon: 'mdi-bank-transfer-in', route: 'earnings'},
        {title: this.$tc('expense', 2), icon: 'mdi-bank-transfer-out', route: 'expenses'},
      ]
    }
  },
  methods: {}
}
</script>
