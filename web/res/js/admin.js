//admin.js

$(document).ready(function(){
	$(".form-disabled").find("input,select,textarea").prop('readonly',true);
	
	$(".form-disabled .form-not-disabled").find("input,select,textarea").prop('readonly',false);
});
