function unifyHeights() {
  var maxHeight = 0;
  var tdHeight = parseFloat(window.innerHeight)  - $("#footer").height();
  var minHeight = tdHeight - 70;
  var maxHeight = tdHeight - 69;
   $("[adjustTd=true]").attr("style", 'min-height: '+ minHeight + "px; max-height: "+ maxHeight + "px;");
}

$(document).ready(function(){
    unifyHeights();
});
