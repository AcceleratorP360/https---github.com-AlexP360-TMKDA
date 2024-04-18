import { LightningElement, api, wire, track} from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import {NavigationMixin} from 'lightning/navigation';
import getChatterFeed from '@salesforce/apex/P360DA_CustomActivityChatterTabCtrl.getChatterFeed';
import createChatterFeed from '@salesforce/apex/P360DA_CustomActivityChatterTabCtrl.createChatterFeed';
import createFeedComment from '@salesforce/apex/P360DA_CustomActivityChatterTabCtrl.createFeedComment';
import getContentVersion from '@salesforce/apex/P360DA_CustomActivityChatterTabCtrl.getContentVersion';
import deleteFeedRecord from '@salesforce/apex/P360DA_CustomActivityChatterTabCtrl.deleteFeedRecord';
import updateFeedRecord from '@salesforce/apex/P360DA_CustomActivityChatterTabCtrl.updateFeedRecord';
import { registerListener, unregisterAllListeners } from 'c/pubsub'; 

export default class P360DA_CustomActivityChatterTab extends NavigationMixin(LightningElement) {

    @api recordId;

    @track feedRecords = [];
    @track filterdFeedRecords = [];

    @track selectedFilesList = [];
    @track selectedFilesName = [];
    @track selectedRecord = {};

    contentBody = '';
    commentBody = '';
    searchInput = '';
    selectedFilterOption = 'Latest Post';

    //Flag variable
    isSpinner = false;
    isExpandAll = false;
    isDeleteModal = false;
    isEditModal = false;

    async connectedCallback() {
        registerListener('eventdetails', this.sutUpDetails, this); 
        console.log('connectedCallback : ',this.recordId);

        await this.getChatterFeed();

    }

    sutUpDetails(recordIds){ 
        console.log('====recordIds===',recordIds);
        this.recordId = recordIds; 
        this.connectedCallback();

    } 

    async getChatterFeed(){
        this.isSpinner = true;
        await getChatterFeed({'recordId':this.recordId})
        .then((result) => {

            result = result.map(item => {
                var isToday = new Date(item.feed.CreatedDate).getDate() == new Date().getDate();
                var updatedItem = {
                    ...item.feed,
                    FeedAttachments : [...item.attachList],
                    title : item.feed.Body?.replace( /(<([^>]+)>)/ig, '').slice(0,35)+'...',
                    formateDateTime: isToday ? this.getTimeFromDate(item.feed.CreatedDate) : this.formatDateString(item.feed.CreatedDate)
                };

                if(item.feed.FeedComments && item.feed.FeedComments.length > 0) {
                    const latestComment = item.feed.FeedComments.reduce((a, b) => (a.CreatedDate > b.CreatedDate ? a : b));
                    updatedItem['LastModifiedDate'] = latestComment.CreatedDate;
                } else {
                    updatedItem['LastModifiedDate'] = item.feed.CreatedDate;
                }

                if(item.feed.FeedComments){

                    var feedComments = item.feed.FeedComments.map(comment => {
                        var isToday = new Date(item.feed.CreatedDate).getDate() == new Date().getDate();
                        return {
                            ...comment,
                            formateDateTime: isToday ? this.getTimeFromDate(comment.CreatedDate) : this.formatDateString(comment.CreatedDate)
                        }
                    });
                    updatedItem['FeedComments']  = [...feedComments];
                    updatedItem['title']  = feedComments[feedComments.length-1].CommentBody?.replace( /(<([^>]+)>)/ig, '').slice(0,35)+'...';
                }

                return updatedItem;
            });

            this.feedRecords = JSON.parse(JSON.stringify(result));
            this.filterdFeedRecords = JSON.parse(JSON.stringify(result));
            this.sortFeedData();

            console.log('getChatterFeed result : ',JSON.stringify(result));

        }).catch((error) => {
            console.log('getChatterFeed error : ',error);
            console.log('getChatterFeed error : ',error.stack);
        });
        this.isSpinner = false;
    }

    async handleRefreshFeed(){
        await this.getChatterFeed();
    }

    async handleShareUpdate(){
        this.isSpinner = true;
        var feed = {'recordId' : this.recordId, 'body' : this.contentBody, 'attach' : this.selectedFilesList};
        await createChatterFeed({'feed' : JSON.stringify(feed)})
        .then((result) => {   

            console.log('createChatterFeed result : ',result);
            result = JSON.parse(result);
            this.showToast(result.status, result.message);

            this.clearFeedInputs();         
            this.clearFileSelection();

        }).catch((error) => {
            console.log('createChatterFeed error : ',error);
        });

        this.getChatterFeed();

        this.isSpinner = false;
    }
    async handleShareComment(event){
        this.isSpinner = true;
        
        var parentFeedId = event.target.dataset.feed;

        var feed = {'recordId' : parentFeedId, 'body' : this.commentBody};
        await createFeedComment({'feed' : JSON.stringify(feed)})
        .then((result) => {   

            result = JSON.parse(result);
            console.log('createChatterFeed result : ',result);
            this.showToast(result.status, result.message);

            this.clearFeedInputs();         

        }).catch((error) => {
            console.log('createChatterFeed error : ',error);
        });

        this.getChatterFeed();

        this.isSpinner = false;
    }

