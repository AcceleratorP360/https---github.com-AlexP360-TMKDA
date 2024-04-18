import { LightningElement,api } from 'lwc';
import LightningDatatable from 'lightning/datatable';
import picklistColumn from './picklistColumn.html';
import pickliststatic from './pickliststatic.html';
import imageTableControl from './imageTableControl.html';

export default class LWCCustomDatatableType extends LightningDatatable {
    @api url;
    @api altText;
    static customTypes = {
        picklistColumn: {
            template: pickliststatic,
            editTemplate: picklistColumn,
            standardCellLayout: true,
            typeAttributes: ['label', 'placeholder', 'options', 'value', 'context', 'variant', 'name']
        },
        image: {
            template: imageTableControl
        }
    };
}