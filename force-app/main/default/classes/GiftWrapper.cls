public class GiftWrapper {
    
    @AuraEnabled
    public String id {get;set;}

    @AuraEnabled
    public String name {get;set;}

    @AuraEnabled
    public String accountId {get;set;}

    @AuraEnabled
    public String contactId {get;set;}

    @AuraEnabled
    public String type {get;set;}

    @AuraEnabled
    public Double amount {get;set;}

    @AuraEnabled
    public Date closeDate {get;set;}

    @AuraEnabled
    public Date committedDate {get;set;}

    @AuraEnabled
    public String stageName {get;set;}

    @AuraEnabled
    public String memo {get;set;}

    @AuraEnabled
    public Boolean disableReceipt {get;set;}

    @AuraEnabled
    public PaymentWrapper[] payments {get;set;}

    @AuraEnabled
    public OppLineItemWrapper[] olis {get;set;}

    public GiftWrapper(Opportunity opp) {
        this.id = opp.Id;
        this.name = opp.Name;
        this.accountId = opp.AccountId;
        this.contactId = opp.npsp__Primary_Contact__c;
        this.type = opp.Type;
        this.amount = opp.Amount;
        this.closeDate = opp.CloseDate;
        this.committedDate = opp.Committed_Date__c;
        this.stageName = opp.StageName == 'Closed Won' ? 'Completed' : opp.StageName;
        this.memo = opp.Public_Memo__c;
        this.disableReceipt = false;

        if (opp.OpportunityLineItems != null && !opp.OpportunityLineItems.isEmpty()) {
            this.olis = new List<OppLineItemWrapper>();
            for (OpportunityLineItem oli : opp.OpportunityLineItems) {
                this.olis.add(new OppLineItemWrapper(oli));
            }
        }

        if (opp.npe01__OppPayment__r != null && !opp.npe01__OppPayment__r.isEmpty()) {
            this.payments = new List<PaymentWrapper>();
            for (npe01__OppPayment__c payment : opp.npe01__OppPayment__r) {
                this.payments.add(new PaymentWrapper(payment));
            }
        }
    }

}