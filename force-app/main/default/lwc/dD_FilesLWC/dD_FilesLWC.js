import {
    LightningElement,
    api,
    wire
} from 'lwc';
import getFiles from '@salesforce/apex/DD_FileListCtrl.getfiles';
import getObjAPI from '@salesforce/apex/EmailListCtrl.getObjAPI';
import {
    NavigationMixin
} from 'lightning/navigation';

export default class DD_FilesLWC extends NavigationMixin(LightningElement){

    fileResult;
    error;
    loaded = true;
    allDocs;
    @api recordId;

    @wire(getFiles, {
        recordId: '$recordId'
    }) wiredFile({
        data,
        error
    }) {
        if (data) {
            this.loaded = false;
            this.fileResult = data;
            this.allDocs = 'Documents (' + this.fileResult.length + ')';
        }else{
            this.loaded = false;
            this.allDocs = 'Documents (0)';
        }
        if (error) {
            this.loaded = false;
            this.error = error;
        }
    }

    navigateToFile(event) {
        this[NavigationMixin.GenerateUrl]({
                type: 'standard__recordPage',
                attributes: {
                    recordId: event.target.dataset.id,
                    objectApiName: 'ContentDocument',
                    actionName: 'view',
                },
            })
            .then(url => {
                window.open(url, "_blank");
            });
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

    sortColumn = 'docTitle';
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
        const sortedData = [...this.fileResult];

        sortedData.sort((a, b) => {
            const aValue = a[fieldName].toLowerCase();
            const bValue = b[fieldName].toLowerCase();
            return (aValue > bValue ? 1 : -1) * reverse;
        });
        this.fileResult = sortedData;
    }
}