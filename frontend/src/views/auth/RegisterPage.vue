<template>
  <div class="register-page">

    <div class="register-container">


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



      <div class="form-side">


        <h2>
          Create account
        </h2>


        <p class="description">
          Start managing your money today
        </p>



        <form>


          <label>
            Full name
          </label>

          <input 
            type="text"
            placeholder="John Doe"
          />



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



          <label>
            Confirm password
          </label>

          <input
            type="password"
            placeholder="••••••••"
          />


          <div class="terms">

            <input type="checkbox">

            <span>
              I agree to the 
              <a href="#">
                Terms of Service
              </a>
              and
              <a href="#">
                Privacy Policy
              </a>
            </span>

          </div>



          <button>
            Register
          </button>



          <p class="login">

            Already have an account?

            <a href="/login">
              Login
            </a>

          </p>


        </form>


      </div>


    </div>


  </div>
</template>



<style scoped>


.register-page {

 min-height:100vh;

 background:#f3f5f9;

 display:flex;

 justify-content:center;

 align-items:center;

}



.register-container {

 width:900px;

 height:620px;

 display:flex;

 background:white;

 border-radius:20px;

 overflow:hidden;

 box-shadow:
 0 20px 50px rgba(0,0,0,0.12);

}



.brand-side {

 width:40%;

 background:#111827;

 color:white;

 display:flex;

 flex-direction:column;

 justify-content:center;

 align-items:center;

}



.logo {

 width:70px;

 height:70px;

 background:#2563eb;

 border-radius:15px;

 display:flex;

 justify-content:center;

 align-items:center;

 font-size:35px;

}



.brand-side h1 {

 margin-top:25px;

 font-size:34px;

}



.brand-side p {

 color:#cbd5e1;

 text-align:center;

}



.wallet {

 margin-top:60px;

 font-size:100px;

}



.form-side {

 width:60%;

 padding:60px;

}



.form-side h2 {

 font-size:32px;

 margin-bottom:10px;

}



.description {

 color:#64748b;

 margin-bottom:30px;

}



label {

 display:block;

 margin-bottom:7px;

 font-weight:600;

}



input:not([type="checkbox"]) {

 width:100%;

 padding:12px;

 border-radius:10px;

 border:1px solid #dbe2ea;

 margin-bottom:18px;

}



.terms {

 display:flex;

 gap:10px;

 align-items:flex-start;

 font-size:14px;

 margin-bottom:25px;

}



.terms a {

 color:#2563eb;

}



button {

 width:100%;

 padding:14px;

 background:#2563eb;

 color:white;

 border:none;

 border-radius:10px;

 font-size:16px;

 cursor:pointer;

}



.login {

 text-align:center;

 margin-top:25px;

}



.login a {

 color:#2563eb;

}


</style>