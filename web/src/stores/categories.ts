import api from "@/api";
import {Category} from "@/api/resources/categories";
import {defineStore} from "pinia";

export const useCategoriesStore = defineStore("categories", {
    state: () => ({
      categories: [] as Category[],
      fetching: false,
    }),
    getters: {
      expenseCategories: (state => state.categories.filter((cat: Category) => cat.attributes.key != "salary")),
    },
    actions:
      {
        async fetchAll() {
          this.fetching = true;

          api.categories.getAll()
            .then((res: Category[]) => this.categories = res)
            .finally(() => this.fetching = false)
        }
        ,
      }
    ,
  })
;
