<template>
  <v-container class="w-25">
    <BasicCard :loading="false">
      404 Not found !
    </BasicCard>
  </v-container>
</template>

<style>
</style>

<script lang="ts">
import BasicCard from '@/components/BasicCard.vue';

export default {
  components: { BasicCard }
};
</script>
