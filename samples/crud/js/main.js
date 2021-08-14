jQuery(function ($) {
  // Dropdown menu
  $('.sidebar-dropdown > a').click(function () {
    $('.sidebar-submenu').slideUp(200);
    if ($(this).parent().hasClass('active')) {
      $('.sidebar-dropdown').removeClass('active');
      $(this).parent().removeClass('active');
    } else {
      $('.sidebar-dropdown').removeClass('active');
      $(this).next('.sidebar-submenu').slideDown(200);
      $(this).parent().addClass('active');
    }
  });

  //toggle sidebar
  $('#toggle-border-radius').click(function () {
	if ($('.page-wrapper').hasClass('border-radius-on'))
		$('.page-wrapper').removeClass("border-radius-on")
	else
		$('.page-wrapper').addClass("border-radius-on")
  
  });
  
  $('#toggle-sidebar').click(function () {
    $('.page-wrapper').toggleClass('toggled');
	$('#toggle-sidebar').toggleClass('open');
  });

  // bind hover if pinned is initially enabled
  if ($('.page-wrapper').hasClass('pinned')) {
    $('#sidebar').hover(
      function () {       
        $('.page-wrapper').addClass('sidebar-hovered');
      },
      function () {        
        $('.page-wrapper').removeClass('sidebar-hovered');
      }
    );
  }

  //Pin sidebar
  $('#pin-sidebar').click(function () {

    if ($('.page-wrapper').hasClass('pinned')) {
  
      $('.page-wrapper').removeClass('pinned');
      $('#sidebar').unbind('hover');
	  
    } else {
	
      $('.page-wrapper').addClass('pinned');
      $('#sidebar').hover(
        function () {
                   $('.page-wrapper').addClass('sidebar-hovered');
        },
        function () {
            $('.page-wrapper').removeClass('sidebar-hovered');
        }
      );
    }
  });

  //toggle sidebar overlay
  $('#overlay').click(function () {
    $('.page-wrapper').toggleClass('toggled');
	$('#toggle-sidebar').toggleClass('open');
  });

  //switch between themes
  var themes =
    'default-theme legacy-theme chiller-theme ice-theme cool-theme light-theme';
  $('[data-theme]').click(function () {
    $('[data-theme]').removeClass('selected');
    $(this).addClass('selected');
    $('.page-wrapper').removeClass(themes);
    $('.page-wrapper').addClass($(this).attr('data-theme'));
  });

  // switch between background images
  var bgs = 'bg1 bg2 bg3 bg4';
  $('[data-bg]').click(function () {
    $('[data-bg]').removeClass('selected');
    $(this).addClass('selected');
    $('.page-wrapper').removeClass(bgs);
    $('.page-wrapper').addClass($(this).attr('data-bg'));
  });

  // toggle background image
  $('#toggle-bg').change(function (e) {
    e.preventDefault();
    $('.page-wrapper').toggleClass('sidebar-bg');
	
  });

  // toggle border radius
  $('#toggle-border-radius').change(function (e) {
    e.preventDefault();
    $('.page-wrapper').toggleClass('boder-radius-on');
  });

  //custom scroll bar is only used on desktop
  if (
    !/Android|webOS|iPhone|iPad|iPod|BlackBerry|IEMobile|Opera Mini/i.test(
      navigator.userAgent
    )
  ) {
    $('.sidebar-content').mCustomScrollbar({
      axis: 'y',
      autoHideScrollbar: true,
      scrollInertia: 300,
    });
    $('.sidebar-content').addClass('desktop');
  }
});
