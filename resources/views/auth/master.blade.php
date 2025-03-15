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
    <style type="text/css">
    html,
    body {
      height: 100%;
    }

    body {
      display: -ms-flexbox;
      display: -webkit-box;
      display: flex;
      -ms-flex-align: center;
      -ms-flex-pack: center;
      -webkit-box-align: center;
      align-items: center;
      -webkit-box-pack: center;
      justify-content: center;
      padding-top: 40px;
      padding-bottom: 40px;
      /* background-color: #f5f5f5; */
      background-image: url('img/image_bg_1.jpeg');
      background-repeat: no-repeat;
      background-attachment: fixed;
      background-size: cover;
    }

    .form-signin {
      width: 100%;
      max-width: 360px;
      padding: 15px;
      margin: 0 auto;
    }
    .form-signin .checkbox {
      font-weight: 800;
    }
    .form-signin .form-control {
      position: relative;
      box-sizing: border-box;
      height: auto;
      padding: 10px;
      font-size: 14px;
    }
    .form-signin .form-control:focus {
      z-index: 2;
    }
    .form-signin input[type="text"] {
      margin-bottom: -1px;

      border-top-left-radius: 10px;
      border-top-right-radius: 10px;

      border-bottom-right-radius: 10px;
      border-bottom-left-radius: 10px;
    }
    .form-signin input[type="password"] {
      margin-bottom: -1px;

      border-top-left-radius: 10px;
      border-top-right-radius: 10px;

      border-bottom-right-radius: 10px;
      border-bottom-left-radius: 10px;
    }
    i {
      margin-bottom: -1px;
      border-top-left-radius: 0;
      border-top-right-radius: 0;
    }
    em {
      width: 50px;height: 50px;
      font-size: 40px;
    }
    .card {
      background-color: #D3D3D3;
    }
    .outter-form-login {
      padding: 20px;
      position: center;
      border-radius: 5px;
    }
    .logo-login {
      position: absolute;
      font-size: 35px;
      background: DodgerBlue;
      color: #EEEEEE;
      padding: 10px 18px;
      top: -40px;
      border-radius: 50%;
      left: 40%;
    }
    </style>
    @yield('css')

  </head>
  <body class="text-center" oncontextmenu="return false;">
    @yield('content')

    <!-- Optional JavaScript -->
    <!-- jQuery first, then Popper.js, then Bootstrap JS -->
    <script src="{{ URL::asset('public/js/jquery-3.3.1.min.js') }}"></script>
    <!-- <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.12.9/umd/popper.min.js"></script> -->
    <script src="{{ URL::asset('public/js/bootstrap.min.js') }}"></script>
    <script src="{{ URL::asset('public/js/alertify.js') }}"></script>
    @yield('js')
  </body>
</html>
