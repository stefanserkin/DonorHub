import { LightningElement, api, wire } from 'lwc';
import { formatDate } from 'c/donorHubUtils';
import { getRecord } from 'lightning/uiRecordApi';
import getOutstandingPledges  from '@salesforce/apex/DonorHubController.getOutstandingPledges';
import USER_ID from '@salesforce/user/Id';
import CONTACT_ID_FIELD from '@salesforce/schema/User.ContactId';
import ACCOUNT_ID_FIELD from '@salesforce/schema/User.AccountId';
import FIRST_NAME_FIELD from '@salesforce/schema/User.FirstName';
import LAST_NAME_FIELD from '@salesforce/schema/User.LastName';
import EMAIL_FIELD from '@salesforce/schema/User.Email';

const FIELDS = [
    CONTACT_ID_FIELD, 
    ACCOUNT_ID_FIELD, 
    FIRST_NAME_FIELD, 
    LAST_NAME_FIELD, 
    EMAIL_FIELD
];

export default class DonorHubOpenPledges extends LightningElement {
    @api cardTitle;
    @api cardIconName;
    isLoading = false;
    error;

    makePaymentBaseUrl = 'https://give.asphaltgreen.org/pledge-payment?';

    userId = USER_ID;
    contactId;
    accountId;
    firstName;
    lastName;
    email;

    wiredPledges = [];
    pledges;

    @wire(getRecord, {
		recordId: USER_ID,
		fields: FIELDS
	}) wireuser({
		error,
		data
	}) {
		if (error) {
			this.error = error; 
		} else if (data) {
			this.contactId = data.fields.ContactId.value;
			this.accountId = data.fields.AccountId.value;
            this.firstName = data.fields.FirstName.value;
			this.lastName = data.fields.LastName.value;
            this.email = data.fields.Email.value;
		}
	}

    @wire(getOutstandingPledges, {accountId: '$accountId'})
    wiredResult(result) {
        this.isLoading = true;
        this.wiredPledges = result;
        if (result.data) {
            let rows = JSON.parse( JSON.stringify(result.data) );
            rows.forEach(row => {
                row.closeDate = formatDate(row.closeDate);
                row.committedDate = formatDate(row.committedDate);
                row.payments.forEach(pay => {
                    pay.scheduledDate = formatDate(pay.scheduledDate);
                    if (pay.paymentDate != null) {
                        pay.paymentDate = formatDate(pay.paymentDate);
                    }
                })
            });

            this.pledges = rows;
            this.error = undefined;
        } else if (result.error) {
            this.pledges = undefined;
            this.error = result.error;
        }
    }

    handleMakePayment(event) {
        const selected = event.currentTarget.dataset;
        let url = this.makePaymentBaseUrl + 
            'id=' + selected.id + 
            '&onetime_other_amt=' + selected.amount + 
            '&name=' + this.firstName + ' ' + this.lastName + 
            '&email=' + this.email;
        window.open(url, '_blank');
    }

}