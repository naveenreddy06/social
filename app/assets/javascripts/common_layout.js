function unifyHeights() {
  var maxHeight = 0;
  var tdHeight = parseFloat(window.innerHeight)  - $("#footer").height();
  var minHeight = tdHeight - 140;
  var maxHeight = tdHeight - 139;
   $("[adjustTd=true]").attr("style", 'min-height: '+ minHeight + "px; overflow: auto; height: "+ maxHeight + "px;");
}

$(document).ready(function(){
    unifyHeights();
});

$(window).resize(function() {
   unifyHeights();
});