import {
    LightningElement,
    track,
    wire
} from 'lwc';
import incoming_Emails from '@salesforce/apex/EmailListCtrl.incoming_Emails';
import getObjAPI from '@salesforce/apex/EmailListCtrl.getObjAPI';
import findObjectNameFromRecordIdPrefix from '@salesforce/apex/EmailListCtrl.findObjectNameFromRecordIdPrefix';
import getPicklistValues from '@salesforce/apex/EmailListCtrl.getPicklistValues';
import {
    NavigationMixin
} from 'lightning/navigation';

export default class EmailMessageLWC extends NavigationMixin(LightningElement) {

    inboxMails;
    errorMsg;
    loaded = false;
    subject = '';
    isInbox;
    fromAddress = '';
    fromDate = null;
    toDate = null;
    options = [];
    toAddress = '';
    isHide = true;
    isAttachment;
    selectdObj = '';
    isInboxSection = false;
    isSentSection = false;
    isTrashSection = false;
    isDeleted = true;
    isDraftSection = false;
    isForwarded = false;
    isForward = false;
    isReplied = false;
    rly = false;
    fwd = false;
    emailTags = '';
    picklistOptions = [];
    selectedValues = [];
    relatedTo = '';
    isActioned = false;
    isIncoming = false;

    @wire(getPicklistValues, {
        objectName: 'EmailMessage',
        fieldName: 'P360_Email_Tags__c'
    })
    wiredPicklistValues({
        data,
        error
    }) {
        if (data) {
            this.picklistOptions = data.map(value => ({
                label: value,
                value: value
            }));
        } else if (error) {
            console.error(error);
        }
    }

    handlePicklistChange(event) {
        this.selectedValues = event.detail.value;
        // this.selectedValues.sort();
        const toSstring = this.selectedValues.join(',');
        const reString = toSstring.replaceAll(',', ';');
        this.emailTags = reString;
        this.loaded = true;
        incoming_Emails({
                status: this.isInbox,
                subject: this.subject,
                fromAddress: this.fromAddress,
                toAddress: this.toAddress,
                fromDate: this.fromDate,
                toDate: this.toDate,
                isAttachment: this.isAttachment,
                selectdObj: this.selectdObj,
                isDeleted: this.isDeleted,
                emailTags: this.emailTags,
                relatedTo: this.relatedTo,
                isActioned: this.isActioned,
                isIncoming: this.isIncoming
            })
            .then(result => {
                this.loaded = false;
                this.inboxMails = result;
            })
            .catch(error => {
                this.loaded = false;
                this.errorMsg = error;
                alert(JSON.stringify(this.errorMsg));
            })
    }

    connectedCallback() {
        this.loaded = true;
        this.isInbox = '0';
        this.isInboxSection = true;
        this.isSentSection = false;
        this.isTrashSection = false;
        this.isDraftSection = false;
        this.isDeleted = false;
        this.isForwarded = false;
        this.rly = true;
        this.fwd = false;
        this.isIncoming = true;
        incoming_Emails({
                status: this.isInbox,
                subject: this.subject,
                fromAddress: this.fromAddress,
                toAddress: this.toAddress,
                fromDate: this.fromDate,
                toDate: this.toDate,
                isAttachment: this.isAttachment,
                selectdObj: this.selectdObj,
                isDeleted: this.isDeleted,
                emailTags: this.emailTags,
                relatedTo: this.relatedTo,
                isActioned: this.isActioned,
                isIncoming: this.isIncoming
            })
            .then(result => {
                this.loaded = false;
                this.inboxMails = result;
            })
            .catch(error => {
                this.loaded = false;
                this.errorMsg = error;
            })
        findObjectNameFromRecordIdPrefix({
                status: this.isInbox,
                isDeleted: this.isDeleted,
                isActioned: this.isActioned,
            })
            .then(result => {
                let data = result;
                this.options = Object.keys(data).map(key => ({
                    label: data[key],
                    value: key
                }));
            })
            .catch(error => {
                console.error('Error fetching picklist options', error);
            })
    }
    get is_InboxSection() {
        return this.isInboxSection ? 'slds-vertical-tabs__nav-item slds-has-focus slds-is-active gold-utility-icon' : 'slds-vertical-tabs__nav-item slds-has-focus';
    }

