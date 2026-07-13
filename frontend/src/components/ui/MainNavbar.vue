<template>

<header>

  <div class="left">

    <h2>
      
    </h2>

  </div>


  <div class="right">


    <span class="notification">
      🔔
    </span>


    <div class="user">

      <div class="avatar">
        JD
      </div>

      <div>
        <b>
          John Doe
        </b>

        <small>
          User
        </small>
      </div>

    </div>


  </div>


</header>

</template>


<style scoped>


header {

height:70px;

display:flex;

align-items:center;

justify-content:space-between;

padding:0 30px;

background:white;

border-bottom:1px solid #e5e7eb;

}


.left {

display:flex;

align-items:center;

gap:20px;

}


.left h2 {

font-size:20px;

}


.menu {

font-size:22px;

}


.right {

display:flex;

align-items:center;

gap:25px;

}


.avatar {

width:42px;
height:42px;

border-radius:50%;

background:#2563eb;

color:white;

display:flex;

align-items:center;
justify-content:center;

font-weight:bold;

}


.user {

display:flex;

align-items:center;

gap:10px;

}


.user small {

display:block;

color:#9ca3af;

}


</style>