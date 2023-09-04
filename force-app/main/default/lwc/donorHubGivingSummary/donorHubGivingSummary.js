/**
 *  
 *  Copyright (c) 2015, Salesforce.org
    All rights reserved.
    
    Redistribution and use in source and binary forms, with or without
    modification, are permitted provided that the following conditions are met:
    
    * Redistributions of source code must retain the above copyright
      notice, this list of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above copyright
      notice, this list of conditions and the following disclaimer in the
      documentation and/or other materials provided with the distribution.
    * Neither the name of Salesforce.org nor the names of
      its contributors may be used to endorse or promote products derived
      from this software without specific prior written permission.

    THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
    "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT 
    LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS 
    FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE 
    COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, 
    INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, 
    BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; 
    LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER 
    CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT 
    LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN 
    ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE 
    POSSIBILITY OF SUCH DAMAGE.
 */

import { LightningElement, api, wire } from 'lwc';
import { getRecord, getFieldDisplayValue } from 'lightning/uiRecordApi';
import donationHistoryGivingSummaryTitle from '@salesforce/label/npsp.donationHistoryGivingSummaryTitle';
import commonUnknownError from '@salesforce/label/npsp.commonUnknownError';
import donationHistoryLabelLifetime from '@salesforce/label/npsp.donationHistoryLabelLifetime';
import donationHistoryLabelThisYear from '@salesforce/label/npsp.donationHistoryLabelThisYear';
import donationHistoryLabelPreviousYear from '@salesforce/label/npsp.donationHistoryLabelPreviousYear';
import TOTAL_AMOUNT from '@salesforce/schema/Contact.npo02__TotalOppAmount__c';
import AMOUNT_CURRENT_YEAR from '@salesforce/schema/Contact.npo02__OppAmountThisYear__c';
import AMOUNT_LAST_YEAR from '@salesforce/schema/Contact.npo02__OppAmountLastYear__c';
import FORM_FACTOR from '@salesforce/client/formFactor';

const FormFactorType = Object.freeze({
    Large: 'Large',
    Medium: 'Medium',
    Small: 'Small',
});

const MOBILE_CLASSES = 'slds-text-align_left slds-text-heading_small slds-border_bottom slds-var-p-around_small';
const DESKTOP_CLASSES = 'slds-text-align_left slds-text-heading_small slds-border_right slds-var-p-around_small';
const FIELDS = [TOTAL_AMOUNT, AMOUNT_CURRENT_YEAR, AMOUNT_LAST_YEAR];

export default class DonorHubGivingSummary extends LightningElement {


    labels = {
        donationHistoryGivingSummaryTitle,
        donationHistoryLabelLifetime,
        donationHistoryLabelThisYear,
        donationHistoryLabelPreviousYear,
        commonUnknownError
    };

    lifetimeSummary = 0;
    thisYear = 0;
    previousYear = 0;
    
    contact;
    @api contactId;

    errorMessage=false;
    
    formFactor = FORM_FACTOR;

    @wire(getRecord, { recordId: '$contactId', fields: FIELDS})
        wiredRecord({ error, data }) {
            if (error) {
                this.errorMessage=true;
            } else if (data) {
                this.contact = data;
                this.lifetimeSummary = this.getConvertedAmount(getFieldDisplayValue(this.contact, TOTAL_AMOUNT));
                this.thisYear = this.getConvertedAmount(getFieldDisplayValue(this.contact, AMOUNT_CURRENT_YEAR));
                this.previousYear = this.getConvertedAmount(getFieldDisplayValue(this.contact, AMOUNT_LAST_YEAR));
            }
        }

    /**
     * @description Returns converted amounts if necessary
    */
    getConvertedAmount = (displayValue) => {
        const regExp = /\(([^)]+)\)/;
        const matches = regExp.exec(displayValue);
        return matches ? matches[1] : displayValue;
    }

    /**
     * @description Returns the classes to be applied to the rows accordling if it is mobile or desktop
     */
    get rowClasses() {
        if (this.isMobile) {
            return MOBILE_CLASSES;
        }
        return DESKTOP_CLASSES
    }

    /**
     * @description returns the classes of the giving summary title if it is mobile or desktop
     */
    get summaryTitleClass() {
        if(this.isMobile){
            return "slds-text-heading_small slds-var-p-left_small slds-var-p-bottom_medium bold-title"
        }
        return "slds-text-heading_medium slds-var-p-left_small slds-var-p-bottom_medium bold-title"
    }

    /**
     * @description Returns wether we are running in mobile or desktop
     * @returns True if it is mobile
     */
    get isMobile() {
        return this.formFactor === FormFactorType.Small;
    }


}