    get is_SentSection() {
        return this.isSentSection ? 'slds-vertical-tabs__nav-item slds-has-focus slds-is-active gold-utility-icon' : 'slds-vertical-tabs__nav-item slds-has-focus';
    }

    get is_TrashSection() {
        return this.isTrashSection ? 'slds-vertical-tabs__nav-item slds-has-focus slds-is-active red-utility-icon' : 'slds-vertical-tabs__nav-item slds-has-focus';
    }

    get is_DraftSection() {
        return this.isDraftSection ? 'slds-vertical-tabs__nav-item slds-has-focus slds-is-active gold-utility-icon' : 'slds-vertical-tabs__nav-item slds-has-focus';
    }

    handleActioned(event) {
        this.isActioned = event.target.checked;
        incoming_Emails({
                status: this.isInbox,
                subject: this.subject,
                fromAddress: this.fromAddress,
                toAddress: this.toAddress,
                fromDate: this.fromDate,
                toDate: this.toDate,
                isAttachment: this.isAttachment,
                selectdObj: this.selectdObj,
                isDeleted: this.isDeleted,
                emailTags: this.emailTags,
                relatedTo: this.relatedTo,
                isActioned: this.isActioned,
                isIncoming: this.isIncoming
            })
            .then(result => {
                this.loaded = false;
                this.inboxMails = result;
            })
            .catch(error => {
                this.loaded = false;
                this.errorMsg = error;
            })
    }

    handleReplied(event) {
        if (event.target.checked == true) {
            this.isInbox = '2';
            this.loaded = true;
            incoming_Emails({
                    status: this.isInbox,
                    subject: this.subject,
                    fromAddress: this.fromAddress,
                    toAddress: this.toAddress,
                    fromDate: this.fromDate,
                    toDate: this.toDate,
                    isAttachment: this.isAttachment,
                    selectdObj: this.selectdObj,
                    isDeleted: this.isDeleted,
                    emailTags: this.emailTags,
                    relatedTo: this.relatedTo,
                    isActioned: this.isActioned,
                    isIncoming: this.isIncoming
                })
                .then(result => {
                    this.loaded = false;
                    this.inboxMails = result;
                })
                .catch(error => {
                    this.loaded = false;
                    this.errorMsg = error;
                })
        } else if (event.target.checked == false) {
            if (this.isInboxSection) {
                this.isInbox = '0';
            }
            if (this.isSentSection) {
                this.isInbox = '3';
            }
            if (this.isDraftSection) {
                this.isInbox = '5';
            }
            if (this.isTrashSection) {
                this.isInbox = '';
            }
            this.loaded = true;
            incoming_Emails({
                    status: this.isInbox,
                    subject: this.subject,
                    fromAddress: this.fromAddress,
                    toAddress: this.toAddress,
                    fromDate: this.fromDate,
                    toDate: this.toDate,
                    isAttachment: this.isAttachment,
                    selectdObj: this.selectdObj,
                    isDeleted: this.isDeleted,
                    emailTags: this.emailTags,
                    relatedTo: this.relatedTo,
                    isActioned: this.isActioned,
                    isIncoming: this.isIncoming
                })
                .then(result => {
                    this.loaded = false;
                    this.inboxMails = result;
                })
                .catch(error => {
                    this.loaded = false;
                    this.errorMsg = error;
                })
        }
    }

