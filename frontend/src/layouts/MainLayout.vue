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

  display:flex;

  min-height:100vh;

  background:#f8fafc;

}


/* правая часть */

.main {

  flex:1;

  display:flex;

  flex-direction:column;

  min-width:0;

}



/* место где страницы */

.content {

flex:1;

padding:24px 32px;

overflow-x:hidden;

}


</style>