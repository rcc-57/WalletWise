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

import CategoryExpenseChart from '@/components/dashboard/charts/CategoryExpenseChart.vue'
import DailyCashFlowChart from '@/components/dashboard/charts/DailyCashFlowChart.vue'

import RecentTransactions from '@/components/dashboard/transactions/RecentTransactions.vue'

import { useAnalyticsStore } from '@/stores/analytics'
import { useAuthStore } from '@/stores/auth'

import { getBills } from '@/api/bills'

import {
  formatMoney
} from '@/utils/currency'

const analyticsStore = useAnalyticsStore()
const authStore = useAuthStore()

const bills = ref([])
const billsLoading = ref(false)
const error = ref('')

const currentDate = new Date()

const selectedYear = ref(
  currentDate.getFullYear()
)

const selectedMonth = ref(
  currentDate.getMonth() + 1
)

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
  const currentYear =
    currentDate.getFullYear()

  return Array.from(
    {
      length: 5
    },
    (_, index) =>
      currentYear - index
  )
})

const statistics = computed(() => {
  return analyticsStore.monthlyStats
})

const currency = computed(() => {
  return authStore.user?.currency || ''
})

const loading = computed(() => {
  return (
    analyticsStore.loading ||
    billsLoading.value
  )
})

const selectedMonthKey = computed(() => {
  return (
    `${selectedYear.value}-` +
    `${String(
      selectedMonth.value
    ).padStart(2, '0')}`
  )
})

const billsForSelectedMonth = computed(() => {
  return bills.value.filter((bill) => {
    return bill.billDate?.startsWith(
      selectedMonthKey.value
    )
  })
})

const savingsRate = computed(() => {
  const income =
    Number(
      statistics.value?.totalIncome || 0
    )

  const balance =
    Number(
      statistics.value?.balance || 0
    )

  if (income <= 0) {
    return 0
  }

  return Math.round(
    (balance / income) * 100
  )
})

const dashboardCards = computed(() => {
  return [
    {
      title: 'Available Balance',
      value: formatMoney(
        statistics.value?.balance || 0,
        currency.value
      ),
      change:
        'Money remaining after expenses'
    },
    {
      title: 'Income',
      value: formatMoney(
        statistics.value?.totalIncome || 0,
        currency.value
      ),
      change:
        'Pension, benefits and other income'
    },
    {
      title: 'Expenses',
      value: formatMoney(
        statistics.value?.totalExpense || 0,
        currency.value
      ),
      change:
        'Healthcare and everyday spending'
    },
    {
      title: 'Savings Rate',
      value: `${savingsRate.value}%`,
      change:
        'Share of income remaining'
    }
  ]
})

const categoryExpenseData = computed(() => {
  const categories =
    statistics.value
      ?.expenseCategories || []

  return {
    labels: categories.map(
      (item) =>
        formatCategory(
          item.category
        )
    ),

    values: categories.map(
      (item) =>
        Number(item.amount || 0)
    )
  }
})

const hasCategoryData = computed(() => {
  return categoryExpenseData
    .value
    .values
    .some(
      (value) =>
        Number(value) > 0
    )
})

const dailyCashFlowData = computed(() => {
  const daysInMonth = new Date(
    selectedYear.value,
    selectedMonth.value,
    0
  ).getDate()

  const labels = Array.from(
    {
      length: daysInMonth
    },
    (_, index) =>
      String(index + 1)
  )

  const income = Array(
    daysInMonth
  ).fill(0)

  const expenses = Array(
    daysInMonth
  ).fill(0)

  billsForSelectedMonth
    .value
    .forEach((bill) => {
      const dateParts =
        bill.billDate.split('-')

      const day =
        Number(dateParts[2]) - 1

      const amount =
        Number(bill.amount || 0)

      if (
        day < 0 ||
        day >= daysInMonth
      ) {
        return
      }

      if (bill.type === 'INCOME') {
        income[day] += amount
      }

      if (bill.type === 'EXPENSE') {
        expenses[day] += amount
      }
    })

  return {
    labels,
    income,
    expenses
  }
})

const hasDailyData = computed(() => {
  const incomeHasData =
    dailyCashFlowData
      .value
      .income
      .some(
        (value) => value > 0
      )

  const expensesHaveData =
    dailyCashFlowData
      .value
      .expenses
      .some(
        (value) => value > 0
      )

  return (
    incomeHasData ||
    expensesHaveData
  )
})

