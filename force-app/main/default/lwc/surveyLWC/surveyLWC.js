import { LightningElement, track, api, wire } from 'lwc';
import getActiveSurveys from '@salesforce/apex/SurveyController.getActiveSurveys';
//import CreateSurveyInvWrpResult from '@salesforce/apex/SurveyController.CreateSurveyInvWrpResult';
import getSurveyVersion from '@salesforce/apex/SurveyController.getSurveyVersion';
import getRelatedContacts from '@salesforce/apex/SurveyController.getRelatedContacts';
import CreateSurveyInvitation from '@salesforce/apex/SurveyController.CreateSurveyInvitation';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { getRecord } from 'lightning/uiRecordApi';
const FIELDS = ['Account.P360_Contact__c'];

export default class SampleSurvey extends LightningElement {
    @track error;
    @api recordId;
    @track selectedSurvey;
    @track selectedSurveyId;
    @track surveyOptions;
    @track showModal = false;
	  @track showModal1 = false;
    @track surveyUrl;
	  @track contacts = [];
		@track selectedContactEmail;
		@track selectedContact;
		@api account;
		

   /* @wire(getRecord,{recordId:'$recordId',fields:FIELDS}) account;
		connectedcallback(){
				this.Opensurvey1();
		}*/
		
   @api surveyVId;
		@wire(getSurveyVersion,{versionId: '$selectedSurvey'}) wiresurveyVersionId(result){
				if(result.data){
						this.surveyVId = result.data.Id;
						
						
						
				}
		}
		
		
	@wire(getRelatedContacts,{accid:'$recordId'})getRelatedContctsData;
    get contactOptions() {
        return this.getRelatedContctsData.data.map(contact => ({
            label: contact.Name,
            value: contact.Id
        }));
     }
	
		connectedCallback() {
     this.setDefaultValues();
    }
		setDefaultValues(){
				if(this.getRelatedContctsData.data && this.getRelatedContctsData.data.length >0){
						const defaultcontact = this.getRelatedContctsData.data[0];
						this.selectedContact = defaultcontact.Id;
						this.selectedContactEmail = defaultcontact.Email;
						//alert(this.selectedContactEmail);
				}
		}
    handleComboboxChange(event){
				
				this.selectedContact = event.target.value;
				const selectedContact = this.getRelatedContctsData.data.find(contact => contact.Id === this.selectedContact);
        this.selectedContactEmail = selectedContact ? selectedContact.Email : '';
				
        
				console.log('Contact lookup field value',this.selectedContact);
				console.log('Selected Contact Email address----',this.selectedContactEmail);
				
		}
	
		
		
    @wire(getActiveSurveys)
    wiredSurveys({ error, data }) {
        if (data) {
            this.surveyOptions = data.map(item => ({
                label: item.Name,
                value: item.Id
            }));
        } else if (error) {
            this.error = error;
            console.error('Error loading survey invitations', error);
        }
    }
		
		

  /*  Opensurvey() {
				console.log('SUrvey ID-----------------'+this.selectedSurvey);
        CreateSurveyInvWrpResult({ accId: this.recordId, surveyName: this.selectedSurvey })
            .then(result => {
                if (!result.bError) {
                    this.selectedSurveyId = result.surveyInvitationId;
										
                    this.surveyUrl = 'https://tmkis--tmkdev01.sandbox.my.site.com/survey/runtimeApp.app?surveyId='+this.selectedSurveyId;
    
										this.showModal = true; // Open the modal after creating the survey
                } else {
                    console.error('Error creating survey invitation', result.strMsg);
                }
            })
            .catch(error => {
                this.error = error;
                console.error('In error', this.error);
            });
    }*/
		
		Opensurvey1(){
				
				//const selectContactId = event.target.value;
				//console.log('Before Value',selectContactId);

            if (this.getRelatedContctsData.data) {
                console.log('Contacts are', this.getRelatedContctsData.data);
                const defaultcontact = this.getRelatedContctsData.data[0];
								
				
								
										
										this.selectedContact = defaultcontact.Id;
										const selectedContact = this.getRelatedContctsData.data.find(contact => contact.Id === this.selectedContact);								
										this.selectedContactEmail = selectedContact ? selectedContact.Email : '';
								
				console.log('Contact lookup field value1',selectedContact);
				console.log('Selected Contact Email address----1',this.selectedContactEmail);
								
								
										
				
								
				
       this.showModal1 = true;
            } else {
                console.error('No related contacts found.');
            }

				
		}
		
		closeModal1() {
        this.showModal1 = false;
    }

    handleFormSelection(event) {
        this.selectedSurvey = event.target.value;
				console.log('selected record'+this.selectedSurvey);
    }
		
		
sendEmail(event){
		CreateSurveyInvitation({accId:this.recordId,surveyId:this.selectedSurvey,email:this.selectedContactEmail,contid:this.selectedContact}).then(result=>{
				console.log('Succesfully sent an email');
				    const event = new ShowToastEvent({
        title: 'Success message',
        message: 'Succesfully sent an email to selected contact',
        variant: 'success',
        mode: 'dismissable'
    });
    this.dispatchEvent(event);
				
		});
		
			console.log(this.selectedContactEmail);
			console.log('Current Account Id---',this.recordId);
			console.log('SurveyVersionId------',this.surveyVId);
			console.log('Selected Survey ID-------',this.selectedSurvey);
		  console.log('Selected Contact Id----',this.selectedContact);
	}	
		
    onViewButtonClick() {
        if (!this.selectedSurvey) {
           console.error('No survey selected.');
						
            return;
        }
				

                //const surveyId = '0Ks3L0000004EPrSAM';
       this.surveyUrl = 'https://tmkis--tmkdev01.sandbox.lightning.force.com/survey/runtimeApp.app?surveyVersionId='+this.surveyVId+'&previewMode=true';
			 //this.surveyUrl = 'https://tmkis--tmkdev01.sandbox.lightning.force.com/survey/runtimeApp.app?surveyVersionId=0Ks3L0000004EPrSAM&previewMode=true';
				       this.showModal = true;
    }


    closeModal() {
        this.showModal = false;

       
    }
}