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
    <link rel="stylesheet" href="{!! URL::asset('public/css/semantic.css') !!}">
    <link rel="stylesheet" href="{!! URL::asset('public/css/select2.min.css') !!}">
    <link rel="stylesheet" href="{!! URL::asset('public/css/datatables.min.css') !!}">
    <link rel="stylesheet" type="text/css" href="https://cdn.datatables.net/1.13.2/css/jquery.dataTables.css">
    <link rel="stylesheet" href="{!! URL::asset('public/css/jquery-ui.min.css') !!}">

    <link rel="stylesheet" href="{!! URL::asset('public/css/canvas/bootstrap.css') !!}">
    <link rel="stylesheet" href="{!! URL::asset('public/css/canvas/style.css') !!}">
    <link rel="stylesheet" href="{!! URL::asset('public/css/canvas/dark.css') !!}">
    <link rel="stylesheet" href="{!! URL::asset('public/css/canvas/font-icons.css') !!}">
    <link rel="stylesheet" href="{!! URL::asset('public/css/canvas/animate.css') !!}">
    <link rel="stylesheet" href="{!! URL::asset('public/css/canvas/magnific-popup.css') !!}">
    <link rel="stylesheet" href="{!! URL::asset('public/css/canvas/custom.css') !!}">
    <link rel="stylesheet" href="{!! URL::asset('public/css/alertify.css') !!}">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.3/font/bootstrap-icons.css">

    <meta name="viewport" content="width=device-width, initial-scale=1" />

    <!-- Document Title
	============================================= -->
    <title>PEIHAI</title>

    @yield('css')
    <!-- <style>
        .dataTables_wrapper .dataTables_paginate .paginate_button:hover {
          background: none;
          color: black!important;
          border-radius: 4px;
          border: 1px solid #FFFFFF;
        }

        .dataTables_wrapper .dataTables_paginate .paginate_button:active {
          background: none;
          color: black!important;
        }
    </style> -->
  </head>

  <body class="stretched" style="background-color: #E8E8E8" >
    <!-- Document Wrapper

	============================================= -->

    <div id="wrapper" class="clearfix">
      <!-- Header
		============================================= -->
      <header id="header" class="full-header">
        <div id="header-wrap">
          <div class="container">
            <div class="header-row">
              <!-- Logo
						============================================= -->
              <div id="logo">
                <a
                  href="{{url('')}}"
                  class="standard-logo"
                  data-dark-logo="images/logo-dark.png"
                  >PT. TES API</a
                >
                <a
                  href="home"
                  class="retina-logo"
                  data-dark-logo="images/logo-dark@2x.png"
                  >PT. TES API</a
                >
              </div>
              <!-- #logo end -->

              <div class="header-misc">
                <!-- Top Search
							============================================= -->
              <div id="top-search" class="header-misc-icon">
                <ul class="menu-container" style="justify-content: left !important; align-items: left !important;">
                  <a class="menu-link" href="#"><div>#</div></a>


                <ul>
              </div>
                <!-- #top-search end -->

                <!-- Top Cart
							============================================= -->

                <!-- #top-cart end -->
              </div>

              <div id="primary-menu-trigger">
                <svg class="svg-trigger" viewBox="0 0 100 100">
                  <path
                    d="m 30,33 h 40 c 3.722839,0 7.5,3.126468 7.5,8.578427 0,5.451959 -2.727029,8.421573 -7.5,8.421573 h -20"
                  ></path>
                  <path d="m 30,50 h 40"></path>
                  <path
                    d="m 70,67 h -40 c 0,0 -7.5,-0.802118 -7.5,-8.365747 0,-7.563629 7.5,-8.634253 7.5,-8.634253 h 20"
                  ></path>
                </svg>
              </div>

              <!-- Primary Navigation
						============================================= -->

              <nav class="primary-menu">
                <ul class="menu-container" style="justify-content: left !important; align-items: left !important;">

                    <li class="menu-item">
                      <a class="menu-link" href="#"><div>Report</div></a>
                      <ul class="sub-menu-container">
                          <li class="menu-item">
                            <a class="menu-link" href="{{url('tesapicath')}}">
                              <div>Tes Data</div>
                            </a>
                          </li>
                                </a>
                              </li>
                            </a>
                          </li>
                      </ul>
                    </li>


              </nav>
              <!-- #primary-menu end -->


            </div>
          </div>
        </div>
      </header>

    <header id="header" class="full-header" style="z-index: 1">
      <div id="header-wrap">
        <!-- <div class="container"> -->
          <!-- <div class="header-row"> -->

            <nav class="navbar navbar-expand-lg navbar-dark " style="height: 39px; background-color: #5A5A5A;">
            <!-- <div class="container"> -->
               <ul class="navbar-nav mr-auto">
                   <div style="color: white">
                    SA - 2023
                   </div>

               </ul>
               <div class="d-flex align-items-center align-middle" style="vertical-align: middle;">
                  <ul class="navbar-nav ml-auto">
                    @yield('buttons')


                  </ul>
                </div>
              </nav>
          <!-- </div> -->
        <!-- </div> -->
      </div>
    </header>




      <!-- #header end -->

      <!-- Page Title
		============================================= -->

      <!-- #page-title end -->

      <!-- Content
		============================================= -->
      <section id="content" style="background-color: #E8E8E8" class="mt-3 mb-6 ">
        <div class="content-wrap">
          <!-- <div class="container clearfix"> -->
          <div class="container-fluid px-5 clearfix">
            <div class="row gutter-40 col-mb-80">
              <!-- <h1>asd</h1> -->
              <!-- Post Content
						============================================= -->
            <!-- <div class="line"></div> -->
            @yield('content')
            <!-- <div class="postcontent col-lg-9">

							<div class="row">
								<div class="col-md-4 mb-5 mb-md-0 text-center">
									<div class="rounded-skill mb-0" data-color="#00ACEE" data-size="150" data-percent="90" data-width="2" data-speed="3000"><i class="icon-twitter2"></i></div>
								</div>

								<div class="col-md-4 mb-5 mb-md-0 text-center">
									<div class="rounded-skill mb-0" data-color="#3B5998" data-size="150" data-percent="75" data-width="3" data-speed="4000"><i class="icon-facebook2"></i></div>
								</div>

								<div class="col-md-4 mb-5 mb-md-0 text-center">
									<div class="rounded-skill mb-0" data-color="#EA4C89" data-size="150" data-percent="80" data-width="4" data-speed="2000"><i class="icon-dribbble2"></i></div>
								</div>
							</div>

							<div class="line"></div>

							<div class="row">
								<div class="col-sm-6 mb-5 mb-sm-0 text-center">
									<div class="rounded-skill mb-0" data-color="#DD4B39" data-size="200" data-percent="70" data-width="3" data-speed="2500">Static Text</div>
								</div>

								<div class="col-sm-6 mb-5 mb-sm-0 text-center">
									<div class="rounded-skill mb-0" data-color="#3F729B" data-size="200" data-percent="85" data-width="3" data-speed="6500">
										<div class="counter counter-inherit"><span data-from="1" data-to="85" data-refresh-interval="50" data-speed="6000"></span>%</div>
									</div>
								</div>
							</div>

							<div class="divider"><i class="icon-circle"></i></div>

							<h3>Skills</h3>

							<ul class="skills">
								<li data-percent="80">
									<span>Wordpress</span>
									<div class="progress">
										<div class="progress-percent"><div class="counter counter-inherit counter-instant"><span data-from="0" data-to="80" data-refresh-interval="30" data-speed="1100"></span>%</div></div>
									</div>
								</li>
								<li data-percent="60">
									<span>CSS3</span>
									<div class="progress">
										<div class="progress-percent"><div class="counter counter-inherit counter-instant"><span data-from="0" data-to="60" data-refresh-interval="30" data-speed="1100"></span>%</div></div>
									</div>
								</li>
								<li data-percent="90">
									<span>HTML5</span>
									<div class="progress">
										<div class="progress-percent"><div class="counter counter-inherit counter-instant"><span data-from="0" data-to="90" data-refresh-interval="30" data-speed="1100"></span>%</div></div>
									</div>
								</li>
								<li data-percent="70">
									<span>jQuery</span>
									<div class="progress">
										<div class="progress-percent"><div class="counter counter-inherit counter-instant"><span data-from="0" data-to="70" data-refresh-interval="30" data-speed="1100"></span>%</div></div>
									</div>
								</li>
							</ul>

						</div> -->


              <!-- .postcontent end -->

              <!-- Sidebar
						============================================= -->

              <!-- .sidebar end -->
            </div>
          </div>
        </div>
      </section>
      <!-- #content end -->

      <!-- Footer
		============================================= -->
      <!-- <footer id="footer" class="dark">
        <div class="container">
        </div>

        <div id="copyrights">
          <div class="container">
            <div class="row col-mb-30">
              <div class="col-md-6 text-center text-md-left">
                Copyrights &copy; 2020 All Rights Reserved by Canvas Inc.<br />
                <div class="copyright-links">
                  <a href="#">Terms of Use</a> / <a href="#">Privacy Policy</a>
                </div>
              </div>

              <div class="col-md-6 text-center text-md-right">
                <div
                  class="d-flex justify-content-center justify-content-md-end"
                >
                  <a
                    href="#"
                    class="social-icon si-small si-borderless si-facebook"
                  >
                    <i class="icon-facebook"></i>
                    <i class="icon-facebook"></i>
                  </a>

                  <a
                    href="#"
                    class="social-icon si-small si-borderless si-twitter"
                  >
                    <i class="icon-twitter"></i>
                    <i class="icon-twitter"></i>
                  </a>

                  <a
                    href="#"
                    class="social-icon si-small si-borderless si-gplus"
                  >
                    <i class="icon-gplus"></i>
                    <i class="icon-gplus"></i>
                  </a>

                  <a
                    href="#"
                    class="social-icon si-small si-borderless si-pinterest"
                  >
                    <i class="icon-pinterest"></i>
                    <i class="icon-pinterest"></i>
                  </a>

                  <a
                    href="#"
                    class="social-icon si-small si-borderless si-vimeo"
                  >
                    <i class="icon-vimeo"></i>
                    <i class="icon-vimeo"></i>
                  </a>

                  <a
                    href="#"
                    class="social-icon si-small si-borderless si-github"
                  >
                    <i class="icon-github"></i>
                    <i class="icon-github"></i>
                  </a>

                  <a
                    href="#"
                    class="social-icon si-small si-borderless si-yahoo"
                  >
                    <i class="icon-yahoo"></i>
                    <i class="icon-yahoo"></i>
                  </a>

                  <a
                    href="#"
                    class="social-icon si-small si-borderless si-linkedin"
                  >
                    <i class="icon-linkedin"></i>
                    <i class="icon-linkedin"></i>
                  </a>
                </div>

                <div class="clear"></div>

                <i class="icon-envelope2"></i> info@canvas.com
                <span class="middot">&middot;</span>
                <i class="icon-headphones"></i> +1-11-6541-6369
                <span class="middot">&middot;</span>
                <i class="icon-skype2"></i> CanvasOnSkype
              </div>
            </div>
          </div>
        </div>
      </footer> -->


    </div>
    <!-- #wrapper end -->

    <!-- Go To Top
	============================================= -->
    <div id="gotoTop" class="icon-angle-up"></div>

    <!-- External JavaScripts
    ============================================= -->

    <script src="{!! URL::asset('public/js/canvas/jquery.js') !!}"></script>
    <script src="{!! URL::asset('public/js/jquery.min.js') !!}"></script>
    <script src="{!! URL::asset('public/js/jquery-3.3.1.min.js') !!}"></script>
    <script src="{!! URL::asset('public/js/select2.min.js') !!}"></script>
    <script src="{!! URL::asset('public/js/popper.min.js') !!}"></script>
    <script src="{!! URL::asset('public/js/bootstrap.min.js') !!}"></script>
    <script src="{!! URL::asset('public/js/alertify.js') !!}"></script>
    <script src="{!! URL::asset('public/js/autoNumeric.js') !!}"></script>
    <script src="{!! URL::asset('public/js/datatables.min.js') !!}"></script>
    <script src="{!! URL::asset('public/js/jquery-ui.min.js') !!}"></script>
    <script src="{!! URL::asset('public/js/qrcode.min.js') !!}"></script>

    <!-- Footer Scripts
	============================================= -->
  <script src="{!! URL::asset('public/js/canvas/functions.js') !!}"></script>
  <script src="{!! URL::asset('public/js/canvas/JsBarcode.all.min.js') !!}"></script>
  <!-- <script type="text/javascript" src="http://www.example.co.uk/assets/js/autoNumeric.js"></script> -->

    <script type="text/javascript">
      document.onkeydown = function(e) {
        if(event.keyCode == 123) { return false; }
        if(e.ctrlKey && e.shiftKey && e.keyCode == 'I'.charCodeAt(0)){ return false; }
        if(e.ctrlKey && e.shiftKey && e.keyCode == 'J'.charCodeAt(0)){ return false; }
        if(e.ctrlKey && e.keyCode == 'U'.charCodeAt(0)){ return false; }
      }
      $("button").addClass('btn-sm'); $(".form-control").addClass('form-control-sm');
      $(document).on('hidden.bs.modal', '.modal', function () { $('.modal:visible').length && $(document.body).addClass('modal-open'); });
      $('.modal').modal({ show: false, keyboard: false, backdrop: 'static' }); $("title").html($("#title_page").html());
      $(function () { $('[data-toggle="tooltip"]').tooltip() }); $("[rel='tooltip']").tooltip();

      function numberWithCommas(n) { var parts=n.toString().split("."); return parts[0].replace(/\B(?=(\d{3})+(?!\d))/g, ",") + (parts[1] ? "." + parts[1] : ""); }
      function toInteger(n) { return parseInt(n.replace(/,/g, "")); } function toFloat(n) { return parseFloat(n.replace(/,/g, "")); }
      function round(value, precision) { var multiplier = Math.pow(10, precision || 0); return Math.round(value * multiplier) / multiplier; } function middleTD() {}
      function format_date(date) { if (date == "" || date == null) { return ""; } return date.split("-")[2] + "/" + date.split("-")[1] + "/" + date.split("-")[0]; }
      function format_timestamp(date) { if (date == "" || date == null) return ""; tgl = date.split(" ")[0]; waktu = date.split(" ")[1]; return tgl.split("-")[2] + "/" + tgl.split("-")[1] + "/" + tgl.split("-")[0] + " " + waktu; }
      // $(function() {
      //     new AutoNumeric('.format-Rp', {
      //         currencySymbol : ' Rp',
      //         decimalCharacter : ',',
      //         digitGroupSeparator : '.',
      //     });
      // });
    </script>
    @yield('js')
  </body>
</html>
