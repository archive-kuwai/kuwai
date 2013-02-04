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
		
		set_who: function(email, pw, success_funciton, error_function, ajax_error_function){
			who = [
			    email,
			    CryptoJS.SHA256(email+"kkuwaii"+pw).toString(CryptoJS.enc.HEX),
			    http_client_uuid
			];
			this.ajax(["auth"], 
			    function(result){
    			    if(result == "Authed"){
            			if(success_funciton != null) success_funciton(who[0]);
    			    }else{
            			if(error_function != null) error_function(who[0]);
    			    }
    			}, 
    			ajax_error_function
    		);
		},
		
		ajax: function(method_array, success_funciton, error_function){
			callback_name="pad";
			this.AJAX_ID++; var ajax_id = this.AJAX_ID; this.AJAX_REQUEST_TIME[ajax_id] = new Date();
			this.ajaxHistory_Req(ajax_id, method_array);
			console.log("/--- Ajax Request");console.log(method_array);console.log(who);console.log("---/");
            
            var asking = {"method":method_array, "who":who};
            var asking_json = JSON.stringify(asking);
            var url = "./api/pad/" + asking_json.length + "/" + asking_json;
            
			var that = this; $.ajax({
				type:"post",
				url:url,
				dataType:"jsonp",
				success:function(result){
					console.log("/--- Ajax Success");console.log(result);console.log("---/");
					success_funciton(result, ajax_id);
					console.log(this);
					that.ajaxHistory_OK(ajax_id);
				},
				error:function(error){
					console.log("/--- Ajax Error");console.log(error);console.log("---/");
					error_function(error, ajax_id);
				}
			});
		}
	}
}();

