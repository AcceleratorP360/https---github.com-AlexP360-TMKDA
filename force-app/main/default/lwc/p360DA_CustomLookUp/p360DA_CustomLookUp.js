import { LightningElement, api, wire, track } from 'lwc';
import getLookupObjectList from '@salesforce/apex/P360DA_CustomLookUpCtrl.getLookupObjectList';
import searchLookupData from '@salesforce/apex/P360DA_CustomLookUpCtrl.searchLookupData';
import searchDefaultRecord from '@salesforce/apex/P360DA_CustomLookUpCtrl.searchDefaultRecord';

export default class P360DA_CustomLookUp extends LightningElement {
    
    @api label = "Name";
    @api fieldApiName = 'Name';
    @api sObjectApiName = 'Contact';
    @api objectNameList = ['Contact', 'Lead'];
    @api selectedObjectName = 'Contact';
    @api selectedRecord;
    @api disabled = false;
    @api defaultRecordId = '';

    @track arrayOfObjects = [];
    @track placeholder = 'Search Contact...';

    

    lstResult = [];
    searchKey = '';
    isValueSelected;
    delayTimeout;
    iconName = 'standard:contact';

    hasRecords = true;
    isSearchLoading = false;
    isSearchLoading = false;
    isDefaultLoaded = false;

    connectedCallback() {
        // Creating the first object
        let object1 = { objName: 'Contact', iconName: 'standard:contact' };

        // Creating the second object
        let object2 = { objName: 'Lead', iconName: 'standard:lead' };

        // Adding objects to the array
        this.arrayOfObjects.push(object1, object2);
        if(!this.objectNameList.length){

            getLookupObjectList({ sObjectName: this.sObjectApiName , fieldName : this.fieldApiName })
            .then((result) => {
                if(result != null){
                    this.objectNameList = JSON.parse(result);
                    if(!this.selectedObjectName){
                        this.selectedObjectName = this.objectNameList[0];
                    }
                }
            })
            .catch((error) => {
                console.log('getLookupObjectList error : ',error);
            });
        }else{
            if(!this.selectedObjectName){
                this.selectedObjectName = this.objectNameList[0];
            }
        }
        

        if(this.defaultRecordId != ''){
            console.log('OUTPUT : default');
            searchDefaultRecord({ recordId: this.defaultRecordId , sObjectApiName : this.selectedObjectName })
            .then((result) => {
                if(result != null){
                    
                    this.selectedRecord = result;
                    this.handelSelectRecordHelper();
                }
            })
            .catch((error) => {
                console.log('searchDefaultRecord error : ',error);
                this.selectedRecord = {};
            });
         }
    }

    renderedCallback(){
        if(this.isDefaultLoaded) return;
        this.isDefaultLoaded = true;
        if(this.selectedRecord?.Name){
            this.setSelectedObject();
            this.handelSelectRecordHelper();
        }
    }

    @wire(searchLookupData, { searchKey: '$searchKey' , sObjectApiName : '$selectedObjectName'})
    searchResult(value) {
        const { data, error } = value;
        this.isSearchLoading = false;

        if (data) {
             this.hasRecords = data.length == 0 ? false : true; 
             this.lstResult = JSON.parse(JSON.stringify(data)); 
             console.log('searchResult result' + this.lstResult);
         }
        else if (error) {
            console.log('searchResult error ' + JSON.stringify(error));
        }
    };

    @api
    handleDefaultRecordSelect(){
        if(this.defaultRecordId != ''){
            
            searchDefaultRecord({ recordId: this.defaultRecordId , sObjectApiName : this.selectedObjectName })
            .then((result) => {
                if(result != null){
                    this.selectedRecord = result;
                    this.handelSelectRecordHelper();
                }
            })
            .catch((error) => {
                console.log('handleDefaultRecordSelect error : ',error);
                this.selectedRecord = {};
            });
        }else{
            this.handleRemove();
        }
    }

    openDropdown(event)
    {
        const lookupInputContainer = this.template.querySelector('.lookupInputContainer');
        const clsList = lookupInputContainer.classList;
        const whichEvent = event.target.getAttribute('data-source');
        switch(whichEvent) {
            case 'searchInputField':
                clsList.add('slds-is-open');
               break;
            case 'lookupContainer':
                clsList.remove('slds-is-open');    
            break;                    
           }
    }

    openObjectDropdown(event)
    {
        const objectInputContainer = this.template.querySelector('.objectInputContainer');
        const clsList = objectInputContainer.classList;
        const whichEvent = event.target.getAttribute('data-source');
        switch(whichEvent) {
            case 'objectDropdown':
                clsList.add('slds-is-open');
                break;
            case 'objectContainer':
                clsList.remove('slds-is-open');    
                break;                    
        }
    }

    handlesObjectSelection(event)
    {       
        console.log('========',event.target.getAttribute('title'));
        this.selectedObjectName = event.target.getAttribute('title');
        this.setSelectedObject();
        this.handleRemove();
    }

    setSelectedObject(){
        this.iconName = 'standard:'+this.selectedObjectName.toLowerCase();
        if(this.selectedObjectName == 'Contact'){
            this.placeholder = 'Search Contact...';
        }else{
            this.placeholder = 'Search Lead...';
        }
        
        const objectInputContainer = this.template.querySelector('.objectInputContainer');
        const clsList = objectInputContainer.classList;
        clsList.remove('slds-is-open');
        
    }
  
    handleRemove(){
        this.searchKey = '';    
        this.selectedRecord = {};
        //this.lookupUpdateParenthandler(undefined);
        this.isValueSelected = false; 
    }

    handelSelectedRecord(event){
        var objId = event.target.getAttribute('data-recid');
        console.log('===objId=====',objId);
        this.selectedRecord = this.lstResult?.find(data => data.Id === objId);
        console.log('===this.selectedRecord=====',this.selectedRecord);
        this.selectedRecord.apiName = this.fieldApiName;
        console.log('===this.this.selectedRecord.apiName=====',this.selectedRecord.apiName);
        this.selectedRecord.objectName = this.selectedObjectName; 
        console.log('=this.selectedRecord.objectName ==',this.selectedRecord.objectName);
        this.lookupUpdateParenthandler(this.selectedRecord);
        this.handelSelectRecordHelper();
    }

    handelSelectRecordHelper(){
        const elem = this.template.querySelector('.lookupInputContainer');
        if(elem) elem.classList.remove('slds-is-open');
        this.isValueSelected = true; 
        
    }

    lookupUpdateParenthandler(value){
        const oEvent = new CustomEvent('update',
            {
                'detail': {selectedRecord: value}
            }
        );
        this.dispatchEvent(oEvent);
    }
  
    handleKeyChange(event) {
        this.isSearchLoading = true;
        window.clearTimeout(this.delayTimeout);
        const searchKey = event.target.value;
        this.delayTimeout = setTimeout(() => {
            this.searchKey = searchKey;
        }, 300);
    }
}