    handleForwarded(event) {
        if (event.target.checked == true) {
            this.isInbox = '4';
            this.loaded = true;
            incoming_Emails({
                    status: this.isInbox,
                    subject: this.subject,
                    fromAddress: this.fromAddress,
                    toAddress: this.toAddress,
                    fromDate: this.fromDate,
                    toDate: this.toDate,
                    isAttachment: this.isAttachment,
                    selectdObj: this.selectdObj,
                    isDeleted: this.isDeleted,
                    emailTags: this.emailTags,
                    relatedTo: this.relatedTo,
                    isActioned: this.isActioned,
                    isIncoming: this.isIncoming
                })
                .then(result => {
                    this.loaded = false;
                    this.inboxMails = result;
                })
                .catch(error => {
                    this.loaded = false;
                    this.errorMsg = error;
                })
        } else if (event.target.checked == false) {
            if (this.isInboxSection) {
                this.isInbox = '0';
            }
            if (this.isSentSection) {
                this.isInbox = '3';
            }
            if (this.isDraftSection) {
                this.isInbox = '5';
            }
            if (this.isTrashSection) {
                this.isInbox = '';
            }

            this.loaded = true;
            incoming_Emails({
                    status: this.isInbox,
                    subject: this.subject,
                    fromAddress: this.fromAddress,
                    toAddress: this.toAddress,
                    fromDate: this.fromDate,
                    toDate: this.toDate,
                    isAttachment: this.isAttachment,
                    selectdObj: this.selectdObj,
                    isDeleted: this.isDeleted,
                    emailTags: this.emailTags,
                    relatedTo: this.relatedTo,
                    isActioned: this.isActioned,
                    isIncoming: this.isIncoming
                })
                .then(result => {
                    this.loaded = false;
                    this.inboxMails = result;
                })
                .catch(error => {
                    this.loaded = false;
                    this.errorMsg = error;
                })
        }
    }


    handleObj(event) {
        this.loaded = true;
        this.selectdObj = event.target.value;
        incoming_Emails({
                status: this.isInbox,
                subject: this.subject,
                fromAddress: this.fromAddress,
                toAddress: this.toAddress,
                fromDate: this.fromDate,
                toDate: this.toDate,
                isAttachment: this.isAttachment,
                selectdObj: this.selectdObj,
                isDeleted: this.isDeleted,
                emailTags: this.emailTags,
                relatedTo: this.relatedTo,
                isActioned: this.isActioned,
                isIncoming: this.isIncoming
            })
            .then(result => {
                this.loaded = false;
                this.inboxMails = result;
            })
            .catch(error => {
                this.loaded = false;
                this.errorMsg = error;
            })
    }

    showFilter() {
        this.isHide = true;
    }

    hideFilter() {
        this.isHide = false;
    }

    handleAttachment(event) {
        this.isAttachment = event.target.checked;
        this.loaded = true;
        incoming_Emails({
                status: this.isInbox,
                subject: this.subject,
                fromAddress: this.fromAddress,
                toAddress: this.toAddress,
                fromDate: this.fromDate,
                toDate: this.toDate,
                isAttachment: this.isAttachment,
                selectdObj: this.selectdObj,
                isDeleted: this.isDeleted,
                emailTags: this.emailTags,
                relatedTo: this.relatedTo,
                isActioned: this.isActioned,
                isIncoming: this.isIncoming
            })
            .then(result => {
                this.loaded = false;
                this.inboxMails = result;
            })
            .catch(error => {
                this.loaded = false;
                this.errorMsg = error;
            })
    }

    /*  @wire(findObjectNameFromRecordIdPrefix, {status: this.isInbox})
      wiredOptions({
          error,
          data
      }) {
          if (data) {
              this.options = Object.keys(data).map(key => ({
                  label: data[key],
                  value: key
              }));
          } else if (error) {
              console.error('Error fetching picklist options', error);
          }
      }*/


