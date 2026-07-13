<template>
  <div class="login-page">

    <div class="login-container">


      <!-- LEFT SIDE -->

      <div class="brand-side">

        <div class="logo">
          💳
        </div>

        <h1>
          WalletWise
        </h1>

        <p>
          Smart way to manage
          <br>
          your finances
        </p>


        <div class="wallet">
          💰
        </div>


      </div>



      <!-- RIGHT SIDE -->


      <div class="form-side">


        <h2>
          Welcome back 👋
        </h2>


        <p class="description">
          Sign in to continue to your account
        </p>



        <form>


          <label>
            Email
          </label>

          <input 
            type="email"
            placeholder="you@example.com"
          />



          <label>
            Password
          </label>

          <input
            type="password"
            placeholder="••••••••"
          />



          <div class="options">

            <label class="remember">

              <input type="checkbox">

              Remember me

            </label>


            <a href="#">
              Forgot password?
            </a>

          </div>



          <button>
            Login
          </button>



          <p class="register">

            Don't have an account?

            <a href="/register">
              Register
            </a>

          </p>


        </form>


      </div>


    </div>


  </div>
</template>



<style scoped>


.login-page {

 min-height:100vh;

 background:#f3f5f9;

 display:flex;

 justify-content:center;

 align-items:center;

}



.login-container {

 width:900px;

 height:560px;

 display:flex;

 background:white;

 border-radius:20px;

 overflow:hidden;

 box-shadow:
 0 20px 50px rgba(0,0,0,0.12);

}



/* LEFT */

.brand-side {


 width:40%;

 background:#111827;

 color:white;

 display:flex;

 flex-direction:column;

 align-items:center;

 justify-content:center;


}



.logo {

 width:70px;

 height:70px;

 background:#2563eb;

 border-radius:15px;

 display:flex;

 align-items:center;

 justify-content:center;

 font-size:35px;

}



.brand-side h1 {

 font-size:34px;

 margin-top:25px;

}



.brand-side p {

 color:#cbd5e1;

 text-align:center;

 line-height:1.5;

}



.wallet {

 margin-top:60px;

 font-size:100px;

}



/* RIGHT */


.form-side {

 width:60%;

 padding:70px;

}



.form-side h2 {

 font-size:32px;

 margin-bottom:10px;

}



.description {

 color:#64748b;

 margin-bottom:40px;

}



label {

 display:block;

 margin-bottom:8px;

 font-weight:600;

}



input[type="email"],
input[type="password"] {


 width:100%;

 padding:14px;

 border-radius:10px;

 border:1px solid #dbe2ea;

 margin-bottom:25px;

 font-size:15px;

}



.options {

 display:flex;

 justify-content:space-between;

 align-items:center;

 margin-bottom:30px;

}



.remember {

 display:flex;

 gap:8px;

 align-items:center;

 font-weight:400;

}



.options a {

 color:#2563eb;

 text-decoration:none;

}



button {


 width:100%;

 padding:15px;

 border:none;

 border-radius:10px;

 background:#2563eb;

 color:white;

 font-size:17px;

 cursor:pointer;

}



button:hover {

 background:#1d4ed8;

}



.register {

 text-align:center;

 margin-top:30px;

}



.register a {

 color:#2563eb;

 text-decoration:none;

}



</style>