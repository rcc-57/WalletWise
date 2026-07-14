<script setup>
import { computed } from 'vue'
import { analyticsCards, incomeExpenseTrendData, balanceTrendData, categoryBreakdownData, topCategories } from '@/data/analyticsData'
import MonthlyCashFlowChart from '@/components/analytics/MonthlyCashFlowChart.vue'
import BalanceTrendChart from '@/components/analytics/BalanceTrendChart.vue'
import CategoryBreakdownChart from '@/components/analytics/CategoryBreakdownChart.vue'

const summaryCards = computed(() => [
  { title: 'Average Monthly Income', value: '$4,800', subtitle: 'Steady upward trend' },
  { title: 'Average Monthly Expense', value: '$2,940', subtitle: 'Controlled spending' },
  { title: 'Highest Expense Month', value: 'July', subtitle: 'Travel and housing' },
  { title: 'Highest Income Month', value: 'June', subtitle: 'Salary + bonus' }
])
</script>

<template>
  <div class="analytics-page">
    <div class="page-header">
      <div>
        <h1>Analytics</h1>
        <p>Track trends, spot opportunities, and understand your habits</p>
      </div>
    </div>

    <div class="filters-bar">
      <el-select placeholder="Year" style="width: 140px">
        <el-option label="2026" value="2026" />
      </el-select>
      <el-select placeholder="Month" style="width: 140px">
        <el-option label="July" value="July" />
      </el-select>
      <el-select placeholder="Category" style="width: 180px">
        <el-option label="All categories" value="All" />
      </el-select>
    </div>

    <div class="summary-grid">
      <div v-for="card in summaryCards" :key="card.title" class="summary-card">
        <h3>{{ card.title }}</h3>
        <p class="value">{{ card.value }}</p>
        <p class="subtitle">{{ card.subtitle }}</p>
      </div>
    </div>

    <div class="charts-grid">
      <div class="chart-box wide">
        <div class="chart-header">
          <h2>Income vs Expense over time</h2>
          <span>Performance trend</span>
        </div>
        <BalanceTrendChart :data="balanceTrendData" />
      </div>

      <div class="chart-box">
        <div class="chart-header">
          <h2>Monthly cash flow</h2>
          <span>Income vs spending</span>
        </div>
        <MonthlyCashFlowChart :data="incomeExpenseTrendData" />
      </div>

      <div class="chart-box">
        <div class="chart-header">
          <h2>Top spending categories</h2>
          <span>Highest outflows</span>
        </div>
        <ul class="category-list">
          <li v-for="item in topCategories" :key="item.category">
            <span>{{ item.category }}</span>
            <strong>{{ item.value }}</strong>
          </li>
        </ul>
      </div>

      <div class="chart-box">
        <div class="chart-header">
          <h2>Savings rate</h2>
          <span>Healthy reserve</span>
        </div>
        <div class="progress-block">
          <div class="progress-row">
            <span>Goal progress</span>
            <strong>72%</strong>
          </div>
          <el-progress :percentage="72" :show-text="false" />
        </div>
      </div>

      <div class="chart-box wide">
        <div class="chart-header">
          <h2>Income / Expense ratio</h2>
          <span>Balance snapshot</span>
        </div>
        <CategoryBreakdownChart :data="categoryBreakdownData" />
      </div>
    </div>
  </div>
</template>

<style scoped>
.analytics-page {
  width: 100%;
  display: flex;
  flex-direction: column;
  gap: 20px;
}

.page-header h1 {
  font-size: 32px;
  font-weight: 700;
  color: #111827;
  margin-bottom: 6px;
}

.page-header p {
  color: #64748b;
  font-size: 14px;
}

.filters-bar {
  display: flex;
  gap: 12px;
  flex-wrap: wrap;
  background: white;
  padding: 16px;
  border-radius: 18px;
  box-shadow: 0 10px 30px rgba(15, 23, 42, 0.06);
}

.summary-grid {
  display: grid;
  grid-template-columns: repeat(4, minmax(0, 1fr));
  gap: 16px;
}

.summary-card,
.chart-box {
  background: white;
  border-radius: 18px;
  padding: 18px 20px;
  box-shadow: 0 10px 30px rgba(15, 23, 42, 0.06);
}

.summary-card h3 {
  font-size: 13px;
  color: #64748b;
  margin-bottom: 8px;
}

.summary-card .value {
  font-size: 24px;
  font-weight: 700;
  color: #111827;
  margin: 0;
}

.summary-card .subtitle {
  margin-top: 6px;
  color: #64748b;
  font-size: 13px;
}

.charts-grid {
  display: grid;
  grid-template-columns: repeat(2, minmax(0, 1fr));
  gap: 16px;
}

.chart-box.wide {
  grid-column: span 2;
}

.chart-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 14px;
}

.chart-header h2 {
  font-size: 16px;
  color: #111827;
  margin: 0;
}

.chart-header span {
  font-size: 12px;
  color: #64748b;
}

.category-list {
  list-style: none;
  padding: 0;
  margin: 0;
  display: flex;
  flex-direction: column;
  gap: 10px;
}

.category-list li {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 8px 0;
  border-bottom: 1px solid #e5e7eb;
}

.category-list li:last-child {
  border-bottom: none;
}

.progress-block {
  display: flex;
  flex-direction: column;
  gap: 10px;
}

.progress-row {
  display: flex;
  justify-content: space-between;
  color: #64748b;
}

@media (max-width: 1100px) {
  .summary-grid,
  .charts-grid {
    grid-template-columns: 1fr;
  }

  .chart-box.wide {
    grid-column: span 1;
  }
}
</style>
