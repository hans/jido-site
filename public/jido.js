detectedLanguage = null;
searchTimer = null;
scrolled = false;

google.load('language', '1');
google.setOnLoadCallback(displayGoogleBranding);

function displayGoogleBranding() {
	document.getElementById('google-branding').appendChild(google.language.getBranding());
}

//+ Jonas Raoni Soares Silva
//@ http://jsfromhell.com/string/capitalize [v1.0]
String.prototype.capitalize = function() {
	return this.replace(/\w+/g, function(a) {
		return a.charAt(0).toUpperCase() + a.substr(1).toLowerCase();
	})
}

$(document).ready(function() {
	$('#lookup').focus().keydown(function(event) {
		var code = event.keyCode;
		if ( code == 13 )
			conjugate();
		else if ( !( code == 9 || code == 27 ) ) { // 9 = TAB, 13 = Return, 27 = Escape
			if ( searchTimer ) clearTimeout(searchTimer);
			searchTimer = setTimeout(detectLanguage, 500);
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
			detectedLanguage = result.language;
			$('#detected').html('Detected language: ' + getLanguageName(result.language));
			$('#loading').hide();
		});
	}
	
	function conjugate() {
		var val = $('#lookup').val();

		if ( !detectedLanguage || val == '' ) return false;
		if ( !scrolled ) $('#container').animate({top: '-170px'}, 500);

		$.getJSON('/conjugate/' + detectedLanguage + '/' + val, function (data) {
			console.log(data);
		});
	}
	
	function getLanguageName(code) {
		ret = null;
		
		for ( var i in google.language.Languages ) {
			if ( google.language.Languages[i] == code ) {
				ret = i;
				break;
			}
		}
		
		if ( ret ) ret = ret.capitalize();
		return ret;
	}
});
