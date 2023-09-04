import { LightningElement, api, wire } from 'lwc';
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
            this.householdGifts = result.data;
            this.error = undefined;
        } else if (result.error) {
            this.householdGifts = undefined;
            this.error = result.error;
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

    handleDateRangeChange(event) {
        this.dateRangeValue = event.detail.value;
    }

}