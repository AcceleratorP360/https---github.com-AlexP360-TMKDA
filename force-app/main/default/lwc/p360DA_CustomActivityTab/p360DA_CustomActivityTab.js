import { LightningElement, api, track, wire } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import { registerListener, unregisterAllListeners } from 'c/pubsub';
import gettaskOrEvent from "@salesforce/apex/P360DA_CustomActivityTabCtrl.getTasksAndEvents";
import getpicklistvalue from '@salesforce/apex/P360DA_CustomActivityTabCtrl.fetchvalue';
import deleteRec from '@salesforce/apex/P360DA_CustomActivityTabCtrl.deleteRec';
import getRecordsName from '@salesforce/apex/P360DA_CustomDueDiligenceCtrl.getRecordsName';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import createCall from '@salesforce/apex/P360DA_CustomActivityTabCtrl.createCall';
import createEventData from '@salesforce/apex/P360DA_CustomActivityTabCtrl.createEventData';
import fetchuser from '@salesforce/apex/P360DA_CustomActivityTabCtrl.userinfo';
import { defaultInputDate } from './helper';



export default class P360DA_CustomActivityTab extends NavigationMixin(LightningElement) {

    @api recordId;
    showdata = false;
    subscription = null;
    display = false;
    @track data;
    username;
    userId;

    @track minimized = false;
    newTask = false;
    callLog = false;


    @track picklistvalue = [];
    @track value = 'Call';
    @track selectedRecord;
    @track eventsubjectV = [];
    callComment = '';
    dueData;
    WhoId;

    @track isLoading = false;


    // event variable
    e_value='New Event';
    event_Description;

    eventUtitlityBar = false;
    @track locationValue = '';

    @api rangeInMillisecs;
    @api startDate;
    @api endDate;
    @api startDateLabel;
    @api endDateLabel;


    async connectedCallback() {
        registerListener('eventdetails', this.sutUpDetails, this);
        console.log('connectedCallback : recordId : ', this.recordId);
        await this.getRelatedFilesRecord();
        await this.fetchtasksubjectvalue();
        await this.fetcheventSubjectvalue();
        const range = this.rangeInMillisecs;
        const { startDate, endDate } = defaultInputDate(range);

        this.startDate = startDate;
        this.endDate = endDate;

    }

    sutUpDetails(recordIds) {
        console.log('====recordIds===', recordIds);
        this.recordId = recordIds;
        this.connectedCallback();
    }

    async getRelatedFilesRecord() {
        gettaskOrEvent({ accountId: this.recordId })
            .then(result => {
                console.log('result===', JSON.stringify(result));
                this.data = result;
            })
            .catch(error => {
                console.log('Errorured:- ' + error.body.message);
            });
    }
    
    openEventPage() {
        //   this[NavigationMixin.Navigate]({
        //         type: 'standard__objectPage',
        //         attributes: {
        //             objectApiName: 'Event',
        //             actionName: 'new'
        //         },
        //         state: {
        //             defaultFieldValues: `WhatId=${this.recordId}&Subject=Call`
        //             // Add other default field values as needed
        //         }
        //     });

        this.eventUtitlityBar = true;
    }

    eventCloseButton() {
        this.eventUtitlityBar = false;
    }

    // Date time funtionality
    constructor() {
        super();
        this.rangeInMillisecs = 3600000; // 3600000 ms = 1 hour
        this.startDateLabel = 'Start date';
        this.endDateLabel = 'End date';
    }

    

    handleStartDateChange(event) {
        const currentStartDate = new Date(event.target.value);
        this.startDate = currentStartDate.toISOString();

        const newEndDate = new Date(currentStartDate);
        newEndDate.setTime(currentStartDate.getTime() + this.rangeInMillisecs);

        this.endDate = newEndDate.toISOString();

        this.dispatchEvent(createEvent({ startDate: this.startDate, endDate: this.endDate }));

        console.log('====startDate===='+this.startDate);
    }

    handleEndDateChange(event) {
        const currentStartDate = new Date(this.startDate);
        const currentEndDate = new Date(event.target.value);

        if (currentEndDate <= currentStartDate) {
            const newStartDate = new Date(currentEndDate);
            newStartDate.setTime(currentEndDate.getTime() - this.rangeInMillisecs);

            this.startDate = newStartDate.toISOString();
        }
        else if (currentEndDate > currentStartDate) {
            const timeInterval = (currentEndDate - currentStartDate);

            this.rangeInMillisecs = timeInterval;
        }

        this.endDate = currentEndDate.toISOString();

        this.dispatchEvent(createEvent({ startDate: this.startDate, endDate: this.endDate }));

        console.log('====endDate===='+this.endDate);
    }


    //fetch related record name
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



    // fetch user name and id
    @wire(fetchuser)
    wiredData1({ error, data }) {
        if (data) {
            if (data != null) {
                console.log('userinfo=============', JSON.stringify(data));
                this.username = data.username;
                this.userId = data.userId;
            }
        } else if (error) {
            console.error('Error calling Apex:', error);
        }
    }



