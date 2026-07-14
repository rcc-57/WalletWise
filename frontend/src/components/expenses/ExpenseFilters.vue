<script setup>
import { ref, watch } from 'vue'

const search = ref('')
const category = ref('All')
const sort = ref('newest')

const emit = defineEmits(['add-expense', 'filter-change'])

const categories = [
  'All',
  'Food',
  'Transport',
  'Shopping',
  'Entertainment',
  'Health'
]

watch([search, category, sort], () => {
  emit('filter-change', {
    search: search.value,
    category: category.value,
    sort: sort.value
  })
})
</script>

<template>
  <div class="filters">
    <el-input
      v-model="search"
      placeholder="Search expenses..."
      clearable
      class="search-input"
    />
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
      <el-option label="Newest" value="newest" />
      <el-option label="Oldest" value="oldest" />
      <el-option label="Highest Amount" value="highest" />
      <el-option label="Lowest Amount" value="lowest" />
    </el-select>
    <el-button type="primary" size="large" @click="emit('add-expense')">
      + Add Expense
    </el-button>
  </div>
</template>

<style scoped>
.filters {
  display: flex;
  gap: 16px;
  align-items: center;
  margin-bottom: 24px;
  flex-wrap: wrap;
}
.search-input {
  flex: 1;
  min-width: 260px;
}
.select {
  width: 180px;
}
</style>