    clearAll() {
        this.template.querySelectorAll('lightning-input').forEach(element => {
            if (element.type === 'checkbox') {
                element.checked = false;
                this.isAttachment = false;
                this.isReplied = false;
                this.isForward = false;
                this.isActioned = false;
                this.isIncoming = false;
            } else {
                element.value = null;
                this.selectdObj = '';
                this.subject = '';
                this.fromAddress = '';
                this.toAddress = '';
                this.fromDate = null;
                this.toDate = null;
                this.emailTags = '';
                this.relatedTo = '';
                this.selectedValues = [];
            }
        })
        this.template.querySelectorAll('lightning-combobox').forEach(element => {
            element.value = '';
        })
        if (this.isInboxSection) {
            this.isInbox = '0';
            this.isIncoming = true;
        }
        if (this.isSentSection) {
            this.isInbox = '3';
            this.isIncoming = false;
        }
        if (this.isDraftSection) {
            this.isInbox = '5';
        }
        if (this.isTrashSection) {
            this.isInbox = '';
        }
        incoming_Emails({
                status: this.isInbox,
                subject: '',
                fromAddress: '',
                toAddress: '',
                fromDate: null,
                toDate: null,
                isAttachment: null,
                selectdObj: '',
                isDeleted: this.isDeleted,
                emailTags: null,
                relatedTo: '',
                isActioned: this.isActioned,
                isIncoming: this.isIncoming
            })
            .then(result => {
                this.loaded = false;
                this.inboxMails = result;
            })
            .catch(error => {
                this.loaded = false;
                this.errorMsg = error;
            })
    }

    handlRelatedToChange(event) {
        this.loaded = true;
        this.relatedTo = event.target.value;
        incoming_Emails({
                status: this.isInbox,
                subject: this.subject,
                fromAddress: this.fromAddress,
                toAddress: this.toAddress,
                fromDate: this.fromDate,
                toDate: this.toDate,
                isAttachment: this.isAttachment,
                selectdObj: this.selectdObj,
                isDeleted: this.isDeleted,
                emailTags: this.emailTags,
                relatedTo: this.relatedTo
            })
            .then(result => {
                this.loaded = false;
                this.inboxMails = result;
            })
            .catch(error => {
                this.loaded = false;
                this.errorMsg = error;
            })
    }
    handleInboxChange(event) {
        this.loaded = true;
        this.subject = event.target.value;
        incoming_Emails({
                status: this.isInbox,
                subject: this.subject,
                fromAddress: this.fromAddress,
                toAddress: this.toAddress,
                fromDate: this.fromDate,
                toDate: this.toDate,
                isAttachment: this.isAttachment,
                selectdObj: this.selectdObj,
                isDeleted: this.isDeleted,
                emailTags: this.emailTags,
                relatedTo: this.relatedTo,
                isActioned: this.isActioned,
                isIncoming: this.isIncoming
            })
            .then(result => {
                this.loaded = false;
                this.inboxMails = result;
            })
            .catch(error => {
                this.loaded = false;
                this.errorMsg = error;
            })
    }

    handleToEmailChange(event) {
        this.loaded = true;
        this.toAddress = event.target.value;
        incoming_Emails({
                status: this.isInbox,
                subject: this.subject,
                fromAddress: this.fromAddress,
                toAddress: this.toAddress,
                fromDate: this.fromDate,
                toDate: this.toDate,
                isAttachment: this.isAttachment,
                selectdObj: this.selectdObj,
                isDeleted: this.isDeleted,
                emailTags: this.emailTags,
                relatedTo: this.relatedTo,
                isActioned: this.isActioned,
                isIncoming: this.isIncoming
            })
            .then(result => {
                this.loaded = false;
                this.inboxMails = result;
            })
            .catch(error => {
                this.loaded = false;
                this.errorMsg = error;
            })
    }