const recentTransactions = computed(() => {
  return bills.value
    .slice(0, 5)
    .map((bill) => {
      const isIncome =
        bill.type === 'INCOME'

      const formattedAmount =
        formatMoney(
          bill.amount,
          currency.value
        )

      return {
        id: bill.id,
        date: bill.billDate,

        description:
          bill.remark ||
          (
            isIncome
              ? 'Income'
              : 'Expense'
          ),

        category:
          formatCategory(
            bill.category
          ),

        amount:
          isIncome
            ? `+${formattedAmount}`
            : `-${formattedAmount}`,

        type:
          isIncome
            ? 'income'
            : 'expense'
      }
    })
})

function formatCategory(category) {
  if (!category) {
    return ''
  }

  return category
    .toLowerCase()
    .replace(/_/g, ' ')
    .replace(
      /\b\w/g,
      (letter) =>
        letter.toUpperCase()
    )
}

async function loadDashboard() {
  billsLoading.value = true
  error.value = ''

  try {
    const [
      ,
      loadedBills
    ] = await Promise.all([
      analyticsStore
        .fetchMonthlyStatistics(
          selectedYear.value,
          selectedMonth.value
        ),

      getBills()
    ])

    bills.value = loadedBills
  } catch (requestError) {
    error.value =
      requestError
        .response
        ?.data
        ?.message ||
      analyticsStore.error ||
      'Unable to load dashboard data.'

    ElMessage.error(
      error.value
    )
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
        <h1>Your Money Overview</h1>

        <p>
          Keep track of your pension,
          benefits, healthcare costs
          and everyday spending
        </p>
      </div>

      <el-button
        :loading="loading"
        @click="loadDashboard"
      >
        Refresh
      </el-button>
    </div>

    <div class="filters-bar">
      <el-select
        v-model="selectedYear"
        placeholder="Year"
        style="width: 150px"
        @change="loadDashboard"
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
        style="width: 190px"
        @change="loadDashboard"
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
      v-if="error"
      :title="error"
      type="error"
      show-icon
      :closable="false"
      class="error-alert"
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
          <div class="chart-header">
            <div>
              <h2>
                Daily Income and Spending
              </h2>

              <p>
                See how money changed each day
              </p>
            </div>
          </div>

          <DailyCashFlowChart
            v-if="hasDailyData"
            :data="dailyCashFlowData"
            :currency="currency"
          />

          <el-empty
            v-else
            description="No operations for this month"
          />
        </div>

        <div class="chart-box">
          <div class="chart-header">
            <div>
              <h2>
                Expenses by Category
              </h2>

              <p>
                See where your money was spent
              </p>
            </div>
          </div>

          <CategoryExpenseChart
            v-if="hasCategoryData"
            :data="categoryExpenseData"
            :currency="currency"
          />

          <el-empty
            v-else
            description="No expenses for this month"
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
  margin-bottom: 22px;
  justify-content: space-between;
  align-items: center;
  gap: 20px;
}

.page-header h1 {
  margin: 0 0 8px;
  color: #172033;
  font-size: 36px;
  line-height: 1.25;
}

.page-header p {
  max-width: 680px;
  margin: 0;
  color: #52627a;
  font-size: 17px;
  line-height: 1.6;
}

.filters-bar {
  display: flex;
  margin-bottom: 22px;
  padding: 18px;
  flex-wrap: wrap;
  gap: 14px;
  border-radius: 18px;
  background: white;
  box-shadow: 0 10px 30px
    rgba(15, 23, 42, 0.06);
}

.error-alert {
  margin-bottom: 20px;
}

.cards-grid {
  display: grid;
  grid-template-columns: repeat(
    4,
    minmax(0, 1fr)
  );
  gap: 24px;
  margin-bottom: 35px;
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
  min-height: 410px;
  padding: 26px;
  border: 1px solid #e5eaf1;
  border-radius: 20px;
  background: white;
  box-shadow: 0 10px 25px
    rgba(0, 0, 0, 0.05);
}

.chart-header {
  margin-bottom: 14px;
}

.chart-header h2 {
  margin: 0 0 6px;
  color: #172033;
  font-size: 23px;
  line-height: 1.35;
}

.chart-header p {
  margin: 0;
  color: #52627a;
  font-size: 16px;
  line-height: 1.5;
}

@media (max-width: 1200px) {
  .cards-grid {
    grid-template-columns: repeat(
      2,
      minmax(0, 1fr)
    );
  }
}

@media (max-width: 850px) {
  .cards-grid,
  .charts-grid {
    grid-template-columns: 1fr;
  }

  .page-header {
    align-items: flex-start;
    flex-direction: column;
  }
}
</style>