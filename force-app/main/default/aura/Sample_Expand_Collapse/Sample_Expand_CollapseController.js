({
	 moreDataInfo : function(component, event, helper) {
		var thisObj = event.target.id;
        var loadDataInfo = document.getElementById('loadDataInfo');
        var rowDetailAll =  loadDataInfo.querySelectorAll('.rowDetail');
        var listRowAll =  loadDataInfo.querySelectorAll('.listRow');
        document.getElementById(thisObj).classList.toggle('activeIcon');            
            if(loadDataInfo.classList.contains('active') || loadDataInfo.classList.contains('loadDataInfo')){
                for(var i=0; i<rowDetailAll.length; i++){
                  listRowAll[i].classList.remove('activeIcon');  
                  rowDetailAll[i].classList.remove('activeRow');
               }
            }           
 
        loadDataInfo.classList.toggle('active');
	},
    
    detailInfo : function(component, event, helper) {
         var thisObj = event.target.name;         
         document.getElementById(thisObj).classList.toggle('activeRow');  
     }, 
})