    handlRead(event) {
        this.loaded = true;
        this.isInbox = '1';
        if (event.target.checked == true) {
            incoming_Emails({
                    status: this.isInbox,
                    subject: this.subject,
                    fromAddress: this.fromAddress,
                    toAddress: this.toAddress,
                    fromDate: this.fromDate,
                    toDate: this.toDate,
                    isAttachment: this.isAttachment,
                    selectdObj: this.selectdObj,
                    isDeleted: this.isDeleted,
                    emailTags: this.emailTags,
                    relatedTo: this.relatedTo,
                    isActioned: this.isActioned,
                    isIncoming: this.isIncoming
                })
                .then(result => {
                    this.loaded = false;
                    this.inboxMails = result;
                })
                .catch(error => {
                    this.loaded = false;
                    this.errorMsg = error;
                })
        } else if (event.target.checked == false) {
            if (this.isInboxSection) {
                this.isInbox = '0';
            }
            if (this.isSentSection) {
                this.isInbox = '3';
            }
            if (this.isDraftSection) {
                this.isInbox = '5';
            }
            if (this.isTrashSection) {
                this.isInbox = '';
            }

            this.loaded = true;
            incoming_Emails({
                    status: this.isInbox,
                    subject: this.subject,
                    fromAddress: this.fromAddress,
                    toAddress: this.toAddress,
                    fromDate: this.fromDate,
                    toDate: this.toDate,
                    isAttachment: this.isAttachment,
                    selectdObj: this.selectdObj,
                    isDeleted: this.isDeleted,
                    emailTags: this.emailTags,
                    relatedTo: this.relatedTo,
                    isActioned: this.isActioned,
                    isIncoming: this.isIncoming
                })
                .then(result => {
                    this.loaded = false;
                    this.inboxMails = result;
                })
                .catch(error => {
                    this.loaded = false;
                    this.errorMsg = error;
                })
        }
    }

    handleFromEmailChange(event) {
        this.loaded = true;
        this.fromAddress = event.target.value;
        incoming_Emails({
                status: this.isInbox,
                subject: this.subject,
                fromAddress: this.fromAddress,
                toAddress: this.toAddress,
                fromDate: this.fromDate,
                toDate: this.toDate,
                isAttachment: this.isAttachment,
                selectdObj: this.selectdObj,
                isDeleted: this.isDeleted,
                emailTags: this.emailTags,
                relatedTo: this.relatedTo,
                isActioned: this.isActioned,
                isIncoming: this.isIncoming
            })
            .then(result => {
                this.loaded = false;
                this.inboxMails = result;
            })
            .catch(error => {
                this.loaded = false;
                this.errorMsg = error;
            })
    }

    handle_inboxMails() {
        this.template.querySelectorAll('lightning-input').forEach(element => {
            if (element.type === 'checkbox') {
                element.checked = false;
                this.isAttachment = false;
                this.isReplied = false;
                this.isForward = false;
                this.isActioned = false;
                this.isIncoming = false;
            } else {
                element.value = null;
                this.selectdObj = '';
                this.subject = '';
                this.fromAddress = '';
                this.toAddress = '';
                this.fromDate = null;
                this.toDate = null;
                this.emailTags = '';
                this.relatedTo = '';
                this.selectedValues = [];
            }
        })
        this.template.querySelectorAll('lightning-combobox').forEach(element => {
            element.value = '';
        })
        if (this.isInboxSection) {
            this.isInbox = '0';
            this.isIncoming = true;
        }
        if (this.isSentSection) {
            this.isInbox = '3';
            this.isIncoming = false;
        }
        if (this.isDraftSection) {
            this.isInbox = '5';
        }
        if (this.isTrashSection) {
            this.isInbox = '';
        }
        this.loaded = true;
        this.isInbox = '0';
        this.isInboxSection = true;
        this.isSentSection = false;
        this.isTrashSection = false;
        this.isDraftSection = false;
        this.isDeleted = false;
        this.isForwarded = false;
        this.rly = true;
        this.fwd = false;
        this.isIncoming = true;
        incoming_Emails({
                status: this.isInbox,
                subject: this.subject,
                fromAddress: this.fromAddress,
                toAddress: this.toAddress,
                fromDate: this.fromDate,
                toDate: this.toDate,
                isAttachment: this.isAttachment,
                selectdObj: this.selectdObj,
                isDeleted: this.isDeleted,
                emailTags: this.emailTags,
                relatedTo: this.relatedTo,
                isActioned: this.isActioned,
                isIncoming: this.isIncoming
            })
            .then(result => {
                this.loaded = false;
                this.inboxMails = result;
            })
            .catch(error => {
                this.loaded = false;
                this.errorMsg = error;
            })
        findObjectNameFromRecordIdPrefix({
                status: this.isInbox,
                isDeleted: this.isDeleted,
                isActioned: this.isActioned,
            })
            .then(result => {
                let data = result;
                this.options = Object.keys(data).map(key => ({
                    label: data[key],
                    value: key
                }));
            })
            .catch(error => {
                console.error('Error fetching picklist options', error);
            })
    }

