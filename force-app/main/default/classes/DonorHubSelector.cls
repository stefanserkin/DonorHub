public without sharing class DonorHubSelector {

    private static final String CLOSED_WON_STATUS = 'Completed';

    public static List<GiftWrapper> getGiftWrappers(
        String accountId,
        String dateRange
    ) {
        // Get opportunity wth child olis and payments
        String strQuery = 'SELECT Id, Amount, CloseDate, StageName, Committed_Date__c, ';
        strQuery += '(SELECT Id, Name, UnitPrice, Quantity, TotalPrice FROM OpportunityLineItems), ';
        strQuery += '(SELECT Id, npe01__Payment_Method__c, npe01__Paid__c,npe01__Payment_Date__c, npe01__Check_Reference_Number__c, npe01__Payment_Amount__c FROM npe01__OppPayment__r) ';
        strQuery += 'FROM Opportunity WHERE AccountId = :accountId AND Committed__c = true AND CloseDate = ' + dateRange + ' ';
        strQuery += 'WITH SYSTEM_MODE ORDER BY CloseDate DESC LIMIT 1000';
        System.debug('::::: strQuery --> ' + strQuery);
        List<Opportunity> lstOpps = Database.query(strQuery);

        // Create list of wrappers to return
        List<GiftWrapper> lstGifts = new List<GiftWrapper>();
        for (Opportunity opp : lstOpps) {
            GiftWrapper wrap = new GiftWrapper();
            // Opportunity
            wrap.id = opp.Id;
            wrap.amount = opp.Amount;
            wrap.closeDate = opp.CloseDate;
            wrap.stageName = opp.StageName == 'Closed Won' ? CLOSED_WON_STATUS : opp.StageName;
            wrap.committedDate = opp.Committed_Date__c;
            wrap.disableReceipt = false;
            // Products
            if (!opp.OpportunityLineItems.isEmpty()) {
                List<OppLineItemWrapper> lstOlis = new List<OppLineItemWrapper>();
                for (OpportunityLineItem oli : opp.OpportunityLineItems) {
                    OppLineItemWrapper oliWrap = new OppLineItemWrapper();
                    oliWrap.id = oli.Id;
                    oliWrap.name = oli.Name;
                    oliWrap.unitPrice = oli.UnitPrice;
                    oliWrap.quantity = Integer.valueOf(oli.Quantity);
                    oliWrap.totalPrice = oli.TotalPrice;
                    lstOlis.add(oliWrap);
                }
                wrap.olis = lstOlis;
            } else {
                wrap.olis = new List<OppLineItemWrapper>();
            }
            // Payments
            if (!opp.npe01__OppPayment__r.isEmpty()) {
                List<PaymentWrapper> lstPayments = new List<PaymentWrapper>();
                for (npe01__OppPayment__c p : opp.npe01__OppPayment__r) {
                    PaymentWrapper payWrap = new PaymentWrapper();
                    payWrap.id = p.Id;
                    payWrap.amount = p.npe01__Payment_Amount__c;
                    payWrap.paid = p.npe01__Paid__c;
                    payWrap.paymentMethod = p.npe01__Payment_Method__c;
                    payWrap.paymentDate = p.npe01__Payment_Date__c;
                    payWrap.checkReferenceNumber = p.npe01__Check_Reference_Number__c;
                    lstPayments.add(payWrap);
                }
                wrap.payments = lstPayments;
            } else {
                wrap.payments = new List<PaymentWrapper>();
            }
            // Add wrapper to collection
            lstGifts.add(wrap);
        }
        // Return wrapper collection
        return lstGifts;
    }
    
}