<script setup lang="ts">
</script>

<template>
  <v-btn icon @click="overlay = !overlay">
    <v-avatar size="24px">
      <v-img alt="Language" :src="currentLocaleFlagPath" cover/>
    </v-avatar>
    <v-menu activator="parent" localtion="bottom" :close-on-content-click="true">
      <v-card class="pa-2" width="200">
        <v-list>
          <v-list-item
            v-for="(item, i) in locales"
            :key="i"
            :value="item.val"
            color="primary"
            rounded="xl"
            @click="_ => changeLocale(item.val)"
          >
            <template v-slot:prepend>
              <v-avatar size="24px">
                <v-img alt="Language" :src="localeFlagPath(item.val)" cover/>
              </v-avatar>
            </template>

            <v-list-item-title v-text="item.title"></v-list-item-title>
          </v-list-item>
        </v-list>
      </v-card>
    </v-menu>
  </v-btn>
</template>

<script lang="ts">

export default {
  data: () => ({
    overlay: false
  }),
  computed: {
    currentLocaleFlagPath() {
      return this.localeFlagPath(this.$i18n.locale)
    },
    locales() {
      return this.$i18n.availableLocales.map(local => {
        return {title: this.$t(`locales.${local}`), val: local}
      });
    }
  },
  methods: {
    localeFlagPath(locale: string): string {
      return `/src/assets/${locale}.svg`
    },
    changeLocale(newLocale: string) {
      if (newLocale !== this.$i18n.locale) {
        this.$i18n.locale = newLocale
      }
    }
  },
}
</script>