    handle_sentMails() {
        this.template.querySelectorAll('lightning-input').forEach(element => {
            if (element.type === 'checkbox') {
                element.checked = false;
                this.isAttachment = false;
                this.isReplied = false;
                this.isForward = false;
                this.isActioned = false;
                this.isIncoming = false;
            } else {
                element.value = null;
                this.selectdObj = '';
                this.subject = '';
                this.fromAddress = '';
                this.toAddress = '';
                this.fromDate = null;
                this.toDate = null;
                this.emailTags = '';
                this.relatedTo = '';
                this.selectedValues = [];
            }
        })
        this.template.querySelectorAll('lightning-combobox').forEach(element => {
            element.value = '';
        })
        if (this.isInboxSection) {
            this.isInbox = '0';
            this.isIncoming = true;
        }
        if (this.isSentSection) {
            this.isInbox = '3';
            this.isIncoming = false;
        }
        if (this.isDraftSection) {
            this.isInbox = '5';
        }
        if (this.isTrashSection) {
            this.isInbox = '';
        }
        this.loaded = true;
        this.isInbox = '3';
        this.isInboxSection = false;
        this.isSentSection = true;
        this.isTrashSection = false;
        this.isDraftSection = false;
        this.isDeleted = false;
        this.isForwarded = true;
        this.rly = true;
        this.fwd = true;
        this.isIncoming = false;
        incoming_Emails({
                status: this.isInbox,
                subject: this.subject,
                fromAddress: this.fromAddress,
                toAddress: this.toAddress,
                fromDate: this.fromDate,
                toDate: this.toDate,
                isAttachment: this.isAttachment,
                selectdObj: this.selectdObj,
                isDeleted: this.isDeleted,
                emailTags: this.emailTags,
                relatedTo: this.relatedTo,
                isActioned: this.isActioned,
                isIncoming: this.isIncoming
            })
            .then(result => {
                this.loaded = false;
                this.inboxMails = result;
            })
            .catch(error => {
                this.loaded = false;
                this.errorMsg = error;
            })
        findObjectNameFromRecordIdPrefix({
                status: this.isInbox,
                isDeleted: this.isDeleted,
                isActioned: this.isActioned,
            })
            .then(result => {
                let data = result;
                this.options = Object.keys(data).map(key => ({
                    label: data[key],
                    value: key
                }));
            })
            .catch(error => {
                console.error('Error fetching picklist options', error);
            })
    }

