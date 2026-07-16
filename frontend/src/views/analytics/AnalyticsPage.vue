<script setup>
import {
  computed,
  onMounted,
  ref
} from 'vue'

import { ElMessage } from 'element-plus'

import MonthlyCashFlowChart from '@/components/analytics/MonthlyCashFlowChart.vue'
import CategoryBreakdownChart from '@/components/analytics/CategoryBreakdownChart.vue'

import { useAnalyticsStore } from '@/stores/analytics'

const analyticsStore = useAnalyticsStore()

const currentDate = new Date()

const selectedYear = ref(currentDate.getFullYear())
const selectedMonth = ref(currentDate.getMonth() + 1)

const months = [
  { label: 'January', value: 1 },
  { label: 'February', value: 2 },
  { label: 'March', value: 3 },
  { label: 'April', value: 4 },
  { label: 'May', value: 5 },
  { label: 'June', value: 6 },
  { label: 'July', value: 7 },
  { label: 'August', value: 8 },
  { label: 'September', value: 9 },
  { label: 'October', value: 10 },
  { label: 'November', value: 11 },
  { label: 'December', value: 12 }
]

const availableYears = computed(() => {
  const currentYear = currentDate.getFullYear()

  return Array.from(
    { length: 5 },
    (_, index) => currentYear - index
  )
})

const statistics = computed(
  () => analyticsStore.monthlyStats
)

const selectedMonthLabel = computed(() => {
  const month = months.find(
    (item) => item.value === selectedMonth.value
  )

  return month?.label || ''
})

const savingsRate = computed(() => {
  const income = statistics.value?.totalIncome || 0
  const balance = statistics.value?.balance || 0

  if (income <= 0) {
    return 0
  }

  return Math.round((balance / income) * 100)
})

const savingsProgress = computed(() => {
  return Math.min(
    100,
    Math.max(0, savingsRate.value)
  )
})

const summaryCards = computed(() => {
  const data = statistics.value

  return [
    {
      title: 'Monthly Income',
      value: formatCurrency(data?.totalIncome || 0),
      subtitle: `${selectedMonthLabel.value} ${selectedYear.value}`
    },
    {
      title: 'Monthly Expenses',
      value: formatCurrency(data?.totalExpense || 0),
      subtitle: `${selectedMonthLabel.value} ${selectedYear.value}`
    },
    {
      title: 'Monthly Balance',
      value: formatCurrency(data?.balance || 0),
      subtitle:
        Number(data?.balance || 0) >= 0
          ? 'Positive balance'
          : 'Expenses exceed income'
    },
    {
      title: 'Savings Rate',
      value: `${savingsRate.value}%`,
      subtitle: 'Balance as a share of income'
    }
  ]
})

const monthlyCashFlowData = computed(() => ({
  labels: [
    statistics.value?.month ||
      `${selectedYear.value}-${String(
        selectedMonth.value
      ).padStart(2, '0')}`
  ],
  income: [
    Number(statistics.value?.totalIncome || 0)
  ],
  expenses: [
    Number(statistics.value?.totalExpense || 0)
  ]
}))

const categoryChartData = computed(() => ({
  labels:
    statistics.value?.expenseCategories.map(
      (item) => formatCategory(item.category)
    ) || [],
  values:
    statistics.value?.expenseCategories.map(
      (item) => Number(item.amount)
    ) || []
}))

const topCategories = computed(() => {
  return [
    ...(statistics.value?.expenseCategories || [])
  ]
    .sort(
      (first, second) =>
        Number(second.amount) - Number(first.amount)
    )
    .map((item) => ({
      category: formatCategory(item.category),
      value: formatCurrency(item.amount)
    }))
})

const hasCategoryData = computed(() => {
  return categoryChartData.value.values.some(
    (value) => Number(value) > 0
  )
})

const chartKey = computed(() => {
  const categories =
    statistics.value?.expenseCategories
      .map((item) => `${item.category}-${item.amount}`)
      .join('-') || 'empty'

  return `${statistics.value?.month || 'month'}-${categories}`
})

function formatCurrency(value) {
  return new Intl.NumberFormat('en-US', {
    style: 'currency',
    currency: 'USD'
  }).format(Number(value || 0))
}

function formatCategory(category) {
  if (!category) {
    return ''
  }

  return category
    .toLowerCase()
    .replace(/_/g, ' ')
    .replace(/\b\w/g, (letter) =>
      letter.toUpperCase()
    )
}

async function loadStatistics() {
  try {
    await analyticsStore.fetchMonthlyStatistics(
      selectedYear.value,
      selectedMonth.value
    )
  } catch {
    ElMessage.error(
      analyticsStore.error ||
        'Unable to load financial statistics.'
    )
  }
}

onMounted(() => {
  loadStatistics()
})
</script>

