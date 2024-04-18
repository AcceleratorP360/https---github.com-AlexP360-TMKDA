({
    getDaAttestatioRecord : function(cmp, event, helper) {
        this.showToast(cmp, event, helper, 'Info', 'Click on the Send Attestation Form button on the top-right corner', 'Success')
    },
    
    showToast : function(cmp, event, helper, type, message, title) {
        var toastEvent = $A.get("e.force:showToast"); 
        toastEvent.setParams({
            title : title,
            message: message,
            duration:' 2000',
            key: 'info_alt',
            type: type,
            mode: 'dismissible'
        });
        toastEvent.fire();
    }
})