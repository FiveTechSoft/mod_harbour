//	Menu System

function Menu_Load() {

	var cIni = '{{ AppIniMenu() }}'
	var oIni = JSON.parse(localStorage.getItem(cIni));
	
	if ( oIni == null ) {
	
		oIni = new Object()
	
		oIni[ 'pinned' ] 		= false
		oIni[ 'theme' ] 		= 'chiller-theme'
		oIni[ 'background' ] 	= 'bg1'
		oIni[ 'showback' ] 		= true
		oIni[ 'showradius' ] 	= true									
	}
	
	return oIni
}

function Menu_Settings() {

	var oIni = Menu_Load()	
	
	if ( oIni[ 'pinned' ] == false ) {
	
		$(".page-wrapper").removeClass("pinned");
		$("#sidebar").unbind( "hover");						
	
	} else { 
	
		$(".page-wrapper").addClass("pinned");
		$("#sidebar").hover(
			function () {                    
				$(".page-wrapper").addClass("sidebar-hovered");
			},
			function () {                   
				$(".page-wrapper").removeClass("sidebar-hovered");
			}
		)									
	}	

	$('.page-wrapper').addClass( oIni[ 'theme' ] )
	$('.page-wrapper').addClass( oIni[ 'background' ] )
	
	$('[data-theme]').removeClass("selected");
	$('[data-theme="' + oIni[ 'theme' ] + '"]').addClass("selected")
	
	$('[data-bg]').removeClass("selected");
	$('[data-bg="' + oIni[ 'background' ] + '"]').addClass("selected")			
	
	
	if ( oIni[ 'showback' ] ) {
		$('.page-wrapper').addClass("sidebar-bg")
		$('#toggle-bg' ).prop( 'checked' , true )
	} else {
		$('.page-wrapper').removeClass("sidebar-bg")
		$('#toggle-bg' ).prop( 'checked' , false )				
	}
	
	if ( oIni[ 'showradius' ] ) {
		$('.page-wrapper').addClass("border-radius-on")
		$('#toggle-border-radius').prop( 'checked' , true )
	} else {
		$('.page-wrapper').removeClass("border-radius-on")
		$('#toggle-border-radius').prop( 'checked' , false )
	}		

	return oIni
}

$(document).ready(function () {	
	Menu_Settings()
})