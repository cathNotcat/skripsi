<!DOCTYPE html>
<html dir="ltr" lang="en-US">
  <head>
    <meta http-equiv="content-type" content="text/html; charset=utf-8" />
    <meta name="author" content="SemiColonWeb" />

    <!-- Stylesheets
	============================================= -->
    <link
      href="https://fonts.googleapis.com/css?family=Lato:300,400,400i,700|Poppins:300,400,500,600,700|PT+Serif:400,400i&display=swap"
      rel="stylesheet"
      type="text/css"
    />
    <link rel="stylesheet" href="{!! URL::asset('public/css/canvas/bootstrap.css') !!}">
    <link rel="stylesheet" href="{!! URL::asset('public/css/canvas/style.css') !!}">
    <link rel="stylesheet" href="{!! URL::asset('public/css/canvas/dark.css') !!}">
    <link rel="stylesheet" href="{!! URL::asset('public/css/canvas/font-icons.css') !!}">
    <link rel="stylesheet" href="{!! URL::asset('public/css/canvas/animate.css') !!}">
    <link rel="stylesheet" href="{!! URL::asset('public/css/canvas/magnific-popup.css') !!}">
    <link rel="stylesheet" href="{!! URL::asset('public/css/canvas/custom.css') !!}">
    <link rel="stylesheet" href="{{ URL::asset('public/css/alertify.css') }}">
    <!-- <link rel="stylesheet" href="css/canvas/bootstrap.css" type="text/css" />
    <link rel="stylesheet" href="css/canvas/style.css" type="text/css" />
    <link rel="stylesheet" href="css/canvas/dark.css" type="text/css" />
    <link rel="stylesheet" href="css/canvas/font-icons.css" type="text/css" />
    <link rel="stylesheet" href="css/canvas/animate.css" type="text/css" />
    <link rel="stylesheet" href="css/canvas/magnific-popup.css" type="text/css" />
    <link rel="stylesheet" href="css/canvas/custom.css" type="text/css" /> -->
    <meta name="viewport" content="width=device-width, initial-scale=1" />

    <!-- Document Title
	============================================= -->
    <title>AnekaJC</title>
  </head>

  <body class="stretched">
    <!-- <div id="custom-notification-message" data-notify-position="top-right" data-notify-type="info" data-notify-msg='<i class="icon-info-sign"></i> Welcome to Canvas Demo!'></div> -->
    <!-- Document Wrapper
	============================================= -->
    <div id="wrapper" class="clearfix">
      <!-- Content
		============================================= -->
      <section id="content">
        <div class="content-wrap py-0">
          <div
            class="section dark p-0 m-0 h-100 position-absolute"
            style="
              background: url('img/back.jpg') center center
                no-repeat;
              background-size: cover;
            "
          ></div>

          <div class="section bg-transparent min-vh-100 p-0 m-0 d-flex" >
            <div class="vertical-middle" style="margin-top: -80px">
                <div class="text-center">
                    <h1>
                        PeiHai
                    </h1>
                  </div>

                <div
                  class="card mx-auto"
                  style="max-width: 400px; border-radius: 25px;"
                >
                  <div class="card-body" style="padding: 40px">
                    <form
                      class="mb-0"
                      action="{{ url('checkLogin') }}"
                      method="post"
                      onsubmit="return checkOnline()"
                    >
                      <h3>Login to your Account</h3>
                      <input type="hidden" name="_token" id="_token" value="{{ csrf_token() }}" />
                      <div class="row">
                        <div class="col-12 form-group">
                          <label for="login-form-username">ID:</label>
                          <input type="text" id="username" name="username" class="form-control fas" placeholder="Username" required autofocus autocomplete="off">
                        </div>

                        <div class="col-12 form-group">
                          <label for="login-form-password">Password:</label>
                          <input type="password" id="password" name="password" class="form-control fas" placeholder="Password">
                        </div>

                        <!-- <div class="col-12 form-group mb-0">
                          <button
                            class="button button-3d button-black m-0"
                            id="login-form-submit"
                            name="login-form-submit"
                            value="login"
                          >
                            Login
                          </button>

                        </div> -->

                      </div>
                      <div class="center" style="margin-top: 35px">
                        <button
                        class="button button-3d button-black m-0"
                        id="login-form-submit"
                        name="login-form-submit"
                        value="login"
                        type="submit"
                      >
                        Login
                      </button>

                      </div>
                    </form>

                    <!-- <div class="line line-sm"></div> -->

                    <!-- <div class="center">
                      <h4 style="margin-bottom: 15px">or Login with:</h4>
                      <a
                        href="#"
                        class="button button-rounded si-facebook si-colored"
                        >Facebook</a
                      >
                      <span class="d-none d-md-inline-block">or</span>
                      <a
                        href="#"
                        class="button button-rounded si-twitter si-colored"
                        >Twitter</a
                      >
                    </div> -->
                  </div>
                </div>

                <!-- <div class="text-center text-muted mt-3">
                  <small
                    >Copyrights &copy; All Rights Reserved by Canvas Inc.</small
                  >
                </div> -->
              </div>
            </div>
          </div>
        </div>
      </section>
      <!-- #content end -->
    </div>
    <!-- #wrapper end -->

    <!-- Go To Top
	============================================= -->

    <!-- External JavaScripts
	============================================= -->
  <script src="{!! URL::asset('public/js/canvas/jquery.js') !!}"></script>
  <script src="{!! URL::asset('public/js/canvas/function.js') !!}"></script>
  <script src="{{ URL::asset('public/js/alertify.js') }}"></script>



  <script type="text/javascript">
    $(document).ready(function(){
      @if($errors->any())
        if(JSON.parse({!! $errors !!}) == "1") {
          alertify.alert('Login gagal!', 'Username dan Password tidak cocok.', function(){ });
          // SEMICOLON.widget.notifications({ el: {data-notify-msg: "<i class=icon-remove-sign></i> Incorrect Input. Please Try Again!"} }); return false;
          // SEMICOLON.widget.notifications({ el: jQuery("#custom-notification-message") });
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
  <script type="text/javascript">
  jQuery(window).on( 'load', function(){
    SEMICOLON.widget.notifications({ el: jQuery("#custom-notification-message") });
  });
</script>

    <!-- Footer Scripts
	============================================= -->
  </body>
</html>
