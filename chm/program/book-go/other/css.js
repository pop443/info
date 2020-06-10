function hoverhidden(obj){
	var $nextObj = $(obj).next() ;
	this.hovershowhide($nextObj[0]);
}
function hovershowhideById(id){
	var $Obj = $("#"+id) ;
	this.hovershowhide($Obj[0]);
}
function hovershowhide(obj){
	var $Obj = $(obj) ;
	if($Obj.css("display")=="none"){
		$Obj.css("display","block");
	}else{
		$Obj.css("display","none");
	}
}

