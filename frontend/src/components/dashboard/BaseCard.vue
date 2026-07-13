<template>

  <div class="card">

    <div class="icon">
      <slot name="icon"></slot>
    </div>


    <div class="title">
      <slot name="title"></slot>
    </div>


    <div class="value">
      <slot name="value"></slot>
    </div>


    <div class="change">
      <slot name="change"></slot>
    </div>


  </div>

</template>


<style scoped>

.card {

background:white;

border-radius:16px;

padding:20px;

box-shadow:0 4px 20px rgba(0,0,0,0.05);

min-height:150px;

}


.icon {

font-size:28px;

margin-bottom:15px;

}


.title {

font-size:14px;

color:#64748b;

margin-bottom:8px;

}


.value {

font-size:28px;

font-weight:700;

color:#111827;

margin-bottom:8px;

}


.change {

font-size:13px;

color:#22c55e;

}


</style>