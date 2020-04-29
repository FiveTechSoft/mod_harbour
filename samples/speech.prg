function Main()

	?? Html()

return nil    

function Html()

   local cHtml

   TEXT INTO cHtml
		<!DOCTYPE html>
		<html>
			<head>
				<meta charset="utf-8">
				<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
				<meta name="viewport" content="width=device-width">
		
				<title>Speech synthesiser</title>
				<style>{{GetStyles()}}</style>

				<!--[if lt IE 9]>
					<script src="//html5shiv.googlecode.com/svn/trunk/html5.js"></script>
				<![endif]-->
			</head>
		
			<body style="background-color: aquamarine">
				<h1>Speech synthesiser</h1>
		
				<p>Enter some text in the input below and press return  or the "play" button to hear it. change voices using the dropdown menu.</p>
				<form>
				<textarea class="txt" rows=20>Enter some text in the input below and press return or the "play" button to hear it. change voices using the dropdown menu</textarea>
				<div>
					<label for="rate">Rate</label><input type="range" min="0.5" max="2" value="1" step="0.1" id="rate">
					<div class="rate-value">1</div>
					<div class="clearfix"></div>
				</div>
				<div>
					<label for="pitch">Pitch</label><input type="range" min="0" max="2" value="1" step="0.1" id="pitch">
					<div class="pitch-value">1</div>
					<div class="clearfix"></div>
				</div>
				<select></select>
				<div class="controls">
					<button id="play" type="submit">Play</button>
				</div>
				</form>        
				<script>{{Javascript()}}</script>
			</body>
		</html>
   ENDTEXT

return ReplaceBlocks( cHtml )

function GetStyles()

	local cStyle
  
  	TEXT INTO cStyle
		body, html {
		margin: 0;
		}
	
		html {
			height: 100%;
		}
		
		body {
			height: 90%;
			max-width: 800px;
			margin: 0 auto;
		}
		
		h1, p {
			font-family: sans-serif;
			text-align: center;
			padding: 20px;
		}
		
		.txt, select, form > div {
			display: block;
			margin: 0 auto;
			font-family: sans-serif;
			font-size: 16px;
			padding: 5px;
		}
		
		.txt {
			width: 80%;
		}
		
		select {
			width: 83%;
		}
		
		form > div {
			width: 81%;
		}
		
		.txt, form > div {
			margin-bottom: 10px;
			overflow: auto;
		}
		
		.clearfix {
			clear: both;
		}
		
		label {
			float: left;
			width: 10%;
			line-height: 1.5;
		}
		
		.rate-value, .pitch-value {
			float: right;
			width: 5%;
			line-height: 1.5;
		}
		
		#rate, #pitch {
			float: right;
			width: 81%;
		}
		
		.controls {
			text-align: center;
			margin-top: 10px;
		}
		
		.controls button {
			padding: 10px;
		}
	ENDTEXT

return cStyle

function JavaScript()

	local cJS

	TEXT INTO cJS
		var synth = window.speechSynthesis;
		var inputForm = document.querySelector('form');
		var inputTxt = document.querySelector('.txt');
		var voiceSelect = document.querySelector('select');		
		var pitch = document.querySelector('#pitch');
		var pitchValue = document.querySelector('.pitch-value');
		var rate = document.querySelector('#rate');
		var rateValue = document.querySelector('.rate-value');		
		var voices = [];
		
		function populateVoiceList() {
			voices = synth.getVoices().sort(function (a, b) {
					const aname = a.name.toUpperCase(), bname = b.name.toUpperCase();
					if ( aname < bname ) return -1;
					else if ( aname == bname ) return 0;
					else return +1;
			});
			var selectedIndex = voiceSelect.selectedIndex < 0 ? 0 : voiceSelect.selectedIndex;
			voiceSelect.innerHTML = '';
			for(i = 0; i < voices.length ; i++) {
				var option = document.createElement('option');
				option.textContent = voices[i].name + ' (' + voices[i].lang + ')';
				
				if(voices[i].default) {
					option.textContent += ' -- DEFAULT';
				}
			
				option.setAttribute('data-lang', voices[i].lang);
				option.setAttribute('data-name', voices[i].name);
				voiceSelect.appendChild(option);
			}
			voiceSelect.selectedIndex = voices.length - 1;
		}
		
		populateVoiceList();

		if (speechSynthesis.onvoiceschanged !== undefined) {
			speechSynthesis.onvoiceschanged = populateVoiceList;
		}
		
		function speak(){
			if (synth.speaking) {
				console.error('speechSynthesis.speaking');
				return;
			}
			if (inputTxt.value !== '') {
				var utterThis = new SpeechSynthesisUtterance(inputTxt.value);
				utterThis.onend = function (event) {
					console.log('SpeechSynthesisUtterance.onend');
				}
				utterThis.onerror = function (event) {
					console.error('SpeechSynthesisUtterance.onerror');
				}
				var selectedOption = voiceSelect.selectedOptions[0].getAttribute('data-name');
				for(i = 0; i < voices.length ; i++) {
					if(voices[i].name === selectedOption) {
					utterThis.voice = voices[i];
					break;
					}
				}
				utterThis.pitch = pitch.value;
				utterThis.rate = rate.value;
				synth.speak(utterThis);
			}
		}
		
		inputForm.onsubmit = function(event) {
			event.preventDefault();
			speak();
			inputTxt.blur();
		}
		
		pitch.onchange = function() {
			pitchValue.textContent = pitch.value;
		}
		
		rate.onchange = function() {
			rateValue.textContent = rate.value;
		}
		
		voiceSelect.onchange = function(){
			speak();
		}
	ENDTEXT
			
return cJS