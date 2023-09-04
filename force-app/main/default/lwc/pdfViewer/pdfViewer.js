import { api } from 'lwc';
import LightningModal from 'lightning/modal';

export default class PdfViewer extends LightningModal {
    @api recordId;
    baseUrl = '/apex/OpportunityInvoice?Id=';

    get pdfUrl() {
        console.log('getting pdfUrl with id --> ' + this.recordId);
        return this.baseUrl + this.recordId;
    }

    handleOkay() {
        this.close('okay');
    }

}