    // fetch picklistvalue for task subject field
    // @wire(getpicklistvalue)
    // wiredContacts({ error, data }) {
    //     if (data) {
    //         this.picklistvalue = data;
    //         console.log('picklist===',this.picklistvalue);
    //     } else if (error) {
    //         console.log('error=='+JSON.stringify(error));
    //     }
    // }

    async fetchtasksubjectvalue() {
        getpicklistvalue({ objectName: 'Task', fieldName: 'Subject' })
            .then(data => {
                this.picklistvalue = data;
                console.log('task subject===', data);
            })
            .catch(error => {
                console.log('Errorured:- ' + error.body.message);
            });
    }


    async fetcheventSubjectvalue() {
        getpicklistvalue({ objectName: 'Event', fieldName: 'Subject' })
            .then(data => {
                this.eventsubjectV = data;
                console.log('event subject===', data);
            })
            .catch(error => {
                console.log('Errorured:- ' + error.body.message);
            });
    }



    handleChange(event) {
        console.log('data---', event.detail.value);
        this.value = event.detail.value;
    }

   

    openTaskPage() {
        // this[NavigationMixin.Navigate]({
        //     type: 'standard__objectPage',
        //     attributes: {
        //         objectApiName: 'Task',
        //         actionName: 'new'
        //     },
        //     state: {
        //         defaultFieldValues: `WhatId=${this.recordId}&Subject=Call`
        //         // Add other default field values as needed
        //     }
        // });

        this.newTask = true;
        console.log('OUTPUT : newTask openTask');

    }

    handleMenuItemClick() {
        this.newTask = true;
        console.log('OUTPUT : newTask openTask');
    }

    closeTask() {
        this.newTask = false;
        this.callLog = false;

    }



    minimizeWindow() {
        this.minimized = !this.minimized;
    }

    openLogACallPage() {
        console.log('open task');
        // this[NavigationMixin.Navigate]({
        //     type: 'standard__objectPage',
        //     attributes: {
        //         objectApiName: 'Task',
        //         actionName: 'new'
        //     },
        //     state: {
        //         defaultFieldValues: 
        //             'Subject=Log%20a%20Call&TaskSubtype=Call'
        //             // Add more default field values as needed, separated by "&"
        //     }
        // });


        this.callLog = true;
    }