    async handleDeleteRecord(){
        var temp = JSON.parse(JSON.stringify(this.selectedRecord));

        this.handleCloseDeleteModal();
        this.isSpinner = true;
        
        await deleteFeedRecord({'id' :temp.id, 'feedType' : temp.type})
        .then((result) => {
            console.log('handleDeleteRecord result : ',result);
            result = JSON.parse(result);
            this.showToast(result.status, result.message);
        }).catch((error) => {
            console.log('handleDeleteRecord error : ',error);
        });

        await this.getChatterFeed();

        this.isSpinner = false;

    }

    async handleEditRecord(){
        var temp = JSON.parse(JSON.stringify(this.selectedRecord));

        this.handleCloseEditModal();
        this.isSpinner = true;
        
        await updateFeedRecord({'id' :temp.id, 'feedType' : temp.type, 'body' : temp.body})
        .then((result) => {
            console.log('handleEditRecord result : ',result);
            result = JSON.parse(result);
            this.showToast(result.status, result.message);
        }).catch((error) => {
            console.log('handleEditRecord error : ',error);
        });

        await this.getChatterFeed();

        this.isSpinner = false;

    }

    handlePreviewDocument(event){
        console.log('handlePreviewDocument event : ',event);
        console.log('handlePreviewDocument event.target : ',event.target);
        let conVersionId = event.target.dataset.id;
        console.log('handlePreviewDocument conVersionId : ',conVersionId);
        this.isSpinner = true;
        getContentVersion({'conVersionId' : conVersionId})
        .then((result) => {
            console.log('getContentVersion : result ',JSON.stringify(result));
            this[NavigationMixin.Navigate]({
                type:'standard__namedPage',
                attributes:{ 
                    pageName:'filePreview'
                },
                state:{
                    selectedRecordId: result.ContentDocumentId
                }
            })
            this.isSpinner = false;
        }).catch((error) => {
            console.log('getContentVersion : Error ',error);
            this.isSpinner = false;
        });
    }

    handleAddFile(){
        console.log('handleAddFile clicked ');
        const fileInput = this.template.querySelector('input[type="file"]');
        console.log('handleAddFile fileInput : ',fileInput);
        fileInput.click();
    }

    openFileUpload(event){
        // console.log('openFileUpload : ');
        var files = event.target.files;
        if (files.length > 0) {
            // console.log('OUTPUT : ',files);
            for(var i=0; i< files.length; i++){
                let file = files[i];
                this.selectedFilesName.push({
                    label: file.name,
                    type: 'icon',
                    iconName: 'doctype:attachment',
                });

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

    handleRemoveSelectedFile(event){
        let index = event.target.dataset.index;
        this.selectedFilesName.splice(index,1);
        this.selectedFilesList.splice(index,1);
        if(this.selectedFilesName.length <= 0){
            this.clearFileSelection();
        }
    }

    clearFileSelection(){
        this.selectedFilesList = [];
        this.selectedFilesName = [];

        const fileInput = this.template.querySelector('input[type="file"]');
        fileInput.value = "";
    }

    handleFilePillItemRemove(event){
        const index = event.detail.index;
        this.selectedFilesName.splice(index,1);
        this.selectedFilesList.splice(index,1);
    }

    handleInputChange(event){
        var type = event.target.dataset.type;
        switch(type){
            case 'MAIN':
                this.contentBody = event.target.value;
                break;
            case 'COMMENT':
                this.commentBody = event.target.value;
                var feed = event.target.dataset.feed;
                var commentButton = this.template.querySelector('lightning-button[data-feed="'+feed+'"]');
                commentButton.disabled  = this.commentBody ? false : true;
                break;
            case 'SEARCH':
                if(!event.target.value) this.filterdFeedRecords = [...this.feedRecords];
                break;
        }
    }

    handleSearch(event){
        this.searchInput = event.target.value;
        if(event.key == 'Enter'){
            var temp = this.feedRecords.filter(record => {
                var isAvailable = record.Body.includes(this.searchInput);
                
                if(record.FeedComments){

                    var isCommentAvailable = record.FeedComments.find((comment) => {
                        return comment.CommentBody.includes(this.searchInput);
                    });
                    if(!isAvailable && isCommentAvailable){
                        isAvailable = isCommentAvailable;
                    }
                }

                return isAvailable;

            });
            this.filterdFeedRecords  = [...temp];
        }
    }

    handleFeedExpand(event){
        var type = event.target.dataset.type;
        console.log('handleFeedExpand type : ',type);
        var summaries = this.template.querySelectorAll('.slds-summary-detail');
        var titleCollapseAll = this.template.querySelectorAll('.feed-title-collapse');
        var titleExpandAll = this.template.querySelectorAll('.feed-title-expand');

        console.log('handleFeedExpand summaries : ',summaries);
        if(type ==  'Expand'){
            summaries.forEach(summary => { summary.classList.add("slds-is-open"); });

            titleCollapseAll.forEach(item => { item.classList.remove("active") });
            titleExpandAll.forEach(item => { item.classList.add("active") });
            this.isExpandAll = true;
        }
        else if(type ==  'Collapse'){
            summaries.forEach(summary => { summary.classList.remove("slds-is-open"); });

            titleCollapseAll.forEach(item => { item.classList.add("active") });
            titleExpandAll.forEach(item => { item.classList.remove("active") });
            this.isExpandAll = false;
        }
    }

    handleToggleChatterDetail(event){
        // console.log('handleToggleChatterDetail : ',event.target.dataset.index);
        var id = event.target.dataset.id;
        var summary = this.template.querySelector('.slds-summary-detail[data-id="'+id+'"]');

        var titleCollapse = this.template.querySelector('.feed-title-collapse[data-id="'+id+'"]');
        var titleExpand = this.template.querySelector('.feed-title-expand[data-id="'+id+'"]');

        if(summary.classList.contains("slds-is-open")){
            summary.classList.remove("slds-is-open");
            titleCollapse.classList.add("active");
            titleExpand.classList.remove("active");
        }else{
            summary.classList.add("slds-is-open");
            titleCollapse.classList.remove("active");
            titleExpand.classList.add("active");
        }

    }
    handleToggleCommentSection(event){
        var id = event.target.dataset.id;
        var summary = this.template.querySelector('.feed-comments-section[data-id="'+id+'"]');

        if(summary.classList.contains("active")){
            summary.classList.remove("active");
        }else{
            summary.classList.add("active");
        }

    }

    handleViewUser(event){
        let id = event.target.dataset.id;
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: id,
                objectApiName: 'User',
                actionName: 'view'
            }
        });
    }

