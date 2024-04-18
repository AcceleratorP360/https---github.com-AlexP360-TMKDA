import { LightningElement, wire, api, track } from 'lwc';
import {NavigationMixin} from 'lightning/navigation';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import TIME_ZONE from '@salesforce/i18n/timeZone';
import getRelatedFilesRecord from '@salesforce/apex/P360DA_CustomActicityFilesCtrl.getRelatedFilesRecord';
import uploadFiles from '@salesforce/apex/P360DA_CustomActicityFilesCtrl.uploadFiles';
import { registerListener, unregisterAllListeners } from 'c/pubsub'; 

export default class P360DA_CustomActivityFiles extends NavigationMixin(LightningElement) {

    @api recordId;
    @api objectApiName;
    @track filesList = [];
    @track selectedFilesList = [];
    @track selectedFilesName = [];
    fileData;
    fileCount = 0;

    // Flags
    isSpinner = false;
    isUploadSpinner = false;
    isFilesListModal = false;

    async connectedCallback() {
        registerListener('eventdetails', this.sutUpDetails, this); 
        console.log('connectedCallback : recordId : ',this.recordId, TIME_ZONE);
        await this.getRelatedFilesRecord();

    }

    sutUpDetails(recordIds){ 
        console.log('====recordIds===',recordIds);
        this.recordId = recordIds; 
        this.connectedCallback();

    } 

    async getRelatedFilesRecord() {
        this.isSpinner = true;
        await getRelatedFilesRecord({'recordId':this.recordId})
        .then((result) => {
            
            this.filesList = result.map(ele => {
                return {
                    ...ele,
                    "size" : Math.trunc(ele["ContentSize"] / 1024) + "KB",
                    "date": this.formateDataValue(ele["SystemModstamp"])
                }
            });
            this.fileCount = this.filesList.length > 3 ? '3+' : this.filesList.length;
            console.log('getRelatedFilesRecord result : ',JSON.stringify(this.filesList));
        }).catch((error) => {
            console.log('getRelatedFilesRecord error : ',error);
            console.log('getRelatedFilesRecord error : ',error.stack);
        });
        this.isSpinner = false;
    }

    openFileUpload(event){
        // console.log('openFileUpload : ');
        var files = event.target.files;
        if (files.length > 0) {
            // console.log('OUTPUT : ',files);
            for(var i=0; i< files.length; i++){
                let file = files[i];
                this.selectedFilesName.push(file.name);

                let reader = new FileReader();
                reader.onload = e => {
                    var fileContents = reader.result.split(',')[1];
                    this.selectedFilesList.push({'filename':file.name, 'base64':fileContents});
                    // console.log('OUTPUT : ',this.selectedFilesList.length);
                };
                reader.readAsDataURL(file);
            }
        }
        this.handleOpenSelectedFilesModal();

    }

    async handleSelectedFilesUpload(){
        
        this.isUploadSpinner = true;
        this.handleCloseSelectedFilesModal();

        await uploadFiles({'filesList':this.selectedFilesList, 'recordId':this.recordId})
        .then((result)=>{
            
            console.log('handleSelectedFiles : result : ', result);  
            result = JSON.parse(result);
            this.showToast('',result['status'], result['message']);            
        })
        .catch((error)=>{
            console.log('handleSelectedFiles : ',error);
            console.log('handleSelectedFiles : ',error.stack);
        })
        this.clearSelection();
        this.isUploadSpinner = false;

        await this.getRelatedFilesRecord();

    }

    handleAddFile(){
        console.log('handleAddFile clicked ');
        const fileInput = this.template.querySelector('input[type="file"]');
        console.log('handleAddFile fileInput : ',fileInput);
        fileInput.click();
    }

    formateDataValue(inputDate){

        try{
            let date = new Date(inputDate);
            const months = [
                "Jan", "Feb", "Mar", "Apr",
                "May", "Jun", "Jul", "Aug",
                "Sep", "Oct", "Nov", "Dec"
            ];
            const options = {
                year: "numeric",
                month: "numeric",
                day: "numeric",
                hour: "numeric",
                minute: "numeric",
                second: "numeric",
                hour12: false,
                timeZone: this.timeZone,
            };

            date = new Date(new Intl.DateTimeFormat('en-US', options).format(date));

            let formattedDate = `${months[date.getMonth()]} ${date.getDate()}, ${date.getFullYear()}`;

            return formattedDate;
        }catch(error){
            console.log('formateDataValue : error ',error.stack);
        }
        return null
    }

    handleViewAll(){
        console.log('===this.recordId====',this.recordId);
        console.log('===this.objectApiName====',this.objectApiName);
         this[NavigationMixin.Navigate]({
            type: 'standard__recordRelationshipPage',
            attributes:{
                recordId: this.recordId,
                objectApiName: this.objectApiName,
                relationshipApiName: 'AttachedContentDocuments',
                actionName: 'view'
            }
        });
    }

    previewHandler(event){
         console.log('===previewHandler===');
        console.log(event.target.dataset.id)
        this[NavigationMixin.Navigate]({ 
            type:'standard__namedPage',
            attributes:{ 
                pageName:'filePreview'
            },
            state:{ 
                selectedRecordId: event.target.dataset.id
            }
        })
    }

    handleRemoveSelectedFile(event){
        let index = event.target.dataset.index;
        this.selectedFilesName.splice(index,1);
        this.selectedFilesList.splice(index,1);
        if(this.selectedFilesName.length <= 0){
            this.handleCloseSelectedFilesModal();
            this.clearSelection();
        }
    }

    handleOpenSelectedFilesModal(){
        this.isFilesListModal = true;
    }

    handleCloseSelectedFilesModal(){
        this.isFilesListModal = false;
    }

    handleCloseModal(){
        this.handleCloseSelectedFilesModal();
        this.clearSelection();
    }

    clearSelection(){
        this.selectedFilesList = [];
        this.selectedFilesName = [];

        const fileInput = this.template.querySelector('input[type="file"]');
        fileInput.value = "";
    }

    showToast(title, variant, message) {
        this.dispatchEvent(
            new ShowToastEvent({
                title: title,
                variant: variant,
                message: message,
            })
        );
    }
}