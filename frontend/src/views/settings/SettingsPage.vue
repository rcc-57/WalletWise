<script setup>
import { reactive, ref } from 'vue'
import { Setting, Bell, Upload, Tickets } from '@element-plus/icons-vue'

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
        <p>Personalize your finance workspace</p>
      </div>
    </div>

    <el-card shadow="never" class="card">
      <template #header>
        <div class="card-header">
          <span>App preferences</span>
        </div>
      </template>

      <div class="settings-grid">
        <div class="settings-panel">
          <div class="panel-title">
            <el-icon><Setting /></el-icon>
            <span>General</span>
          </div>
          <el-form label-position="top">
            <el-form-item label="Currency">
              <el-select v-model="settingsForm.currency" style="width: 100%;">
                <el-option label="USD" value="USD" />
                <el-option label="EUR" value="EUR" />
                <el-option label="GBP" value="GBP" />
              </el-select>
            </el-form-item>
          </el-form>
        </div>

        <div class="settings-panel">
          <div class="panel-title">
            <el-icon><Bell /></el-icon>
            <span>Notifications</span>
          </div>
          <el-form label-position="top">
            <el-form-item label="Push notifications">
              <el-switch v-model="settingsForm.notifications" />
            </el-form-item>
          </el-form>
        </div>

        <div class="settings-panel">
          <div class="panel-title">
            <el-icon><Upload /></el-icon>
            <span>Backup</span>
          </div>
          <el-form label-position="top">
            <el-form-item label="Auto backup">
              <el-switch v-model="settingsForm.autoBackup" />
            </el-form-item>
          </el-form>
        </div>

        <div class="settings-panel">
          <div class="panel-title">
            <el-icon><Tickets /></el-icon>
            <span>Display</span>
          </div>
          <el-form label-position="top">
            <el-form-item label="Compact view">
              <el-switch v-model="settingsForm.compactView" />
            </el-form-item>
          </el-form>
        </div>
      </div>

      <div class="actions">
        <el-button type="primary" @click="saveSettings">Save preferences</el-button>
      </div>

      <p v-if="savedMessage" class="helper-text">{{ savedMessage }}</p>
    </el-card>
  </div>
</template>

<style scoped>
.page {
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
  font-size: 14px;
  color: #64748b;
}

.card {
  border-radius: 18px;
}

.card-header {
  font-weight: 600;
  color: #111827;
}

.settings-grid {
  display: grid;
  grid-template-columns: repeat(2, minmax(0, 1fr));
  gap: 16px;
}

.settings-panel {
  border: 1px solid #e5e7eb;
  border-radius: 16px;
  padding: 16px;
  background: #fafafa;
}

.panel-title {
  display: flex;
  align-items: center;
  gap: 8px;
  font-weight: 600;
  color: #111827;
  margin-bottom: 10px;
}

.actions {
  margin-top: 16px;
}

.helper-text {
  margin-top: 12px;
  color: #2563eb;
}

@media (max-width: 900px) {
  .settings-grid {
    grid-template-columns: 1fr;
  }
}
</style>
