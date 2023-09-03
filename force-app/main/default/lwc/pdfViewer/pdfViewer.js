import { api } from 'lwc';
import LightningModal from 'lightning/modal';

export default class PdfViewer extends LightningModal {
    @api recordId;

    get pdfUrl() {
        console.log('getting pdfUrl with id --> ' + this.recordId);
        return 'https://asphaltgreen--uat.sandbox.lightning.force.com/apex/OpportunityInvoice?Id=' + this.recordId;
    }

    handleOkay() {
        this.close('okay');
    }

}