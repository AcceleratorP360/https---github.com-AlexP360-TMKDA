import {LightningElement,wire,api,track} from 'lwc';
import getDocumentFile from '@salesforce/apex/S3_BucketDocumentCtrl.getDocumentFile';
export default class P360_RefreshFromS3 extends LightningElement {
		@track error;
    @api recordId;
		
		Refresh(event){
						getDocumentFile;
}
}