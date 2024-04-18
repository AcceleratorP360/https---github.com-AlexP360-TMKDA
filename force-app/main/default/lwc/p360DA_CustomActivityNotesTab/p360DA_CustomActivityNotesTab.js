import { LightningElement, api, track, wire } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import fatchNotes from '@salesforce/apex/P360DA_CustomActivityNotesTabCtrl.fatchNotes';
import insertNote from '@salesforce/apex/P360DA_CustomActivityNotesTabCtrl.insertNote';
import getRecordsName from '@salesforce/apex/P360DA_CustomDueDiligenceCtrl.getRecordsName';
import fatchNote from '@salesforce/apex/P360DA_CustomActivityNotesTabCtrl.fatchNote';
import deleteNote from '@salesforce/apex/P360DA_CustomActivityNotesTabCtrl.deleteNote';
import { registerListener, unregisterAllListeners } from 'c/pubsub';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class P360DA_CustomActivityNotesTab extends NavigationMixin(LightningElement) {
    dropdown = false;
    viewAllButton = false;
    newButtonDropBox = false;
    isDeleteButtonVisible = false;
    isDeleteButtonConformationModel = false;
    notes;
    totalNotesCount = 0;

    @api recordId;
    @track notesId = '';
    @track selectedRecord;
    @track titleValue = '';
    @track noteValue = '';
    @track titleName = '';
    @track isLoading = false;


    async connectedCallback() {
        registerListener('eventdetails', this.sutUpDetails, this);
        console.log('recordId:: >', this.recordId);
        this.notes = await fatchNotes({ recordId: this.recordId });
        console.log('notes :', this.notes);

        // Calculate the total length of notes
        this.totalNotesCount = this.notes ? this.notes.length : 0;
        if (this.notes.length > 3) {
            this.totalNotesCount = '3+';
        }

        // Update the viewAllButton based on the length of notes
        this.updateViewAllButton();
    }

    sutUpDetails(recordIds) {
        console.log('====recordIds===', recordIds);
        this.recordId = recordIds;
        this.connectedCallback();

    }

    get displayedItems() {
        let result = [];
        result = result.concat(this.notes.slice(0, 3));
        return result;
    }

    handleToggle() {
        this.dropdown = !this.dropdown;
    }

    // Helper method to update the viewAllButton based on the length of notes
    updateViewAllButton() {
        if (this.notes.length > 1) {
            this.viewAllButton = true;
        } else {
            this.viewAllButton = false;
        }
    }

    // handleToggleNew(){
    //     this[NavigationMixin.Navigate]({
    //         type: 'standard__objectPage',
    //         attributes: {
    //             objectApiName: 'ContentNote',
    //             actionName: 'new'
    //         }
    //     });
    // }

    handleProfileClick(event) {
        const userId = event.currentTarget.dataset.userid;
        console.log('===userId===' + userId);
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: userId,
                objectApiName: 'User',
                actionName: 'view'
            }
        });
    }

    handleUpdateNotes(event){
        this.isLoading = true;
        this.notesId = event.currentTarget.dataset.userid;
        console.log('===this.notesId===',this.notesId);
        fatchNote({ recordId: this.notesId })
        .then(result => {
                console.log('result===',result);
                if(result != null){
                    this.titleValue = result.title;
                    this.noteValue = result.content;
                    this.titleName = result.title;
                    this.newButtonDropBox = true;
                    this.isDeleteButtonVisible = true;
                }
        })
        .catch(error => {
            console.log('Errorured:- '+error.body.message);
        })
        .finally(() => {
            this.isLoading = false;
        });
    }

    handleViewAll() {
        console.log('===this.recordId====', this.recordId);
        this[NavigationMixin.Navigate]({
            type: 'standard__recordRelationshipPage',
            attributes: {
                recordId: this.recordId,
                relationshipApiName: 'AttachedContentNotes',
                actionName: 'view'
            }
        });
    }

    handleToggleNew() {
        this.titleValue = '';
        this.noteValue = '';
        this.notesId = '';
        this.titleName = '';
        this.newButtonDropBox = true;
        this.dropdown = false;
        this.isDeleteButtonVisible = false;
    }
    handleCancleButton() {
        this.newButtonDropBox = false;
        this.titleValue = '';
        this.noteValue = '';
        this.notesId = '';
    }

    @wire(getRecordsName, { recordId: '$recordId' })
    wiredData({ error, data }) {
        if (data) {
            console.log('data from ApexgetRecordsName===:', data);
            if (data != null) {
                this.selectedRecord = data;
            }
        } else if (error) {
            console.error('Error calling Apex:', error);
        }
    }

    // InsertNote
    handleDoneButton() {
        console.log("Title: ", this.titleValue);
        console.log("Note: ", this.noteValue);

        // Invoke the insertNote Apex method using @wire
        // this.wiredInsertNote({ recordId: this.recordId, title: this.titleValue, content: this.noteValue });
        this.isLoading = true;
        insertNote({
            recordId: this.recordId,
            title: this.titleValue,
            content: this.noteValue,
            notesId : this.notesId
        })
        .then(result => {
            console.log('Insert Note Successful:', result);
            this.newButtonDropBox = false;
            if(result == 'isUpdated'){
                const event = new ShowToastEvent({
                    message: 'Your note was Updated.',
                    variant: 'success',
                    mode: 'dismissable'
                }); 
                this.dispatchEvent(event);
            }else{
                const event = new ShowToastEvent({
                    message: 'Your note was created.',
                    variant: 'success',
                    mode: 'dismissable'
                });
                this.dispatchEvent(event);
            }
            this.connectedCallback();
        })
        .catch(error => {
            console.error('Error inserting note:', error);
        })
        .finally(() => {
            this.isLoading = false;
        });
    }
    handleTitleChange(event) {
        this.titleValue = event.target.value;
        this.titleName = event.target.value;
    }

    handleNoteChange(event) {
        this.noteValue = event.target.value;
    }


    handleDeleteButton() {
        this.isDeleteButtonConformationModel = true;
    }
    handleNoteRecordDelete(){
        fatchNote({ recordId: this.notesId })
            .then(result => {
                console.log('result===', result);
                this.isDeleteButtonConformationModel = false;
                this.newButtonDropBox = false;
                if (result != null) {
                    // Call the Apex method to delete the note
                    deleteNote({ noteId: this.notesId })
                        .then(deleteResult => {
                            console.log('deleteResult===', deleteResult);
                            if (deleteResult === 'isDeleted') {
                                // Perform any necessary actions after successful deletion
                                console.log('Note deleted successfully.');
                                this.updateViewAllButton();
                                const event = new ShowToastEvent({
                                message: 'Record was deleted.',
                                variant: 'success',
                                mode: 'dismissable'
                            }); 
                            this.dispatchEvent(event);
                            } else {
                                // Handle the case where deletion was not successful
                                console.error('Error deleting note:', deleteResult);
                            }
                            this.connectedCallback();
                        })
                        .catch(error => {
                            console.error('Error deleting note:', error);
                        });
                }
            })
            .catch(error => {
                console.log('Errorured:- ' + error.body.message);
            });
    }
    handleNoteRecordCancle(){
        this.isDeleteButtonConformationModel = false;
    }


}