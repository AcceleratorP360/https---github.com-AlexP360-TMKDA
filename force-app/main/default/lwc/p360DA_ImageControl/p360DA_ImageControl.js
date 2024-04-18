import { LightningElement, api } from 'lwc';
export default class P360DA_ImageControl extends LightningElement {

    @api image;// image tag in string

    renderedCallback(){
        var targetDiv = this.template.querySelector('.image');
        targetDiv.innerHTML = this.image;
    }
}