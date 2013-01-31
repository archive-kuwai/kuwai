/**
 * NAAjax2.js by Naohiro OHTA, All Rights Reserved.
 */

var NAAjax2 = function(){

	// --------------------------------------------
	// Private members
	// --------------------------------------------
	var who = [];
	var http_client_uuid = "not yet initialized";
	$(function(){http_client_uuid=uuid.v4();});
	
	// --------------------------------------------
	// Public members
	// --------------------------------------------
	return{
		ajaxHistory_Req: function(ajax_id, asking){}, // Override me
		ajaxHistory_OK: function(ajax_id){}, // Override me
		ajaxHistory_NoUse: function(ajax_id){}, // Override me
		AJAX_ID: -1,
		AJAX_REQUEST_TIME: [],
		
		set_who: function(email, pw, func_when_success){
			who = [
			    email,
			    CryptoJS.SHA256(email+"kkuwaii"+pw).toString(CryptoJS.enc.HEX),
			    http_client_uuid
			];
			this.ajax("post", "", ["auth"], function(){
    			if(func_when_success != null) func_when_success(who[0]);
			});
		},
		
		ajax: function(get_or_post, callback_name, method_array, success_funciton){
            if(callback_name == null) callback_name="";

			this.AJAX_ID++; var ajax_id = this.AJAX_ID; this.AJAX_REQUEST_TIME[ajax_id] = new Date();
			this.ajaxHistory_Req(ajax_id, method_array);
			console.log("/--- Ajax Request");console.log(method_array);console.log(who);console.log("---/");
            
            var asking = {"method":method_array, "who":who};
            var asking_json = JSON.stringify(asking);
            var url = "./api/" + callback_name + "/" + asking_json.length + "/" + asking_json;
            
			var that = this; $.ajax({
				type:get_or_post,
				url:url,
				dataType:"html",
				success:function(result){
						console.log("/--- Ajax Success");console.log(result);console.log("---/");
						success_funciton(result, ajax_id);
						console.log(this);
						that.ajaxHistory_OK(ajax_id);
				},
				error:function(error){
					console.log("/--- Ajax Error");console.log(error);console.log("---/");
				}
			});				
		}
	}
}();

