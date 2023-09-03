import { LightningElement, wire } from 'lwc';
import { getRecord } from 'lightning/uiRecordApi';
import InvoiceModal from 'c/pdfViewer';
import getGiftHistory from '@salesforce/apex/DonorHubController.getGiftHistory';

import USER_ID from '@salesforce/user/Id';
import CONTACTID_FIELD from '@salesforce/schema/User.ContactId';
import ACCOUNTID_FIELD from '@salesforce/schema/User.AccountId';

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
    error;
    isLoading = false;
    cardTitle = 'My Gift History';
    cardIconName = 'standard:opportunity';

    cols = COLS;
    userId = USER_ID;
    accountId;
    contactId;
    wiredGiftHistory = [];
    householdGifts;

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

    @wire(getGiftHistory, {accountId: '$accountId'})
    wiredResult(result) {
        this.isLoading = true;
        this.wiredGiftHistory = result;
        if (result.data) {
            this.householdGifts = result.data;
            console.table(this.householdGifts);
            this.error = undefined;
        } else if (result.error) {
            this.householdGifts = undefined;
            this.error = result.error;
            console.error(this.error);
        }
        this.isLoading = false;
    }

    async handleDownloadReceipt(event) {
        const selectedId = event.detail.row.id
        console.log(' handle download receipt with id --> ' + selectedId);
        const result = await InvoiceModal.open({
            // `label` is not included here in this example.
            // it is set on lightning-modal-header instead
            size: 'large',
            description: 'Accessible description of modal\'s purpose',
            recordId: selectedId,
        });
        // if modal closed with X button, promise returns result = 'undefined'
        // if modal closed with OK button, promise returns result = 'okay'
        console.log(result);
    }

}