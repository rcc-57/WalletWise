<script setup>
import {
  analyticsCards,
  incomeExpenseTrendData,
  balanceTrendData,
  categoryBreakdownData,
  topCategories
} from '@/data/analyticsData'
import MonthlyCashFlowChart from '@/components/analytics/MonthlyCashFlowChart.vue'
import BalanceTrendChart from '@/components/analytics/BalanceTrendChart.vue'
import CategoryBreakdownChart from '@/components/analytics/CategoryBreakdownChart.vue'
</script>

<template>
  <div class="analytics-page">
    <div class="page-header">
      <div>
        <h1>Analytics</h1>
        <p>Explore trends and insights for income and expenses</p>
      </div>
    </div>

    <div class="cards-grid">
      <div class="analytics-card" v-for="card in analyticsCards" :key="card.title">
        <h3>{{ card.title }}</h3>
        <p class="value">{{ card.value }}</p>
        <p class="subtitle">{{ card.subtitle }}</p>
      </div>
    </div>

    <div class="charts-grid">
      <div class="chart-box">
        <h2>Income vs Expenses</h2>
        <MonthlyCashFlowChart :data="incomeExpenseTrendData" />
      </div>
      <div class="chart-box">
        <h2>Balance Trend</h2>
        <BalanceTrendChart :data="balanceTrendData" />
      </div>
      <div class="chart-box full-width">
        <h2>Expenses by Category</h2>
        <CategoryBreakdownChart :data="categoryBreakdownData" />
      </div>
    </div>

    <div class="top-categories-box">
      <div class="chart-box">
        <h2>Top Expense Categories</h2>
        <ul class="category-list">
          <li v-for="item in topCategories" :key="item.category">
            <span>{{ item.category }}</span>
            <strong>{{ item.value }}</strong>
          </li>
        </ul>
      </div>
    </div>
  </div>
</template>

<style scoped>
.analytics-page {
  width: 100%;
}

.page-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 30px;
}

.page-header h1 {
  font-size: 36px;
  color: #111827;
  margin-bottom: 8px;
}

.page-header p {
  color: #6b7280;
}

.cards-grid {
  display: grid;
  grid-template-columns: repeat(4, minmax(0, 1fr));
  gap: 20px;
  margin-bottom: 30px;
}

.analytics-card {
  background: white;
  border-radius: 20px;
  padding: 24px;
  box-shadow: 0 10px 25px rgba(0, 0, 0, 0.05);
}

.analytics-card h3 {
  margin-bottom: 10px;
  font-size: 16px;
  color: #6b7280;
}

.analytics-card .value {
  margin: 0;
  font-size: 32px;
  font-weight: 700;
  color: #111827;
}

.analytics-card .subtitle {
  margin-top: 8px;
  color: #64748b;
}

.charts-grid {
  display: grid;
  grid-template-columns: repeat(2, minmax(0, 1fr));
  gap: 24px;
  margin-bottom: 30px;
}

.chart-box {
  background: white;
  border-radius: 20px;
  padding: 24px;
  box-shadow: 0 10px 25px rgba(0, 0, 0, 0.05);
}

.chart-box.full-width {
  grid-column: span 2;
}

.chart-box h2 {
  margin-bottom: 22px;
  font-size: 22px;
}

.top-categories-box {
  display: grid;
  grid-template-columns: repeat(1, minmax(0, 1fr));
}

.category-list {
  list-style: none;
  padding: 0;
  margin: 0;
}

.category-list li {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 16px 0;
  border-bottom: 1px solid #e5e7eb;
}

.category-list li:last-child {
  border-bottom: none;
}

.category-list strong {
  color: #111827;
}

@media (max-width: 1200px) {
  .cards-grid,
  .charts-grid {
    grid-template-columns: 1fr;
  }

  .chart-box.full-width {
    grid-column: span 1;
  }
}
</style>
