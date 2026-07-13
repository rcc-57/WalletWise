<template>


<aside class="sidebar">


<div class="logo">

WalletWise

</div>



<nav>


<router-link to="/dashboard">

🏠 Dashboard

</router-link>



<router-link to="/expenses">

💳 Expenses

</router-link>



<router-link to="/income">

💰 Income

</router-link>



<router-link to="/analytics">

📊 Analytics

</router-link>



<router-link to="/profile">

👤 Profile

</router-link>



<router-link to="/settings">

⚙ Settings

</router-link>



</nav>



<div class="logout">

🚪 Logout

</div>


</aside>


</template>


<style scoped>

aside {
  width: 250px;
  min-height: 100vh;

  background: #111827;

  padding: 25px;

  display:flex;
  flex-direction:column;
}


.logo {
  color:white;
  font-size:24px;
  font-weight:700;

  margin-bottom:40px;
}


nav {
  flex:1;
}


a {

  display:block;

  color:#cbd5e1;

  padding:14px 15px;

  margin-bottom:12px;

  border-radius:12px;

  text-decoration:none;

}


a:hover {

  background:#2563eb;

  color:white;

}


.logout {

  color:#f87171;

}


</style>