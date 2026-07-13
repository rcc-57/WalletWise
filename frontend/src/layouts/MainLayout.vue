<template>
  <div class="layout">

    <MainSidebar />

    <div class="main">

      <MainNavbar />

      <main class="content">
        <router-view />
      </main>

    </div>

  </div>
</template>


<script setup>
import MainNavbar from '../components/ui/MainNavbar.vue'
import MainSidebar from '../components/ui/MainSidebar.vue'
</script>


<style scoped>

.layout {
  display: flex;
  min-height: 100vh;
  background: #f8fafc;
}


.main {
  flex: 1;
  display: flex;
  flex-direction: column;
}


.content {
  padding: 30px;
  flex: 1;
}

</style>