@extends('auth.master')

@section('content')
<form class="form-signin" method="POST" action="{{ url('checkLogin') }}" onsubmit="return checkOnline()">
  <!-- <img class="mb-4" src="img/image_bg_1.jpeg" alt="" width="72" height="72"> -->
  <!-- <div class="outter-form-login">

  </div> -->

    <div class="card">
      <div class="outter-form-login">
        <div class="logo-login text-center" >
          <em class="fas fa-user"></em>
        </div>
      </div>
      <h4 class="text-center title-login fas">Login User</h4>
      <div class="card-body">
        <!-- <p class="login-box-msg">Sign in to start your session</p> -->
        <input type="hidden" name="_token" id="_token" value="{{ csrf_token() }}" />
        <!-- <label for="username" class="sr-only">Nama Pengguna</label> -->
        <div class="input-group mb-2">
          <!-- <div class="input-group-append"> -->
            <!-- <div class="input-group-text">
              <i class="fas fa-user"></i>
            </div> -->
          <!-- </div> -->
          <input type="text" id="username" name="username" class="form-control fas" placeholder="Username" required autofocus autocomplete="off">
        </div>
        <!-- <label for="password" class="sr-only">Kata Sandi</label> -->
        <div class="input-group mb-2">
          <!-- <div class="input-group-append"> -->
            <!-- <div class="input-group-text">
              <i class="fa fa-key"></i>
            </div> -->
          <!-- </div> -->
          <input type="password" id="password" name="password" class="form-control fas" placeholder="Password" required>
        </div>
        <div class="row">
          <div class="col-6">
          </div>
          <div class="col-6">
            <div class="float-right">
              <button class="btn btn btn-primary btn-block fas" type="submit">Login</button>
            </div>
          </div>
        </div>
      </div>
      <!-- <div class="card-footer"> -->
        <!-- <div class="float-right d-none d-sm-inline-block"> -->
        <!-- &copy;<b>Version</b> 1.1. -->
        <!-- </div> -->
      <!-- </div> -->

    </div>
</form>
@endsection

@section('js')
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
@endsection
