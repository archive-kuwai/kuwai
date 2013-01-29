/**
 * NAVerticalTable.js by Naohiro OHTA, All Rights Reserved.
 */

var NAVerticalTableForDynamo = function(){
	
	// --------------------------------------------
	// Private members
	// --------------------------------------------
	var tr = function(data){return "<tr onclick='var h=$(this).find(\".hash\");var r=$(this).find(\".range\");func_on_click($(h).text(),$(r).text());'>" + data + "</tr>";};
	//var td1 = function(data){return "<td>" + data + "</td>";};
	var td2 = function(data){return "<td align='left' style='width:100%;word-break:break-all;'>" + data + "</td>";};

	var dig = function(record){
	    
		// ----------------------------------
		// dig function 's private functions.
		// ----------------------------------
		var hash = function(k){return "<span class='small hash'>" +k+ "</span><br>";};
		var range = function(i){return "<span class='range'>" +i+ "</span>";};
		
		// ----------------------------------
		// dig function 's  main procedure.
		// ----------------------------------
		return hash(record["hash"]) + " " + range(record["range"]);
	};
	
	// --------------------------------------------
	// Public members
	// --------------------------------------------
	return{
		build: function($tbl, records){
			$tbl.empty();
			for(var i=0; i<records.length; i++){
				$tbl.append(tr(/*td1(" ")+*/td2(dig(records[i]))));
			}
		}
	};
	
}();