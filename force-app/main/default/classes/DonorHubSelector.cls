public without sharing class DonorHubSelector {

    private static final String CLOSED_WON_PUBLIC_STATUS = 'Completed';
    private static final String DATE_RANGE_ALL_TIME = 'ALL_TIME';

    public static List<GiftWrapper> getGiftWrappers(
        String accountId,
        String dateRange
    ) {
        // Get opportunity wth child olis and payments
        String strQuery = 'SELECT Id, Amount, CloseDate, StageName, Committed_Date__c, ' +
            '(SELECT Id, Name, UnitPrice, Quantity, TotalPrice FROM OpportunityLineItems), ' +
            '(SELECT Id, npe01__Payment_Method__c, npe01__Paid__c, npe01__Payment_Date__c, npe01__Check_Reference_Number__c, npe01__Payment_Amount__c FROM npe01__OppPayment__r) ' +
            'FROM Opportunity WHERE AccountId = :accountId AND Committed__c = true ';
        // Add date filter if a date range other than ALL_TIME is passed
        if (dateRange != DATE_RANGE_ALL_TIME) {
            strQuery += 'AND CloseDate = ' + dateRange + ' ';
        }
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
            wrap.stageName = opp.StageName == 'Closed Won' ? CLOSED_WON_PUBLIC_STATUS : opp.StageName;
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

    
    public static List<GiftWrapper> getOutstandingPledges(
        String accountId
    ) {
        List<Opportunity> lstOppPledges = [
            SELECT Id, Amount, StageName, Committed_Date__c, CloseDate, Type, Memo__c,
                   (SELECT Id, npe01__Paid__c, npe01__Payment_Amount__c, npe01__Payment_Date__c, npe01__Scheduled_Date__c 
                      FROM npe01__OppPayment__r 
                     WHERE npe01__Paid__c = false)
              FROM Opportunity
             WHERE AccountId = :accountId
               AND StageName IN ('Pledged','Partially Paid')
              WITH SYSTEM_MODE
        ];
        List<GiftWrapper> lstPledges = new List<GiftWrapper>();
        if (!lstOppPledges.isEmpty()) {
            lstPledges = wrapGifts(lstOppPledges);
        }
        return lstPledges;                         
    }

    private static List<GiftWrapper> wrapGifts(
        List<Opportunity> lstOpps
    ) {
        List<GiftWrapper> lstWraps = new List<GiftWrapper>();
        for (Opportunity opp : lstOpps) {
            GiftWrapper wrap = new GiftWrapper();
            wrap.id = opp.Id;
            wrap.type = opp.Type != null ? opp.Type : null;
            wrap.amount = opp.Amount;
            wrap.closeDate = opp.CloseDate;
            wrap.committedDate = opp.Committed_Date__c != null ? opp.Committed_Date__c : null;
            wrap.stageName = opp.StageName == 'Closed Won' ? CLOSED_WON_PUBLIC_STATUS : opp.StageName;
            wrap.memo = opp.Memo__c != null ? opp.Memo__c : null;
            wrap.disableReceipt = false;
            wrap.olis = new List<OppLineItemWrapper>();
            wrap.payments = opp.npe01__OppPayment__r != null && !opp.npe01__OppPayment__r.isEmpty()
                ? wrapPayments(opp.npe01__OppPayment__r)
                : new List<PaymentWrapper>();
            lstWraps.add(wrap);
        }
        return lstWraps;
    }

    private static List<PaymentWrapper> wrapPayments(
        List<npe01__OppPayment__c> lstPayments
    ) {
        List<PaymentWrapper> lstPaymentWraps = new List<PaymentWrapper>();
        for (npe01__OppPayment__c p : lstPayments) {
            PaymentWrapper payWrap = new PaymentWrapper();
            payWrap.id = p.Id;
            payWrap.amount = p.npe01__Payment_Amount__c;
            payWrap.scheduledDate = p.npe01__Scheduled_Date__c != null ? p.npe01__Scheduled_Date__c : null;
            if (p.npe01__Paid__c) {
                payWrap.paid = true;
                payWrap.paymentDate = p.npe01__Payment_Date__c != null ? p.npe01__Payment_Date__c : null;
                payWrap.paymentMethod = p.npe01__Payment_Method__c != null ? p.npe01__Payment_Method__c : null;
                payWrap.checkReferenceNumber = p.npe01__Check_Reference_Number__c != null ? p.npe01__Check_Reference_Number__c : null;
            } else {
                payWrap.paid = false;
            }
            lstPaymentWraps.add(payWrap);
        }
        return lstPaymentWraps;
    }
    
}