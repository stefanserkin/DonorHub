import { LightningElement, api } from 'lwc';
import generatePDF from '@salesforce/apex/MyFirstPDFController.generatePDF';

export default class MyFirstPDF extends LightningElement {
    @api recordId;

    async downloadPdf() {
        try {
            const base64Pdf = await generatePDF({ recordId: this.recordId });

            // Create a Blob from the Base64 string
            const byteCharacters = atob(base64Pdf);
            const byteNumbers = new Array(byteCharacters.length).fill(0).map((_, i) => byteCharacters.charCodeAt(i));
            const byteArray = new Uint8Array(byteNumbers);
            const blob = new Blob([byteArray], { type: 'application/pdf' });

            // Create a link element for downloading
            const link = document.createElement('a');
            link.href = URL.createObjectURL(blob);
            link.download = 'MyReceipt.pdf';e
            link.click();

            // Clean up the URL object
            URL.revokeObjectURL(link.href);
        } catch (error) {
            console.error('Error generating PDF:', error);
        }
    }
}
