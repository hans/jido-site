window.searchTimer = null;

google.load('language', '1');
google.setOnLoadCallback(displayGoogleBranding);

function displayGoogleBranding() {
	document.getElementById('google-branding').appendChild(google.language.getBranding());
}

$(document).ready(function() {
	$('#lookup').focus().keydown(function(event) {
		var code = event.keyCode;
		if ( !( code == 9 || code == 13 || code == 27 ) ) { // 9 = TAB, 13 = Return, 27 = Escape
			if ( window.searchTimer ) clearTimeout(window.searchTimer);
			window.searchTimer = setTimeout(detectLanguage, 500);
		}
	});
	
	function detectLanguage() {
		text = $('#lookup').val();
		if ( text == '' ) {
			$('#detected').html('type a verb to conjugate');
			return;
		}
		
		$('#loading').show();
		google.language.detect(text, function(result) {
			$('#detected').html('Detected language: ' + result.language);
			$('#loading').hide();
		});
	}
});