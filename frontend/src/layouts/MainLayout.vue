<template>
  <div class="layout">

    <MainNavbar />

    <div class="content">

      <MainSidebar />

      <main class="page">
        <router-view />
      </main>

    </div>

  </div>
</template>


<script setup>
import MainNavbar from '../components/ui/MainNavbar.vue'
import MainSidebar from '../components/ui/MainSidebar.vue'
</script>