import { LightningElement, api, wire } from 'lwc';
import { getRecord } from 'lightning/uiRecordApi';
import { formatDate } from 'c/donorHubUtils';
import getGiftHistory from '@salesforce/apex/DonorHubController.getGiftHistory';
import generatePDF from '@salesforce/apex/DonorHubController.generatePDF';
import USER_ID from '@salesforce/user/Id';
import CONTACTID_FIELD from '@salesforce/schema/User.ContactId';
import ACCOUNTID_FIELD from '@salesforce/schema/User.AccountId';

// import { loadScript } from 'lightning/platformResourceLoader';
// import JSPDF from '@salesforce/resourceUrl/jspdf';
// import AG_LOGO_IMAGE from '@salesforce/resourceUrl/ag_logo';

const COLS = [
    { label: 'Date', fieldName: 'closeDate', type: 'date',
        typeAttributes:{
            year: "numeric",
            month: "long",
            day: "2-digit"
        }
    },
    { label: 'Amount', fieldName: 'amount', type: 'currency', 
        typeAttributes: { 
            currencyCode: 'USD'
        },
    },
    { label: 'Status', fieldName: 'stageName', type: 'text' },
    {  
        type: 'button',
        typeAttributes: {
            label: 'Download Receipt', 
            name: 'Download Receipt', 
            variant: 'brand-outline', 
            iconName: 'utility:download', 
            disabled: { fieldName: 'disableReceipt' },
        }
    }
];

export default class DonorHubGiftHistory extends LightningElement {
    @api cardTitle = 'My Gift History';
    @api cardIconName = 'standard:opportunity';
    error;
    isLoading = false;
    dateRangeValue = 'THIS_YEAR';

    cols = COLS;
    userId = USER_ID;
    accountId;
    contactId;
    wiredGiftHistory = [];
    householdGifts;

    get dateRangeOptions() {
        return [
            { label: 'This Year', value: 'THIS_YEAR' },
            { label: 'Last Year', value: 'LAST_YEAR' },
            { label: 'Last 2 Years', value: 'LAST_N_YEARS:2' },
            { label: 'Last 3 Years', value: 'LAST_N_YEARS:3' },
            { label: 'All Time', value: 'ALL_TIME' }
        ];
    }

    @wire(getRecord, {
		recordId: USER_ID,
		fields: [CONTACTID_FIELD, ACCOUNTID_FIELD]
	}) wireuser({
		error,
		data
	}) {
		if (error) {
			this.error = error; 
		} else if (data) {
			this.contactId = data.fields.ContactId.value;
			this.accountId = data.fields.AccountId.value;
		}
	}

    @wire(getGiftHistory, {
        accountId: '$accountId',
        dateRange: '$dateRangeValue'
    }) wiredResult(result) {
        this.isLoading = true;
        this.wiredGiftHistory = result;
        if (result.data) {
            let rows = JSON.parse (JSON.stringify(result.data) );
            rows.forEach(row => {
                row.closeDate = formatDate(row.closeDate);
                row.committedDate = row.committedDate != null ? formatDate(row.committedDate) : '';
                row.payments.forEach(pay => {
                    pay.scheduledDate = pay.scheduledDate != null ? formatDate(pay.scheduledDate) : '';
                    pay.paymentDate = pay.paymentDate != null ? formatDate(pay.paymentDate) : '';
                    pay.formattedAmount = '$' + pay.amount;
                });
            });
            this.householdGifts = rows;
            this.error = undefined;
        } else if (result.error) {
            this.householdGifts = undefined;
            this.error = result.error;
            console.error(this.error);
        }
        this.isLoading = false;
    }

    handleDownloadReceipt(event) {
        const selectedId = event.detail.row.id;
        // let selectedOpp = this.householdGifts.find(item => item.id === selectedId);
        // console.log(':::: selected opp --> ' + JSON.stringify(selectedOpp));
        this.downloadPDF(selectedId);
    }

    async downloadPDF(opportunityId) {
        try {
            console.log(':::: download pdf with record id --> ' + opportunityId);
            const base64Pdf = await generatePDF({ recordId: opportunityId });
            console.log('::: base64Pdf --> ' + base64Pdf);

            // Create a Blob from the Base64 string
            const byteCharacters = atob(base64Pdf);
            const byteNumbers = new Array(byteCharacters.length).fill(0).map((_, i) => byteCharacters.charCodeAt(i));
            const byteArray = new Uint8Array(byteNumbers);
            const blob = new Blob([byteArray], { type: 'application/pdf' });

            // Create a link element for downloading
            const link = document.createElement('a');
            link.href = URL.createObjectURL(blob);
            link.download = 'AsphaltGreenDonorAcknowledgment.pdf';
            link.click();

            // Clean up the URL object
            URL.revokeObjectURL(link.href);
        } catch (error) {
            console.error('Error generating PDF:', error);
        }
    }

    handleDateRangeChange(event) {
        this.dateRangeValue = event.detail.value;
    }


    /************************************************
     * jsPDF implementation for receipt generation
     ************************************************/
    /*
    agLogo = AG_LOGO_IMAGE;

    renderedCallback() {
        Promise.all([loadScript(this, JSPDF)]);
    }

    headers = this.createHeaders([
        "id",
        "formattedAmount", 
        "paymentDate"
    ]);

    handleDownloadAll() {
        console.log('Date range selected --> ',this.dateRangeValue);
    }

    generatePdf(opportunity) {
        const { jsPDF } = window.jspdf;
        const doc = new jsPDF({
            orientation: "portrait",
            unit: 'mm'
            // do more stuff? the library allows for encryption that can be set up here
        });
        doc.addImage(this.agLogo, "PNG", 10, 5, 80, 15, null, "FAST");
        doc.text(
            'I am a tax receipt for donation id: ' + opportunity.id, 
            20, 
            40
        );
        doc.table(20, 70, opportunity.payments, this.headers, { autosize:true });
        doc.save('gift-receipt.pdf');
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

    */

}