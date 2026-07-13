<template>
  <aside>
    <nav>
      <router-link to="/dashboard">
        Dashboard
      </router-link>

      <router-link to="/expenses">
        Expenses
      </router-link>
    </nav>
  </aside>
</template>


<style scoped>
aside {
  width: 220px;
  min-height: calc(100vh - 60px);
  background: #334155;
  padding: 20px;
}

a {
  display: block;
  color: white;
  margin-bottom: 15px;
  text-decoration: none;
}
</style>