import { LightningElement, wire, api,track } from "lwc";
import getRelatedFiles from "@salesforce/apex/FileController.getFilesList";
import getFileVersionDetails from "@salesforce/apex/FileController.getFileVersionDetails";
import createContentDocLink from "@salesforce/apex/FileController.createContentDocLink";
import { deleteRecord, createRecord } from "lightning/uiRecordApi";
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import { refreshApex } from "@salesforce/apex";

const actions = [
  { label: "Version History", name: "show_details" },
  { label: "Upload New Version", name: "upload_version" },
  { label: "Delete File", name: "delete" },
  { label: "Download", name: "download" }
 
];

const BASE64EXP = new RegExp(/^data(.*)base64,/);
const columns = [
  {
    label: "File Name",
    fieldName: "id",
    iconName: "doctype:attachment",
    type: "filePreview",
    typeAttributes: {
      anchorText: { fieldName: "title" },
      versionId: { fieldName: "latestVersionId" },
     
    }
  },
  { label: "Description", fieldName: "Description", type: "text" },

 
  { label: "Uploaded by", fieldName: "createdBy", type: "string" },
  { label: "Uploaded Date", fieldName: "createdDate", type: "date" },
  { type: "action", typeAttributes: { rowActions: actions } }
];

const versionColumns = [
    {
        label: "Download",
        fieldName: "id",
        type: "filePreview",
        typeAttributes: {
          anchorText: "Download⇣"
        }
    },
  
    
  { label: "Title", fieldName: "title", type: "string" },
  { label: "Reason for Change", fieldName: "reasonForChange", type: "string" },
  { label: "Uploaded by", fieldName: "createdBy", type: "string" },
  { label: "Uploaded Date", fieldName: "createdDate", type: "date" }
];

export default class FileList extends LightningElement {
    @api
    recordId;
    _filesList;
    fileTitle;
    fileName;
    files = [];
    columns = columns;
    versionColumns = versionColumns;
    versionDetails = [];
    fileUpload = false;
    _currentDocId = null;
    showPreview = false;
    currentPreviewFileId = null;
    showSpinner = false;
    @api acceptedFileFormats;
    @api fileUploaded;
    title;
    @track initialized=false;
    @track newFile=false;
    handleFileNameChange(event) {
      this.fileTitle = event.detail.value;
    }
    handleFileChange() {
      const inpFiles = this.template.querySelector("input.file").files;
      if (inpFiles && inpFiles.length > 0) this.fileName = inpFiles[0].name;
    } 
  
   
    @wire(getRelatedFiles, { recordId: "$recordId" })
getFilesList(filesList) {
  this._filesList = filesList;
  const { error, data } = filesList;
  if (!error && data) {
    this.files = data.map(file => {
      const fileType = file.title.split('.').pop().toLowerCase();
      const iconUrl = `https://example.com/icons/${fileType}.png`; // replace with your own icon URL
      return { ...file, fileType, iconUrl };
    });
  }
}

    closeModal() {
      this.newFile=false;
      this._currentDocId = null;
      this.fileUpload = false;
      this.versionDetails = [];
      this.fileName = "";
      this.fileTitle = "";
      refreshApex(this._filesList);
      if(this.dialag) {
        this.dialag.closeModal();
      }
    } 
  
    handleRowAction(event) {
      const action = event.detail.action.name;
      const row = event.detail.row;
      this._currentDocId = row.id;
      var fileName=row.title;
      if (action === "show_details") {
        this.fileUpload = false;
        this.title=`File History - ${fileName}`;
        this.showVersionDetails(fileName);
      } else if (action === "upload_version") {
        this.fileUpload = true;
        if(this.dialag) {
            this.newFile=false;
            this.title=`Upload New Version of file - ${fileName}`;
            this.dialag.openmodal();
        }
      } else if (action === "delete") {
        this.deleteFiles([this._currentDocId]);
      }

  switch (action.name) {
    case "show_details":
      this.showFileVersions(row);
      break;
    case "upload_version":
      this.uploadFileVersions(row);
      break;
    case "delete":
      this.deleteFile(row);
      break;
    case "download":
      this.handleDownload(event);
      break;
    default:
      break;
  }
      
    } 
    handleDownload(event) {
      const fileId = event.detail.row.ContentDocument.LatestPublishedVersionId;
      const url = `/sfc/servlet.shepherd/version/download/${fileId}`;
    
      const a = document.createElement("a");
      a.href = url;
      a.download = event.detail.row.Title;
      document.body.appendChild(a);
      a.click();
      document.body.removeChild(a);
    }
    