    handle_Trash() {
        this.template.querySelectorAll('lightning-input').forEach(element => {
            if (element.type === 'checkbox') {
                element.checked = false;
                this.isAttachment = false;
                this.isReplied = false;
                this.isForward = false;
                this.isActioned = false;
                this.isIncoming = false;
            } else {
                element.value = null;
                this.selectdObj = '';
                this.subject = '';
                this.fromAddress = '';
                this.toAddress = '';
                this.fromDate = null;
                this.toDate = null;
                this.emailTags = '';
                this.relatedTo = '';
                this.selectedValues = [];
            }
        })
        this.template.querySelectorAll('lightning-combobox').forEach(element => {
            element.value = '';
        })
        if (this.isInboxSection) {
            this.isInbox = '0';
            this.isIncoming = true;
        }
        if (this.isSentSection) {
            this.isInbox = '3';
            this.isIncoming = false;
        }
        if (this.isDraftSection) {
            this.isInbox = '5';
        }
        if (this.isTrashSection) {
            this.isInbox = '';
        }
        this.loaded = true;
        this.isInboxSection = false;
        this.isSentSection = false;
        this.isTrashSection = true;
        this.isDraftSection = false;
        this.isDeleted = true;
        this.isForwarded = false;
        this.rly = false;
        this.fwd = false;
        incoming_Emails({
                status: this.isInbox,
                subject: this.subject,
                fromAddress: this.fromAddress,
                toAddress: this.toAddress,
                fromDate: this.fromDate,
                toDate: this.toDate,
                isAttachment: this.isAttachment,
                selectdObj: this.selectdObj,
                isDeleted: this.isDeleted,
                emailTags: this.emailTags,
                relatedTo: this.relatedTo,
                isActioned: this.isActioned,
                isIncoming: this.isIncoming
            })
            .then(result => {
                this.loaded = false;
                this.inboxMails = result;
            })
            .catch(error => {
                this.loaded = false;
                this.errorMsg = error;
            })
        findObjectNameFromRecordIdPrefix({
                status: this.isInbox,
                isDeleted: this.isDeleted,
                isActioned: this.isActioned,
            })
            .then(result => {
                let data = result;
                this.options = Object.keys(data).map(key => ({
                    label: data[key],
                    value: key
                }));
            })
            .catch(error => {
                console.error('Error fetching picklist options', error);
            })
    }

    objAPI;
    navigateToRelated(event) {
        getObjAPI({
                objAPI: event.target.dataset.id
            })
            .then(result => {
                this.objAPI = result;
            })
        this[NavigationMixin.GenerateUrl]({
                type: 'standard__recordPage',
                attributes: {
                    recordId: event.target.dataset.id,
                    objectApiName: this.objAPI,
                    actionName: 'view',
                },
            })
            .then(url => {
                window.open(url, "_blank");
            });
    }

    handle_Draft() {
        this.template.querySelectorAll('lightning-input').forEach(element => {
            if (element.type === 'checkbox') {
                element.checked = false;
                this.isAttachment = false;
                this.isReplied = false;
                this.isForward = false;
                this.isActioned = false;
                this.isIncoming = false;
            } else {
                element.value = null;
                this.selectdObj = '';
                this.subject = '';
                this.fromAddress = '';
                this.toAddress = '';
                this.fromDate = null;
                this.toDate = null;
                this.emailTags = '';
                this.relatedTo = '';
                this.selectedValues = [];
            }
        })
        this.template.querySelectorAll('lightning-combobox').forEach(element => {
            element.value = '';
        })
        if (this.isInboxSection) {
            this.isInbox = '0';
            this.isIncoming = true;
        }
        if (this.isSentSection) {
            this.isInbox = '3';
            this.isIncoming = false;
        }
        if (this.isDraftSection) {
            this.isInbox = '5';
        }
        if (this.isTrashSection) {
            this.isInbox = '';
        }
        this.loaded = true;
        this.isInboxSection = false;
        this.isSentSection = false;
        this.isTrashSection = false;
        this.isDraftSection = true;
        this.isDeleted = false;
        this.isInbox = '5';
        this.isForwarded = false;
        this.rly = false;
        this.fwd = false;
        incoming_Emails({
                status: this.isInbox,
                subject: this.subject,
                fromAddress: this.fromAddress,
                toAddress: this.toAddress,
                fromDate: this.fromDate,
                toDate: this.toDate,
                isAttachment: this.isAttachment,
                selectdObj: this.selectdObj,
                isDeleted: this.isDeleted,
                emailTags: this.emailTags,
                relatedTo: this.relatedTo,
                isActioned: this.isActioned,
                isIncoming: this.isIncoming
            })
            .then(result => {
                this.loaded = false;
                this.inboxMails = result;
            })
            .catch(error => {
                this.loaded = false;
                this.errorMsg = error;
            })
        findObjectNameFromRecordIdPrefix({
                status: this.isInbox,
                isDeleted: this.isDeleted,
                isActioned: this.isActioned,
            })
            .then(result => {
                let data = result;
                this.options = Object.keys(data).map(key => ({
                    label: data[key],
                    value: key
                }));
            })
            .catch(error => {
                console.error('Error fetching picklist options', error);
            })
    }