    previewHandler(event){
        console.log('previewHandler',event.target.dataset.id)
        this[NavigationMixin.Navigate]({ 
            type:'standard__namedPage',
            attributes:{ 
                pageName:'filePreview'
            },
            state:{ 
                selectedRecordId: event.target.dataset.id
                // selectedRecordId: '0693L000003BwuzQAC'
            }
        })
    }

    handleFilterSelection(event){
        this.selectedFilterOption = event.detail.value;
        this.sortFeedData();
    }

    sortFeedData() {
        try{
            this.filterdFeedRecords.sort((a, b) => {
                if (this.selectedFilterOption === 'Latest Post') {
                    return new Date(b.CreatedDate) - new Date(a.CreatedDate);
                } else if (this.selectedFilterOption === 'Most Recent') {
                    return new Date(b.LastModifiedDate) - new Date(a.LastModifiedDate);
                }
                return 0;
            });
        }catch(error){
            console.log('sortFeedData error : ',error);
            console.log('sortFeedData error : ',error.stack);
        }
    }

    formatDateString(date) {
        var date = new Date(date);

        var months = [
            'January', 'February', 'March', 'April', 'May', 'June',
            'July', 'August', 'September', 'October', 'November', 'December'
        ];

        var year = date.getFullYear();
        var month = months[date.getMonth()];
        var day = date.getDate();
        var hours = date.getHours();
        var minutes = date.getMinutes();
        var formattedDate = `${month} ${day}, ${year} at ${hours > 12 ?  hours - 12 : hours}:${minutes < 10 ? '0' : ''}${minutes} ${hours >= 12 ? 'PM' : 'AM'}`;
        return formattedDate;
    }

    getTimeFromDate(date){
        var date = new Date(date);
        var hours = date.getHours();
        var minutes = date.getMinutes();
        return `${hours > 12 ?  hours - 12 : hours}:${minutes < 10 ? '0' : ''}${minutes} ${hours >= 12 ? 'PM' : 'AM'}`;
    }

    showToast(variant, message) {
        const event = new ShowToastEvent({
            title: variant,
            message: message,
            variant: variant,
            mode: 'dismissable'
        });
        this.dispatchEvent(event);
    }

    clearFeedInputs(){
        this.contentBody = '';
        this.commentBody = '';
        var main = this.template.querySelectorAll('lightning-input-rich-text');
        main.forEach(input => { input.value = ''; });
    }

    handleOpenDeleteModal(event){
        console.log('handleOpenDeleteModal : ',event.target);
        let id = event.target.dataset.id;
        let type = event.target.dataset.type;
        this.selectedRecord = {'id': id, 'type': type};

        console.log('handleOpenDeleteModal : ',JSON.stringify(this.selectedRecord));
        this.isDeleteModal = true;
    }
    handleCloseDeleteModal(){
        this.isDeleteModal = false;
        this.selectedRecord = {};
    }

    handleOpenEditModal(event){
        console.log('handleOpenDeleteModal : ',event.target);

        let id = event.target.dataset.id;
        let type = event.target.dataset.type;
        let body = event.target.dataset.body;
        this.selectedRecord = {'id': id, 'type': type, 'body' : body};

        console.log('handleOpenDeleteModal : ',JSON.stringify(this.selectedRecord));
        this.isEditModal = true;
    }
    handleCloseEditModal(){
        this.isEditModal = false;
        this.selectedRecord = {};
    }

    handleEditInputChange(event){
        this.selectedRecord['body'] = event.target.value;
    }
}