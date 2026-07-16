<script setup>
import {
  ref,
  watch
} from 'vue'

import {
  Plus,
  Search
} from '@element-plus/icons-vue'

const search = ref('')
const category = ref('All')
const sort = ref('newest')

const emit = defineEmits([
  'add-expense',
  'filter-change'
])

const categories = [
  'All',
  'Food',
  'Transport',
  'Shopping',
  'Housing',
  'Health',
  'Education',
  'Entertainment',
  'Other'
]

watch(
  [search, category, sort],
  () => {
    emit('filter-change', {
      search: search.value,
      category: category.value,
      sort: sort.value
    })
  }
)
</script>

<template>
  <div class="filters-card">
    <div class="filters">
      <el-input
        v-model="search"
        placeholder="Search expenses..."
        clearable
        class="search-input"
      >
        <template #prefix>
          <el-icon>
            <Search />
          </el-icon>
        </template>
      </el-input>

      <el-select
        v-model="category"
        placeholder="Category"
        class="select"
      >
        <el-option
          v-for="item in categories"
          :key="item"
          :label="item"
          :value="item"
        />
      </el-select>

      <el-select
        v-model="sort"
        class="select"
      >
        <el-option
          label="Newest"
          value="newest"
        />

        <el-option
          label="Oldest"
          value="oldest"
        />

        <el-option
          label="Highest Amount"
          value="highest"
        />

        <el-option
          label="Lowest Amount"
          value="lowest"
        />
      </el-select>

      <el-button
        type="primary"
        size="large"
        @click="emit('add-expense')"
      >
        <el-icon class="button-icon">
          <Plus />
        </el-icon>

        Add Expense
      </el-button>
    </div>
  </div>
</template>

<style scoped>
.filters-card {
  padding: 16px;
  border-radius: 18px;
  background: white;
  box-shadow: 0 10px 30px
    rgba(15, 23, 42, 0.06);
}

.filters {
  display: flex;
  flex-wrap: wrap;
  align-items: center;
  gap: 12px;
}

.search-input {
  min-width: 260px;
  flex: 1;
}

.select {
  width: 180px;
}

.button-icon {
  margin-right: 6px;
}
</style>