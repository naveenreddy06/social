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

function adjust_feed_td() {
  $("[id='myid']").each(function() {
    $(this).attr('style', 'min-height:' + (parseInt(myHeight) - 140) + 'px;' + 'max-height:' + (parseInt(myHeight) - 140) + 'px;'+ 'max-width:' + '360px;'+ 'min-width:' + '360px;' );
    $(this).attr('class', 'hero-unit boxscroll');
  });

}
$(document).ready(function() {
   $("#left-content").attr('style', 'min-height:' + (parseInt(myHeight) - 140) + 'px;' + 'max-height:' + (parseInt(myHeight) - 140) + 'px;' + 'overflow:auto;');
   $("#new_post").attr('style', 'min-height:' + (parseInt(myHeight) - 140) + 'px;' + 'max-height:' + (parseInt(myHeight) - 140) + 'px;'+ 'max-width:' + '44px;'+ 'min-width:' + '44px;' );
  $("#span_post_type").attr('style', 'min-height:' + (parseInt(myHeight) - 140) + 'px;');
  adjust_feed_td();
});


