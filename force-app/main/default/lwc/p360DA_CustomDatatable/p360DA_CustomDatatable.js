import LightningDatatable from 'lightning/datatable';
import imageTableControl from './p360DA_ImageTableControl.html';

export default class P360DA_CustomDatatable extends LightningDatatable  {

    static customTypes = {
        image: {
            template: imageTableControl
        }
    };

}