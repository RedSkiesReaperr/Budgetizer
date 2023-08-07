<template>
  <v-toolbar prominent>
    <v-app-bar-nav-icon @click="drawer = !drawer"></v-app-bar-nav-icon>
    <!--    <v-toolbar-title>Budgetizer</v-toolbar-title>-->
    <v-spacer></v-spacer>
    <v-btn icon>
      <v-icon>mdi-export</v-icon>
    </v-btn>
  </v-toolbar>

  <v-navigation-drawer v-model="drawer">
    <v-list>
      <v-list-item
        title="Budgetizer"
        prepend-icon="mdi-piggy-bank-outline"
      ></v-list-item>
    </v-list>

    <!--    <v-divider></v-divider>-->

    <v-list density="compact" nav>
      <v-list-subheader>{{ $t('budget.sidebar.general') }}</v-list-subheader>
      <v-list-item
        v-for="(link, i) in generalLinks"
        :key="i"
        :prepend-icon="link.icon"
        :title="link.title"
        :to="link.route"
      />
    </v-list>
  </v-navigation-drawer>

  <v-main>
    <router-view/>
  </v-main>
</template>

<script lang="ts">
export default {
  data() {
    return {
      drawer: false,
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
}
</script>
