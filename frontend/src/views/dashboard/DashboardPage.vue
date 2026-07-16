<script setup>
import {
  computed,
  onMounted,
  ref
} from 'vue'

import { ElMessage } from 'element-plus'

import BalanceCard from '@/components/dashboard/cards/BalanceCard.vue'
import IncomeCard from '@/components/dashboard/cards/IncomeCard.vue'
import ExpenseCard from '@/components/dashboard/cards/ExpenseCard.vue'
import SavingsCard from '@/components/dashboard/cards/SavingsCard.vue'

import MonthlyCashFlowChart from '@/components/analytics/MonthlyCashFlowChart.vue'
import CategoryExpenseChart from '@/components/dashboard/charts/CategoryExpenseChart.vue'
import RecentTransactions from '@/components/dashboard/transactions/RecentTransactions.vue'

import { useAnalyticsStore } from '@/stores/analytics'
import { getBills } from '@/api/bills'

const analyticsStore = useAnalyticsStore()

const bills = ref([])
const billsLoading = ref(false)
const error = ref('')

const currentDate = new Date()
const currentYear = currentDate.getFullYear()
const currentMonth = currentDate.getMonth() + 1

const statistics = computed(
  () => analyticsStore.monthlyStats
)

const loading = computed(() => {
  return (
    analyticsStore.loading ||
    billsLoading.value
  )
})

const savingsRate = computed(() => {
  const income = statistics.value?.totalIncome || 0
  const balance = statistics.value?.balance || 0

  if (income <= 0) {
    return 0
  }

  return Math.round((balance / income) * 100)
})

const dashboardCards = computed(() => [
  {
    title: 'Current Balance',
    value: formatCurrency(
      statistics.value?.balance || 0
    ),
    change: 'Balance for the current month'
  },
  {
    title: 'Monthly Income',
    value: formatCurrency(
      statistics.value?.totalIncome || 0
    ),
    change: 'Total income received'
  },
  {
    title: 'Monthly Expenses',
    value: formatCurrency(
      statistics.value?.totalExpense || 0
    ),
    change: 'Total outgoing expenses'
  },
  {
    title: 'Savings Rate',
    value: `${savingsRate.value}%`,
    change: 'Balance as a share of income'
  }
])

const monthlyCashFlowData = computed(() => ({
  labels: [
    statistics.value?.month ||
      `${currentYear}-${String(
        currentMonth
      ).padStart(2, '0')}`
  ],
  income: [
    Number(statistics.value?.totalIncome || 0)
  ],
  expenses: [
    Number(statistics.value?.totalExpense || 0)
  ]
}))

const categoryExpenseData = computed(() => ({
  labels:
    statistics.value?.expenseCategories.map(
      (item) => formatCategory(item.category)
    ) || [],
  values:
    statistics.value?.expenseCategories.map(
      (item) => Number(item.amount)
    ) || []
}))

const hasCategoryData = computed(() => {
  return categoryExpenseData.value.values.some(
    (value) => Number(value) > 0
  )
})

const recentTransactions = computed(() => {
  return bills.value
    .slice(0, 5)
    .map((bill) => {
      const isIncome = bill.type === 'INCOME'
      const amount = formatCurrency(bill.amount)

      return {
        id: bill.id,
        date: bill.billDate,
        description:
          bill.remark ||
          (isIncome ? 'Income' : 'Expense'),
        category: formatCategory(bill.category),
        amount: isIncome
          ? `+${amount}`
          : `-${amount}`,
        type: isIncome ? 'income' : 'expense'
      }
    })
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

async function loadDashboard() {
  billsLoading.value = true
  error.value = ''

  try {
    const [, loadedBills] = await Promise.all([
      analyticsStore.fetchMonthlyStatistics(
        currentYear,
        currentMonth
      ),
      getBills()
    ])

    bills.value = loadedBills
  } catch (requestError) {
    error.value =
      requestError.response?.data?.message ||
      analyticsStore.error ||
      'Unable to load dashboard data.'

    ElMessage.error(error.value)
  } finally {
    billsLoading.value = false
  }
}

onMounted(() => {
  loadDashboard()
})
</script>

<template>
  <div
    class="dashboard"
    v-loading="loading"
  >
    <div class="page-header">
      <div>
        <h1>Dashboard</h1>
        <p>
          Current monthly financial overview
        </p>
      </div>

      <el-button
        :loading="loading"
        @click="loadDashboard"
      >
        Refresh
      </el-button>
    </div>

    <el-alert
      v-if="error"
      :title="error"
      type="error"
      show-icon
      :closable="false"
    />

    <template v-if="statistics">
      <div class="cards-grid">
        <BalanceCard
          :data="dashboardCards[0]"
        />

        <IncomeCard
          :data="dashboardCards[1]"
        />

        <ExpenseCard
          :data="dashboardCards[2]"
        />

        <SavingsCard
          :data="dashboardCards[3]"
        />
      </div>

      <div class="charts-grid">
        <div class="chart-box">
          <h2>Monthly Cash Flow</h2>

          <MonthlyCashFlowChart
            :key="`cash-${chartKey}`"
            :data="monthlyCashFlowData"
          />
        </div>

        <div class="chart-box">
          <h2>Expenses by Category</h2>

          <CategoryExpenseChart
            v-if="hasCategoryData"
            :key="`categories-${chartKey}`"
            :data="categoryExpenseData"
          />

          <el-empty
            v-else
            description="No expenses this month"
          />
        </div>
      </div>
    </template>

    <RecentTransactions
      :transactions="recentTransactions"
    />
  </div>
</template>

<style scoped>
.dashboard {
  width: 100%;
}

.page-header {
  display: flex;
  margin-bottom: 28px;
  justify-content: space-between;
  align-items: center;
}

.page-header h1 {
  margin: 0 0 6px;
  color: #111827;
  font-size: 36px;
}

.page-header p {
  margin: 0;
  color: #64748b;
  font-size: 14px;
}

.cards-grid {
  display: grid;
  grid-template-columns: repeat(
    4,
    minmax(0, 1fr)
  );
  gap: 24px;
  margin: 28px 0 35px;
}

.charts-grid {
  display: grid;
  grid-template-columns: repeat(
    2,
    minmax(0, 1fr)
  );
  gap: 24px;
  margin-bottom: 35px;
}

.chart-box {
  min-height: 360px;
  padding: 25px;
  border-radius: 20px;
  background: white;
  box-shadow: 0 10px 25px
    rgba(0, 0, 0, 0.05);
}

.chart-box h2 {
  margin: 0 0 20px;
  font-size: 22px;
}

@media (max-width: 1200px) {
  .cards-grid {
    grid-template-columns: repeat(
      2,
      minmax(0, 1fr)
    );
  }
}

@media (max-width: 800px) {
  .cards-grid,
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