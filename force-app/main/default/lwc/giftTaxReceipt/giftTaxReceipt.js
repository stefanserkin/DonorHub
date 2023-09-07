import { api } from 'lwc';
import LightningModal from 'lightning/modal';
import { loadScript } from 'lightning/platformResourceLoader';
import JSPDF from '@salesforce/resourceUrl/jspdf';

export default class GiftTaxReceipt extends LightningModal {
    @api recordId;
    @api gift;

    headers = this.createHeaders([
        "Id",
        "payAmount", 
        "payDate"
    ]);

    get headerImageUrl() {
        return 'https://asphaltgreen--uat.sandbox.file.force.com/servlet/servlet.ImageServer?id=0155e000000ScAp&oid=00D590000000Mzl&lastMod=1650829586000';
    }

    get footerImageUrl() {
        return 'https://asphaltgreen--uat.sandbox.file.force.com/servlet/servlet.ImageServer?id=0155e000000ScAu&oid=00D590000000Mzl&lastMod=1650829649000';
    }

    renderedCallback() {
        console.log('renderedCallback');
        
        Promise.all([
            loadScript(this, JSPDF)
        ]);
    }

    generatePdf() {
        console.log('::::: called generatePdf');
        console.log('jspdf --> ', window.jspdf);
        console.log('jsPDF --> ', window.jsPDF);
        const { jsPDF } = window.jspdf;
        console.log(jsPDF);
        const doc = new jsPDF({
            orientation: "portrait"
            // do stuff? the library allows for encryption that can be set up here
        });
        console.log(doc);

        doc.text('I am a tax receipt for a donation', 20, 20);
        // doc.table( 30, 30, this.gift.payments, this.headers, {autosize: true} );
        doc.save('gift-receipt.pdf');
    }

    loadTaxReceipt() {
        console.log('::::: called loadTaxReceipt');
        this.generatePdf();
    }

    createHeaders(keys) {
        let result = [];
        for (let i = 0; i < keys.length; i++) {
            result.push({
                id: keys[i],
                name: keys[i],
                prompt: keys[i],
                width: 65,
                align: "center",
                padding: 0
            });
        }
        return result;
    }

    handleOkay() {
        this.close('okay');
    }

}
