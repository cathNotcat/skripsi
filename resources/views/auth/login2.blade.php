<!doctype html>
<html lang="en">
  <head>
    <!-- Required meta tags -->
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">

    <!-- Bootstrap CSS -->
    <link rel="stylesheet" href="{{ URL::asset('public/css/bootstrap.min.css') }}">
    <!-- Font Awesome CSS -->
    <link rel="stylesheet" href="{{ URL::asset('public/css/fontawesome.css') }}">
    <!-- Alertify CSS -->
    <link rel="stylesheet" href="{{ URL::asset('public/css/alertify.css') }}">
    <!-- Semantic CSS -->
    <link rel="stylesheet" href="{{ URL::asset('public/css/semantic.css') }}">

    <link rel="stylesheet" href="{!! URL::asset('public/css/all.min.css') !!}">
    <!-- <link rel="stylesheet" href="{!! URL::asset('public/css/style.css') !!}"> -->

    <title>Login</title>
    <style>
    body {
      height: 100vh;
      display: flex;
      align-items: center;
      justify-content: center;
      background-color: #d9c4a9;

    }
    </style>
    @yield('css')

  </head>
  <!-- <body class="bg-primary" oncontextmenu="return false;" style="height: 100vh; display: 'flex'; align-items: 'center'"> -->
    <body oncontextmenu="return false;">
    @yield('content')

    <!-- <h1>asd</h1> -->
<!--
    <section class="bg-primary h-100"> -->
  <div class="container">
    <div class="">
      <div class="col col-xl-10=">
        <div class="card" style="border-radius: 1rem;">
          <div class="row g-0">
            <div class="col-md-6 col-lg-5 d-none d-md-block h-100=">
              <img src="img/tes123.jpg"
                alt="login form" class="img-fluid" style="border-radius: 1rem 0 0 1rem;" />
            </div>
            <div class="col-md-6 col-lg-7 d-flex align-items-center">
              <div class="card-body p-4 p-lg-5 text-black">

                <form class="form-signin" method="POST" action="{{ url('checkLogin') }}" onsubmit="return checkOnline()">
                  <input type="hidden" name="_token" id="_token" value="{{ csrf_token() }}" />
                  <div class="d-flex align-items-center mb-3 pb-1 justify-content-center">
                    <i class="fas fa-cubes fa-2x me-3" style="color: #3f0d0c;"></i>
                    <h1 class="h1 fw-bold mb-0">AnekaJC</h1>
                  </div>

                  <h5 class="fw-normal mb-3 pb-3" style="letter-spacing: 1px;">Sign into your account</h5>

                  <div class="form-outline mb-4">
                    <input type="text" id="username" name="username" class="form-control fas form-control-lg" placeholder="Username" required autofocus autocomplete="off">
                    <!-- <input type="email" id="form2Example17" class="form-control form-control-lg" /> -->
                    <!-- <label class="form-label" for="form2Example17">Username</label> -->
                  </div>

                  <div class="form-outline mb-4">
                    <input type="password" id="password" name="password" class="form-control fas form-control-lg" placeholder="Password" required>
                    <!-- <input type="password" id="form2Example27" class="form-control form-control-lg" /> -->
                    <!-- <label class="form-label" for="form2Example27">Password</label> -->
                  </div>

                  <div class="pt-1 mb-4">
                    <button class="btn btn-dark btn-lg btn-block" type="submit">Login</button>
                  </div>

                  <!-- <a class="small text-muted" href="#!">Forgot password?</a>
                  <p class="mb-5 pb-lg-2" style="color: #393f81;">Don't have an account? <a href="#!"
                      style="color: #393f81;">Register here</a></p>
                  <a href="#!" class="small text-muted">Terms of use.</a>
                  <a href="#!" class="small text-muted">Privacy policy</a> -->
                </form>

              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
<!-- </section> -->

    <!-- Optional JavaScript -->
    <!-- jQuery first, then Popper.js, then Bootstrap JS -->
    <script src="{{ URL::asset('public/js/jquery-3.3.1.min.js') }}"></script>
    <!-- <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.12.9/umd/popper.min.js"></script> -->
    <script src="{{ URL::asset('public/js/bootstrap.min.js') }}"></script>
    <script src="{{ URL::asset('public/js/alertify.js') }}"></script>
    @yield('js')
    <script type="text/javascript">
      $(document).ready(function(){
        @if($errors->any())
          if(JSON.parse({!! $errors !!}) == "1") {
            alertify.alert('Login gagal!', 'Username dan Password tidak cocok.', function(){ });
          }
        @endif

        $.ajax({
          url     : "{{ url('updateIdle') }}",
          type    : "GET",
          async   : false
        });
      });

      function checkOnline() {
        var _token = $("#_token").val();
        var _username = $("#username").val();
        var check = 0;
        $.ajax({
          url     : "{{ url('checkOnline') }}",
          type    : "POST",
          async   : false,
          data    : {
            _token : _token,
            username : _username
          },
          success : function(result) {
            check = result;
          }
        });
        if (check == 0) { return true; }
        else { alertify.alert('Login gagal!', 'User sudah login.', function(){ }); return false; }
        // return true;
      }
    </script>
  </body>
</html>
