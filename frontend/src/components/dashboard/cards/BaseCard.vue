<template>

<div class="card">


    <div class="icon-wrapper">

        <slot name="icon"></slot>

    </div>



    <div class="content">


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


</div>

</template>



<style scoped>


.card {


background:white;

border-radius:20px;

padding:24px;

height:170px;

display:flex;

flex-direction:column;

justify-content:space-between;


box-shadow:
0 10px 30px rgba(15,23,42,0.06);


transition:0.3s;


}



.card:hover {


transform:translateY(-5px);


box-shadow:
0 15px 35px rgba(15,23,42,0.12);


}




.icon-wrapper {


width:45px;

height:45px;

display:flex;

align-items:center;

justify-content:center;


font-size:26px;


background:#f1f5f9;

border-radius:14px;


}



.title {


font-size:14px;

color:#64748b;

margin-top:10px;


}



.value {


font-size:28px;

font-weight:700;

color:#111827;


}



.change {


font-size:13px;

color:#22c55e;


}



</style>