    deleteFiles(recordIds) {
      if (recordIds.length > 0) {
        let decision = confirm(
          `Are you sure you want to delete ${recordIds.length} records?`
        );
        if (decision) {
          this._deleteRecord(recordIds);
        }
      }
    } 
   
    
    _deleteRecord(recordIds) {
      Promise.all(recordIds.map((id) => deleteRecord(id)))
        .then(() => {
          refreshApex(this._filesList);
          this.dispatchEvent(
            new ShowToastEvent({
              variant: "success",
              message: `Record deleted successfully`
            })
          );
        })
        .catch((err) => {
          this.dispatchEvent(
            new ShowToastEvent({
              variant: "error",
              message: `Error occurred while deleting records: ${
                err.body ? err.body.message || err.body.error : err
              }`
            })
          );
        });
    } 
    newFileUpload() {
      this.newFile=true;
      this.fileUpload = true;
      this.title='New File Upload';
      if(this.dialag)
      {
        this.dialag.openmodal();
      }
    } 

    get dialag()
    {
        return this.template.querySelector('c-dialog');
    }
    showVersionDetails() {
      getFileVersionDetails({ fileId: this._currentDocId })
        .then((result) => {
          this.versionDetails = result;
          if(this.dialag) {
              this.dialag.openmodal();
          }
        })
        .catch((err) => {
          console.error(JSON.stringify(err));
        });
    }
  
    handleUpload(event) {
      event.preventDefault();
      this.showSpinner = true;
      try {
        const file = this.template.querySelector("input.file").files[0];
        const reasonForChangeCtrl = this.template.querySelector(
          "lightning-input.reason"
        );
        const reader = new FileReader();
        let fileData = "";
        reader.onload = () => {
          fileData = reader.result;
          this.uploadFile(file, fileData, this.newFile?'':reasonForChangeCtrl.value);
        };
        reader.readAsDataURL(file);
      } catch (err) {
        console.error(err);
        this.dispatchEvent(
          new ShowToastEvent({
            variant: "error",
            message: `File upload failed: ${err.body.message || err.body.error}`
          })
        );
        this.showSpinner = false;
      }
    } 
  
    uploadFile(file, fileData, reasonForChange) {
      const payload = {
        Title: this.fileTitle || this.fileName,
        PathOnClient: file.name,
        ReasonForChange: reasonForChange,
        VersionData: fileData.replace(BASE64EXP, "")
      };
      if (this._currentDocId) {
        payload.ContentDocumentId = this._currentDocId;
      }
      createRecord({ apiName: "ContentVersion", fields: payload })
        .then((cVersion) => {
          this.showSpinner = false;
          if (!this._currentDocId) {
            this.createContentLink(cVersion.id);
          } else {
            this.closeModal();
            this.dispatchEvent(
              new ShowToastEvent({
                variant: "success",
                message: `Content Document Version created ${cVersion.id}`
              })
            );
          }
        })
        .catch((err) => {
          this.dispatchEvent(
            new ShowToastEvent({
              variant: "error",
              message: `File upload failed: ${err.body.message || err.body.error}`
            })
          );
          this.showSpinner = false;
        });
    } 
  
    createContentLink(cvId) {
     createContentDocLink({
        contentVersionId: cvId,
        recordId: this.recordId
      })
        .then((cId) => {
          this.closeModal();
          this.dispatchEvent(
            new ShowToastEvent({
              variant: "success",
              message: `File uploaded successfully ${cId}`
            })
          );
        })
        .catch((err) => {
          this.dispatchEvent(
            new ShowToastEvent({
              variant: "error",
              message: `An error occurred: ${
                err.body ? err.body.message || err.body.error : err
              }`
            })
          );
        });
    }

    
}