<template>
  <div class="analytics-page">
    <div class="page-header">
      <div>
        <h1>Analytics</h1>
        <p>
          Review monthly income, spending and balance
        </p>
      </div>

      <el-button
        type="primary"
        :loading="analyticsStore.loading"
        @click="loadStatistics"
      >
        Refresh
      </el-button>
    </div>

    <div class="filters-bar">
      <el-select
        v-model="selectedYear"
        placeholder="Year"
        style="width: 140px"
        @change="loadStatistics"
      >
        <el-option
          v-for="year in availableYears"
          :key="year"
          :label="String(year)"
          :value="year"
        />
      </el-select>

      <el-select
        v-model="selectedMonth"
        placeholder="Month"
        style="width: 180px"
        @change="loadStatistics"
      >
        <el-option
          v-for="month in months"
          :key="month.value"
          :label="month.label"
          :value="month.value"
        />
      </el-select>
    </div>

    <el-alert
      v-if="analyticsStore.error"
      :title="analyticsStore.error"
      type="error"
      show-icon
      :closable="false"
    />

    <div v-loading="analyticsStore.loading">
      <template v-if="statistics">
        <div class="summary-grid">
          <div
            v-for="card in summaryCards"
            :key="card.title"
            class="summary-card"
          >
            <h3>{{ card.title }}</h3>
            <p class="value">{{ card.value }}</p>
            <p class="subtitle">
              {{ card.subtitle }}
            </p>
          </div>
        </div>

        <div class="charts-grid">
          <div class="chart-box">
            <div class="chart-header">
              <div>
                <h2>Monthly Cash Flow</h2>
                <span>Income compared with expenses</span>
              </div>
            </div>

            <MonthlyCashFlowChart
              :key="`cash-${chartKey}`"
              :data="monthlyCashFlowData"
            />
          </div>

          <div class="chart-box">
            <div class="chart-header">
              <div>
                <h2>Expense Categories</h2>
                <span>Monthly spending distribution</span>
              </div>
            </div>

            <CategoryBreakdownChart
              v-if="hasCategoryData"
              :key="`categories-${chartKey}`"
              :data="categoryChartData"
            />

            <el-empty
              v-else
              description="No expenses for this month"
            />
          </div>

          <div class="chart-box">
            <div class="chart-header">
              <div>
                <h2>Top Spending Categories</h2>
                <span>Categories ordered by amount</span>
              </div>
            </div>

            <ul
              v-if="topCategories.length > 0"
              class="category-list"
            >
              <li
                v-for="item in topCategories"
                :key="item.category"
              >
                <span>{{ item.category }}</span>
                <strong>{{ item.value }}</strong>
              </li>
            </ul>

            <el-empty
              v-else
              description="No category data"
            />
          </div>

          <div class="chart-box">
            <div class="chart-header">
              <div>
                <h2>Savings Rate</h2>
                <span>
                  Monthly balance as a share of income
                </span>
              </div>
            </div>

            <div class="progress-block">
              <div class="progress-row">
                <span>Current rate</span>
                <strong>{{ savingsRate }}%</strong>
              </div>

              <el-progress
                :percentage="savingsProgress"
                :show-text="false"
                :status="
                  savingsRate < 0
                    ? 'exception'
                    : savingsRate >= 20
                      ? 'success'
                      : ''
                "
              />
            </div>
          </div>
        </div>
      </template>
    </div>
  </div>
</template>

<style scoped>
.analytics-page {
  display: flex;
  width: 100%;
  flex-direction: column;
  gap: 20px;
}

.page-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.page-header h1 {
  margin: 0 0 6px;
  color: #111827;
  font-size: 32px;
  font-weight: 700;
}

.page-header p {
  margin: 0;
  color: #64748b;
  font-size: 14px;
}

.filters-bar {
  display: flex;
  flex-wrap: wrap;
  gap: 12px;
  padding: 16px;
  border-radius: 18px;
  background: white;
  box-shadow: 0 10px 30px
    rgba(15, 23, 42, 0.06);
}

.summary-grid {
  display: grid;
  grid-template-columns: repeat(
    4,
    minmax(0, 1fr)
  );
  gap: 16px;
  margin-bottom: 20px;
}

.summary-card,
.chart-box {
  padding: 20px;
  border-radius: 18px;
  background: white;
  box-shadow: 0 10px 30px
    rgba(15, 23, 42, 0.06);
}

.summary-card h3 {
  margin: 0 0 8px;
  color: #64748b;
  font-size: 13px;
}

.summary-card .value {
  margin: 0;
  color: #111827;
  font-size: 24px;
  font-weight: 700;
}

.summary-card .subtitle {
  margin: 6px 0 0;
  color: #64748b;
  font-size: 13px;
}

.charts-grid {
  display: grid;
  grid-template-columns: repeat(
    2,
    minmax(0, 1fr)
  );
  gap: 16px;
}

.chart-box {
  min-height: 320px;
}

.chart-header {
  display: flex;
  justify-content: space-between;
  margin-bottom: 20px;
}

.chart-header h2 {
  margin: 0 0 5px;
  color: #111827;
  font-size: 18px;
}

.chart-header span {
  color: #64748b;
  font-size: 12px;
}

.category-list {
  display: flex;
  margin: 0;
  padding: 0;
  flex-direction: column;
  gap: 10px;
  list-style: none;
}

.category-list li {
  display: flex;
  justify-content: space-between;
  padding: 10px 0;
  border-bottom: 1px solid #e5e7eb;
}

.category-list li:last-child {
  border-bottom: none;
}

.progress-block {
  display: flex;
  flex-direction: column;
  gap: 12px;
}

.progress-row {
  display: flex;
  justify-content: space-between;
  color: #64748b;
}

@media (max-width: 1100px) {
  .summary-grid {
    grid-template-columns: repeat(
      2,
      minmax(0, 1fr)
    );
  }
}

@media (max-width: 800px) {
  .summary-grid,
  .charts-grid {
    grid-template-columns: 1fr;
  }

  .page-header {
    align-items: flex-start;
    flex-direction: column;
    gap: 12px;
  }
}
</style>
