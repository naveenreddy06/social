var myWidth;
var myHeight;

if( typeof( window.innerWidth ) == 'number' ) {

//Non-IE

myWidth = window.innerWidth;
myHeight = window.innerHeight;

} else if( document.documentElement &&

( document.documentElement.clientWidth || document.documentElement.clientHeight ) ) {

//IE 6+ in 'standards compliant mode'

myWidth = document.documentElement.clientWidth;
myHeight = document.documentElement.clientHeight;

} else if( document.body && ( document.body.clientWidth || document.body.clientHeight ) ) {

//IE 4 compatible

myWidth = document.body.clientWidth;
myHeight = document.body.clientHeight;

}

function adjust_td() {
  
  $("[adjustTd=true]").each(function() {	
    $(this).attr('style', 'min-height:' + (parseInt(myHeight) - 140) + 'px;' + 'max-height:' + (parseInt(myHeight) - 140));
  });



}
$(document).ready(function() {
   adjust_td();
});


