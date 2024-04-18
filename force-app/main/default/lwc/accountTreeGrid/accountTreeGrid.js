import { LightningElement, track, wire } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import { ShowToastEvent } from 'lightning/platformShowToastEvent'; 
import getAllParentAccounts from '@salesforce/apex/CustomController.getAllParentAccounts';
import { getPicklistValues, getObjectInfo } from 'lightning/uiObjectInfoApi';

export default class Sample extends NavigationMixin(LightningElement) {

    @track gridColumns = [
       
        { label: 'Name', fieldName: 'Name', editable: true
        },   
        {
            label: 'Inherent Risk', fieldName: 'P360_Inherent_Risk__c', type: 'picklistColumn',alignment : 'center',wraptext: true,editable: true, typeAttributes: {
                alignment : 'center',  placeholder: 'Choose Assessment', options: { fieldName: 'pickListOptions' }, 
                value: { fieldName: 'P360_Inherent_Risk__c' }, // default value for picklist,
                context: { fieldName: 'Id' } // binding account Id with context variable to be returned back
            }
        },
        {
            label: 'Summary', fieldName: 'P360_Summary_Final_Assessment__c', type: 'text',wraptext: true, editable: true, cellAttributes: {
                class: 'myColumnClass',alignment : 'center',
                innerWidth: 50 // set the width to 50
            }
        }
    ,    
    
        {
            label: 'Assessment', fieldName: 'P360_Assessment__c', type: 'picklistColumn', editable: true, typeAttributes: {
                placeholder: 'Choose Assessment', options: { fieldName: 'pickListOptions' }, 
                value: { fieldName: 'P360_Assessment__c' }, // default value for picklist,
                context: { fieldName: 'Id' } // binding account Id with context variable to be returned back
            }
        },
        {
            label: 'Completion Marker?',
            fieldName: 'P360_Completion_Marker__c',
            type: 'picklistColumn',
            editable: true,
            typeAttributes: {
                placeholder: 'Choose Completion',
                alignment: 'center',
                options: { fieldName: 'pickListCompletionOptions' }, 
                value: { fieldName: 'P360_Completion_Marker__c' }, 
                context: { fieldName: 'Id' } 
            }
        },
        { type: "button", typeAttributes: {  
            label: 'View ',  
            name: 'View',  
            title: 'View',  
            disabled: false,  
            value: 'view',  
            initialWidth: 5,
            iconPosition: 'left'  
        } } ,
        { type: "button", typeAttributes: {  
            label: 'Edit',  
            name: 'Edit',  
            title: 'Edit',  
            disabled: false,  
            value: 'edit',  
            iconPosition: 'left'  
        } }  
        
    ];
    @track gridData;
    @track recordId;
    @track pickListCompletionOptions;
    connectedCallback() {
        // Get the record Id from the page URL
        this.recordId = this.getRecordId();
      }
      
      @track pickListCompletionOptions;
      
      getRecordId() {
        const url = window.location.href;
        const parts = url.split('/');
        return parts[parts.length - 2];
      }
      
      @wire(getAllParentAccounts, { recordId: '$recordId' })
      accountTreeData({ error, data }) {
        if (data) {
          let accountTreeData = JSON.parse(JSON.stringify(data));
          for (let i = 0; i < accountTreeData.length; i++) {
            accountTreeData[i]._children = accountTreeData[i]["DD_Sub_Categories__r"];
            delete accountTreeData[i].DD_Sub_Categories__r;
            if (accountTreeData[i]._children) {
              for (let j = 0; j < accountTreeData[i]._children.length; j++) {
                accountTreeData[i]._children[j]._children = accountTreeData[i]._children[j]["DD_Sub_Category_Review_Areas__r"];
                delete accountTreeData[i]._children[j].DD_Sub_Category_Review_Areas__r;
              }
            }
          }
          this.gridData = accountTreeData;
        } else if (error) {
          console.error(error);
        }
      }
      
      @wire(getPicklistValues, { recordTypeId: '$objectInfo.data.defaultRecordTypeId', fieldApiName: 'P360_DD_Category__c.P360_Completion_Marker__c' })
      wirePickListCompletion({ error, data }) {
        if (data) {
          this.pickListCompletionOptions = data.values.map(item => ({ label: item.label, value: item.value }));
          this.gridData.forEach(row => {
            row.pickListCompletionOptions = this.pickListCompletionOptions;
          });
        } else if (error) {
          console.error(error);
        }
      }
      
      handleOnToggle(event) {
        console.log(event.detail.name);
        console.log(event.detail.hasChildrenContent);
        console.log(event.detail.isExpanded);
        const rowName = event.detail.name;
        if (!event.detail.hasChildrenContent && event.detail.isExpanded) {
          this.isLoading = true;
          getAllParentAccounts({ recordId: rowName })
            .then((result) => {
              console.log(result);
              if (result && result.length > 0) {
                const newChildren = result.map((child) => ({
                  _children: [],
                  ...child,
                  ParentAccountName: child.Parent?.Name
                }));
                this.gridData = this.getNewDataWithChildren(
                  rowName,
                  this.gridData,
                  newChildren
                );
              } else {
                this.dispatchEvent(
                  new ShowToastEvent({
                    title: "No children",
                    message: "No children for the selected Account",
                    variant: "warning"
                  })
                );
              }
            })
            .catch((error) => {
              console.log("Error loading child accounts", error);
              this.dispatchEvent(
                new ShowToastEvent({
                  title: "Error Loading Children Accounts",
                  message: error + " " + error?.message,
                  variant: "error"
                })
              );
            })
            .finally(() => {
              this.isLoading = false;
            });
        }
      }
      

    clickToExpandAll( e ) {
        const grid =  this.template.querySelector( 'lightning-tree-grid' );
        grid.expandAll();
    }

    clickToCollapseAll( e ) {

        const grid =  this.template.querySelector( 'lightning-tree-grid' );
        grid.collapseAll();
      
    }
}