    viewRecord(event) {

        console.log('event==', event.currentTarget.name);
        console.log('event==', event.currentTarget.type);

        let objname = (event.currentTarget.type == 'Call') ? 'Task' : event.currentTarget.type;


        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: event.currentTarget.name,
                objectApiName: objname,
                actionName: 'view'
            },
        });

    }




    handleCalendarOpen() {
        this[NavigationMixin.GenerateUrl]({
            type: 'standard__objectPage',
            attributes: {
                objectApiName: 'Event',
                actionName: 'home'
            },
        }).then(url => {
            window.open(url, '_blank');
        });
    }

    showMenu(event) {
        event.stopPropagation();
        console.log('show fun called');
        let item = event.target.title;
        let section = event.target.name;

        let m = this.template.querySelectorAll('.menu1');

        Array.from(m).forEach(e => {
            if (e.getAttribute('name') == section && e.title == item) {
                if (!Array.from(e.classList).includes('slds-is-open')) {
                    e.classList.add('slds-is-open');
                }
                else {
                    e.classList.remove('slds-is-open');
                }
            }
            else {
                e.classList.remove('slds-is-open');
            }
        });



    }

    opentimeline(event) {
        console.log('opentimeline called');
        let a1 = JSON.parse(JSON.stringify(this.data))

        if (a1[event.target.name].Tast_evet_data[event.target.title].display) {
            a1[event.target.name].Tast_evet_data[event.target.title].display = false;
        }
        else {
            try {
                a1[event.target.name].Tast_evet_data[event.target.title].display = true;
            }
            catch (e) {
                console.log('e==', e);
            }

        }

        event.stopPropagation();
        let a = ['slds-button', 'slds-button_icon'];
        this.toggle(event.target.classList, event.currentTarget.classList, a);
        this.data = [...a1];
    }

    opensection(event) {
        console.log('open section ', event.target.classList);
        console.log('open curr', event.currentTarget.classList);
        let a = ['slds-accordion__summary-content', 'slds-button', 'slds-accordion__summary-action', 'slds-button_reset', 'summary-name'];
        this.toggle(event.target.classList, event.currentTarget.classList, a);
    }

    toggle(t, c, a) {
        let result = false;
        if (Array.from(t).length > 0) {
            result = Array.from(t).every(e => a.includes(e));
        }

        if (result) {
            if (!Array.from(c).includes('slds-is-open')) {
                c.add("slds-is-open");
            }
            else {
                c.remove("slds-is-open");
            }
        }

    }


    getduedata(event) {
        console.log('due data==', event.target.value);
        this.dueData = event.target.value;
    }

    // log call create

    handleSaveButtonClick(event) {
        this.isLoading = true;
        console.log('name==', event.target.name);
        try {
            var datavalue;
            if (event.target.name == 'call') {
                datavalue = {
                    'WhatId': this.recordId,
                    'Description': this.callComment,
                    'TaskSubtype': 'Call',
                    'Status': 'Completed',
                    'Subject': this.value,
                    'WhoId': this.WhoId
                };
            }
            if (event.target.name == 'task') {
                datavalue = {
                    'WhatId': this.recordId,
                    'TaskSubtype': 'Task',
                    'Status': 'Completed',
                    'Subject': this.value,
                    'ActivityDate': this.dueData,
                    'OwnerId': this.userId,
                    'WhoId': this.WhoId
                };
            }

            console.log('call===', JSON.stringify(datavalue));

            createCall({ obj: datavalue })
                .then((result) => {
                    console.log('response==', result);
                    console.log('response==', JSON.stringify(result));

                    this.getRelatedFilesRecord();

                    setTimeout(() => {
                        const event = new ShowToastEvent({
                            message: 'Task created successfully',
                            variant: 'success',
                            mode: 'dismissable'
                        });
                        this.dispatchEvent(event);

                        this.newTask = false;
                        this.callLog = false;
                        this.isLoading = false;
                    }, 2000);
                })
                .catch((error) => {
                    console.log('error======', error);
                });
            //location.reload();
        }
        catch (e) {
            console.log('error ====', e);
        }

    }

    getComment(event) {
        this.callComment = event.target.value;
    }

    handleEventSaveButtonClick(event){
        this.isLoading = true;
        console.log('name==', event.target.name);
        try {
            var eventValue;
            if (event.target.name == 'event'){
                eventValue = {
                    'WhatId': this.recordId,
                    'Subject': this.e_value,
                    'Description': this.event_Description,
                    'StartDateTime': this.startDate,
                    'EndDateTime': this.endDate,
                    'Location': this.locationValue,
                    'TaskSubtype': 'Event',
                    'Status': 'Completed',
                    'WhoId': this.WhoId
                };
            }
            createEventData({ objc: eventValue })
                .then((result) => {
                    console.log('Event Data res==', result);
                    console.log(' Evrnt response==', JSON.stringify(result));
                    this.getRelatedFilesRecord();

                    setTimeout(() => {
                        const event = new ShowToastEvent({
                            message: 'Event created successfully',
                            variant: 'success',
                            mode: 'dismissable'
                        });
                        this.dispatchEvent(event);

                        this.eventUtitlityBar = false;
                        this.isLoading = false;
                    }, 2000);
                })
                .catch((error) => {
                    console.log('error======', error);
                });
        }
        catch (e) {
            console.log('error ====', e);
        }
    }
    // renderedCallback(){
    //     const style = document.createElement('style');
    //     style.innerText = `.slds-accordion__summary-action  {
    //             background: var(--slds-g-color-neutral-base-95, var(--lwc-colorBackground,rgb(243, 243, 243)));
    //             border: none;
    //         }
    //         .slds-accordion__list-item{
    //             border: none;
    //         }
    //     `;  

    //     this.template.querySelector('.slds-docked_container').appendChild(style);

    // }


    handleMessage(event) {
        const selectedRecord = event.detail.selectedRecord;
        this.WhoId = selectedRecord.Id;
        console.log('Selected Record:', JSON.stringify(selectedRecord));
    }

    async opentaskhandler(event) {
        event.preventDefault();
        event.stopPropagation();
        console.log('c==', event.currentTarget);
        let name = (event.currentTarget.name == 'Call') ? 'Task' : event.currentTarget.name;
        let id = event.currentTarget.getAttribute('idv');
        await this.opentask_Event_handler(name, id);
        console.log('===bb data===');
        setTimeout(() => {

            this.getRelatedFilesRecord();
        })

    }

    deleteTaskHandler(event){
        this.isLoading = true;
        let id = event.currentTarget.getAttribute('idv');
        console.log('=====id====',id);
        let name = (event.currentTarget.name == 'Call') ? 'Task' : event.currentTarget.name;
        console.log('=====name====',name);
        deleteRec({ recId: id , recName : name})
        .then((result) => {
            console.log('response==', result);
            console.log('response==', JSON.stringify(result));
            if(result == 'isDeleted'){
                this.getRelatedFilesRecord();

                setTimeout(() => {
                    const event = new ShowToastEvent({
                        message: 'Task created successfully',
                        variant: 'success',
                        mode: 'dismissable'
                    });
                    this.dispatchEvent(event);
                    this.isLoading = false;
                }, 1000);
            }
        })
        .catch((error) => {
            console.log('error======', error);
        });
    }

    opentask_Event_handler(name, id) {
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: id,
                objectApiName: name,
                actionName: 'edit'
            },
        });

    }




    // event create function

    handleChangeevent(event)
    {
         this.e_value = event.detail.value;
    }

    getdiscrption(event)
    {
        this.event_Description = event.target.value;
        console.log('=====Event Description====='+this.event_Description);
    }

    handleLocationChange(event){
        this.locationValue = event.target.value;
        console.log('=====Location====='+this.locationValue);
    }

    // handleStartDateChange(event){
    //     this.startDate = event.target.value;
    //     console.log('====startDate===='+this.startDate);
    // }
  



}
function createEvent(data) {
        console.log('despach event data==');
        const event = new CustomEvent('getdatevalues', {
            detail: data
        });

        return event;
}