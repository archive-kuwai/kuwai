/**
 * NALoadPage.js by Naohiro OHTA, All Rights Reserved.
 */

var NALoadPage = function(){

	// --------------------------------------------
	// Private members
	// --------------------------------------------
    
	// --------------------------------------------
	// Public members
	// --------------------------------------------
	return{
        load: function(id, url){
            var ELEMENT = $("#"+id);
            NASlide.slide(id, "WAIT");
            $.ajax({
              type:"GET",
              url:url,
              dataType:"html",
              success:function(result){
                ELEMENT.html(result);
                NASlide.slide("WAIT",id);
              },
              error:function(result){
                console.log("Error: NALoadPage.js - load()");
                console.log(result);
                ELEMENT.html("<h3>ページを読みこんでいる際にエラーが起きました。<br>お手数ですが、もう一度操作を試していただけますか？</h3>");
                NASlide.slide("WAIT",id);
              }
            });
        }
    };
}();
