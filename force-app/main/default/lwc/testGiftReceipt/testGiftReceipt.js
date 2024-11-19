import { LightningElement } from 'lwc';
import generatePDF from '@salesforce/apex/TestGiftReceiptController.generatePDF';

export default class TestGiftReceipt extends LightningElement {
    recordId;

    handleRecordIdChange(event) {
        this.recordId = event.target.value;
    }

    async downloadPdf() {
        try {
            console.log(':::: download pdf with record id --> ' + this.recordId);
            const base64Pdf = await generatePDF({ recordId: this.recordId });
            console.log('::: base64Pdf --> ' + base64Pdf);

            // Create a Blob from the Base64 string
            const byteCharacters = atob(base64Pdf);
            const byteNumbers = new Array(byteCharacters.length).fill(0).map((_, i) => byteCharacters.charCodeAt(i));
            const byteArray = new Uint8Array(byteNumbers);
            const blob = new Blob([byteArray], { type: 'application/pdf' });

            // Create a link element for downloading
            const link = document.createElement('a');
            link.href = URL.createObjectURL(blob);
            link.download = 'GeneratedDocument.pdf'; // Set the desired file name
            link.click();

            // Clean up the URL object
            URL.revokeObjectURL(link.href);
        } catch (error) {
            console.error('Error generating PDF:', error);
        }
    }

}