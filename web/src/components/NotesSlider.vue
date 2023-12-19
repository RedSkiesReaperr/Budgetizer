<script lang="ts" setup>
import {Note} from "@/api/resources/notes";
import BasicCard from "@/components/BasicCard.vue";

interface Props {
  notes: Note[];
  loading: Boolean;
}

const props = defineProps<Props>();
</script>

<template>
  <v-slide-group
    class="pa-0"
    show-arrows
  >
    <template v-if="loading">
      <v-slide-group-item
        v-for="n in 5"
        :key="n"
      >
        <v-card
          class="ma-4"
          height="200"
          width="25%"
          elevation="0"
        >
          <v-skeleton-loader :elevation="0" type="card"></v-skeleton-loader>
        </v-card>
      </v-slide-group-item>
    </template>

    <template v-else-if="!loading && notes.length <= 0">
      <v-slide-group-item>
        <v-card
          class="ma-4"
          height="200"
          width="25%"
        >
          <BasicCard :loading="false">
            <p class="text-body-1 text-center">{{ $t('no_note')}}</p>
          </BasicCard>
        </v-card>
      </v-slide-group-item>
    </template>

    <template v-else>
      <v-slide-group-item
        v-for="n in props.notes"
        :key="n.id"
      >
        <v-card
          class="ma-4"
          height="200"
          width="25%"
          @click="handleEdit"
        >
          <v-container>
            <p class="text-h6 mb-1">{{ n.attributes.title }}</p>
            <v-divider class="text-h6 mb-2"></v-divider>
            <p class="text-body-1">{{ n.attributes.description }}</p>
          </v-container>
        </v-card>
      </v-slide-group-item>

    </template>
  </v-slide-group>

</template>

<script lang="ts">
export default {
  methods: {
    handleEdit: (target: any) => {
      console.log(target)
    }
  }
}
</script>
