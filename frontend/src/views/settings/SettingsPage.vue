<script setup>
import { reactive, ref } from 'vue'

const settingsForm = reactive({
  currency: 'USD',
  notifications: true,
  autoBackup: false,
  compactView: false
})

const savedMessage = ref('')

function saveSettings() {
  savedMessage.value = 'Preferences saved successfully.'
}
</script>

<template>
  <div class="page">
    <div class="page-header">
      <div>
        <h1>Settings</h1>
        <p>Adjust your WalletWise preferences</p>
      </div>
    </div>

    <el-card shadow="never" class="card">
      <template #header>
        <div class="card-header">
          <span>App preferences</span>
        </div>
      </template>

      <el-form label-position="top">
        <el-form-item label="Currency">
          <el-select v-model="settingsForm.currency" style="width: 100%;">
            <el-option label="USD" value="USD" />
            <el-option label="EUR" value="EUR" />
            <el-option label="GBP" value="GBP" />
          </el-select>
        </el-form-item>

        <el-form-item label="Notifications">
          <el-switch v-model="settingsForm.notifications" />
        </el-form-item>

        <el-form-item label="Auto backup">
          <el-switch v-model="settingsForm.autoBackup" />
        </el-form-item>

        <el-form-item label="Compact view">
          <el-switch v-model="settingsForm.compactView" />
        </el-form-item>

        <div class="actions">
          <el-button type="primary" @click="saveSettings">Save preferences</el-button>
        </div>

        <p v-if="savedMessage" class="helper-text">{{ savedMessage }}</p>
      </el-form>
    </el-card>
  </div>
</template>

<style scoped>
.page {
  display: flex;
  flex-direction: column;
  gap: 24px;
}

.page-header h1 {
  font-size: 34px;
  font-weight: 700;
  color: #111827;
  margin-bottom: 6px;
}

.page-header p {
  font-size: 15px;
  color: #6b7280;
}

.card {
  border-radius: 18px;
}

.card-header {
  font-weight: 600;
  color: #111827;
}

.actions {
  margin-top: 8px;
}

.helper-text {
  margin-top: 12px;
  color: #2563eb;
}
</style>
