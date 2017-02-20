// $(document).ready(function() {
// 	$("#submit").click(function() {
// 		var input = document.getElementById('fileinput');

// 		var file = input.files[0];
// 		$.ajax("/classify", {
// 			data:"{\"password\":\"password\"}",
// 			contentType : 'application/json',
// 			type : 'POST',
// 			success: function(data) {
// 				console.log("data");
// 			}
// 		})
// 	});
// });
var clickX = new Array();
var clickY = new Array();
var clickDrag = new Array();
var paint;

context = document.getElementById('drawSomething').getContext("2d");

function addClick(x, y, dragging)
{
  clickX.push(x);
  clickY.push(y);
  clickDrag.push(dragging);
}

$('#drawSomething').mousedown(function(e){
  // console.log('click started');
  var mouseX = e.pageX - this.offsetLeft;
  var mouseY = e.pageY - this.offsetTop;

  paint = true;
  addClick(e.pageX - this.offsetLeft, e.pageY - this.offsetTop);
  redraw();
});

$('#drawSomething').mousemove(function(e){
  if(paint){
    addClick(e.pageX - this.offsetLeft, e.pageY - this.offsetTop, true);
    redraw();
  }
});

$('#drawSomething').mouseup(function(e){
  paint = false;
});

$('#drawSomething').mouseleave(function(e){
  paint = false;
});

function redraw(){
  context.clearRect(0, 0, context.canvas.width, context.canvas.height); // Clears the canvas

  context.strokeStyle = "#df4b26";
  context.lineJoin = "round";
  context.lineWidth = 5;

  for(var i=0; i < clickX.length; i++) {
    context.beginPath();
    if(clickDrag[i] && i){
      context.moveTo(clickX[i-1], clickY[i-1]);
     }else{
       context.moveTo(clickX[i]-1, clickY[i]);
     }
     context.lineTo(clickX[i], clickY[i]);
     context.closePath();
     context.stroke();
  }
}

$('#finishedButton').click(function(e){
  var canvas = document.getElementById("drawSomething");
  var img  = canvas.toDataURL("image/png");
  var base64ImageContent = img.replace(/^data:image\/(png|jpg);base64,/, "");
  var file1 = base64ToBlob(base64ImageContent, 'image/png');
  var formData = new FormData();
  formData.append('file1', file1);
  $.ajax({
    url: "/upload",
    type: "POST",
    cache: false,
    contentType: false,
    processData: false,
    data: formData})
        .done(function(e){
            alert('done!');
        });
})

function base64ToBlob(base64, mime)
{
    mime = mime || '';
    var sliceSize = 1024;
    var byteChars = window.atob(base64);
    var byteArrays = [];

    for (var offset = 0, len = byteChars.length; offset < len; offset += sliceSize) {
        var slice = byteChars.slice(offset, offset + sliceSize);

        var byteNumbers = new Array(slice.length);
        for (var i = 0; i < slice.length; i++) {
            byteNumbers[i] = slice.charCodeAt(i);
        }

        var byteArray = new Uint8Array(byteNumbers);

        byteArrays.push(byteArray);
    }

    return new Blob(byteArrays, {type: mime});
}
