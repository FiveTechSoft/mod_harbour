function Main()

   TEMPLATE
   <style>
   #progress_bar {
     margin: 10px 0;
     padding: 3px;
     border: 1px solid #000;
     font-size: 14px;
     clear: both;
     opacity: 0;
     -moz-transition: opacity 1s linear;
     -o-transition: opacity 1s linear;
     -webkit-transition: opacity 1s linear;
   }
   #progress_bar.loading {
     opacity: 1.0;
   }
   #progress_bar .percent {
     background-color: #99ccff;
     height: auto;
     width: 0;
   }
 </style>
 
 <input type="file" id="files" name="file" />
 <button onclick="abortRead();">Cancel read</button>
 <div id="progress_bar"><div class="percent">0%</div></div>
 
 <script>
   var reader;
   var progress = document.querySelector('.percent');
 
   function abortRead() {
     reader.abort();
   }
 
   function errorHandler(evt) {
     switch(evt.target.error.code) {
       case evt.target.error.NOT_FOUND_ERR:
         alert('File Not Found!');
         break;
       case evt.target.error.NOT_READABLE_ERR:
         alert('File is not readable');
         break;
       case evt.target.error.ABORT_ERR:
         break; // noop
       default:
         alert('An error occurred reading this file.');
     };
   }
 
   function updateProgress(evt) {
     // evt is an ProgressEvent.
     if (evt.lengthComputable) {
       var percentLoaded = Math.round((evt.loaded / evt.total) * 100);
       // Increase the progress bar length.
       if (percentLoaded < 100) {
         progress.style.width = percentLoaded + '%';
         progress.textContent = percentLoaded + '%';
       }
     }
   }
 
   function handleFileSelect(evt) {
     // Reset progress indicator on new file selection.
     progress.style.width = '0%';
     progress.textContent = '0%';
 
     reader = new FileReader();
     reader.onerror = errorHandler;
     reader.onprogress = updateProgress;
     reader.onabort = function(e) {
       alert('File read cancelled');
     };
     reader.onloadstart = function(e) {
       document.getElementById('progress_bar').className = 'loading';
     };
     reader.onload = function(e) {
       // Ensure that the progress bar displays 100% at the end.
       progress.style.width = '100%';
       progress.textContent = '100%';
       setTimeout("document.getElementById('progress_bar').className='';", 2000);
       var formData = new FormData();
       var xhr = new XMLHttpRequest();
       var blob = new Blob( [e.target.result], {type: "application/octet-stream"} );
       formData.append( evt.target.files[0].name, blob );
       xhr.onreadystatechange = function() { 
         if( this.readyState == XMLHttpRequest.DONE && this.status == 200 ) {
            alert( "sent" ); // this.responseText );
        } 
       };
       xhr.open( "POST", 'upload.prg' );
       xhr.send( formData );
     }
 
     // Read in the image file as a binary string.
     reader.readAsDataURL( evt.target.files[0] );
   }
 
   document.getElementById('files').addEventListener('change', handleFileSelect, false);
 </script>
ENDTEXT

return nil