    navigateToEmailMessage(event) {
        this[NavigationMixin.GenerateUrl]({
                type: 'standard__recordPage',
                attributes: {
                    recordId: event.target.dataset.id,
                    objectApiName: 'EmailMessage',
                    actionName: 'view',
                },
            })
            .then(url => {
                window.open(url, "_blank");
            });
    }

    sortColumn = 'Subject';
    sortDirection = 'asc';

    get sortDirectionIcon() {
        return this.sortDirection === 'asc' ? 'arrowup' : 'arrowdown';
    }

    handleSort(event) {
        const column = event.currentTarget.dataset.column;
        if (column === this.sortColumn) {
            this.sortDirection = this.sortDirection === 'asc' ? 'desc' : 'asc';
        } else {
            this.sortColumn = column;
            this.sortDirection = 'asc';
        }
        this.sortData();
    }

    sortData() {
        const fieldName = this.sortColumn;
        const reverse = this.sortDirection === 'desc' ? -1 : 1;

        // Clone the accountData array to avoid mutating the original array
        const sortedData = [...this.inboxMails];

        sortedData.sort((a, b) => {
            const aValue = a[fieldName].toLowerCase();
            const bValue = b[fieldName].toLowerCase();
            return (aValue > bValue ? 1 : -1) * reverse;
        });

        // Update the accountData with the sorted array
        this.inboxMails = sortedData;
    }

    handleFromDateChange(event) {
        this.fromDate = event.target.value;
        if (this.fromDate) {
            this.loaded = true;
            incoming_Emails({
                    status: this.isInbox,
                    subject: this.subject,
                    fromAddress: this.fromAddress,
                    toAddress: this.toAddress,
                    fromDate: this.fromDate,
                    toDate: this.toDate,
                    isAttachment: this.isAttachment,
                    selectdObj: this.selectdObj,
                    isDeleted: this.isDeleted,
                    emailTags: this.emailTags,
                    relatedTo: this.relatedTo,
                    isActioned: this.isActioned,
                    isIncoming: this.isIncoming
                })
                .then(result => {
                    this.loaded = false;
                    this.inboxMails = result;
                })
                .catch(error => {
                    this.loaded = false;
                    this.errorMsg = error;
                })
        }
    }

    selctedDay;
    handleToDateChange(event) {
        this.selctedDay = event.target.value;
        var date = new Date(event.target.value);
        date.setDate(date.getDate() + 1);
        this.loaded = true;
        this.toDate = date.toISOString().slice(0, 10);;
        incoming_Emails({
                status: this.isInbox,
                subject: this.subject,
                fromAddress: this.fromAddress,
                toAddress: this.toAddress,
                fromDate: this.fromDate,
                toDate: date,
                isAttachment: this.isAttachment,
                selectdObj: this.selectdObj,
                isDeleted: this.isDeleted,
                emailTags: this.emailTags,
                relatedTo: this.relatedTo,
                isActioned: this.isActioned,
                isIncoming: this.isIncoming
            })
            .then(result => {
                this.loaded = false;
                this.inboxMails = result;
            })
            .catch(error => {
                this.loaded = false;
                this.errorMsg = error;
            })
        if (this.fromDate && this.toDate && this.toDate < this.fromDate) {
            alert('To Date should be greater than or equal to From Date');
            this.toDate = '';
        }
    }
}