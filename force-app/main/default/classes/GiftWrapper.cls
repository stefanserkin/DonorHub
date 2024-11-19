public class GiftWrapper {
    
    @AuraEnabled
    public String id {get;set;}

    /**
     * Opportunity Details
     */
    @AuraEnabled
    public String name {get;set;}

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

    /**
     * Account Information
     */
     @AuraEnabled
     public String accountId {get;set;}
 
     @AuraEnabled
     public String accountName {get;set;}
 
     @AuraEnabled
     public String formalGreeting {get;set;}
 
     @AuraEnabled
     public String billingStreet {get;set;}
 
     @AuraEnabled
     public String billingCity {get;set;}
 
     @AuraEnabled
     public String billingState {get;set;}
 
     @AuraEnabled
     public String billingPostalCode {get;set;}
 
     /**
      * Primary Contact Information
      */
     @AuraEnabled
     public String contactId {get;set;}

    /**
     * Child Lists
     */
    @AuraEnabled
    public PaymentWrapper[] payments {get;set;}

    @AuraEnabled
    public OppLineItemWrapper[] olis {get;set;}

    public GiftWrapper() {}

    public GiftWrapper(Opportunity opp) {
        this.id = opp.Id;
        this.name = opp.Name;
        this.type = opp.Type;
        this.amount = opp.Amount;
        this.closeDate = opp.CloseDate;
        this.committedDate = opp.Committed_Date__c;
        this.stageName = opp.StageName == 'Closed Won' ? 'Completed' : opp.StageName;
        this.memo = opp.Public_Memo__c;
        this.disableReceipt = false;
        this.accountId = opp.AccountId;
        this.accountName = opp.Account.Name;
        this.formalGreeting = opp.Account.npo02__Formal_Greeting__c;
        this.billingStreet = opp.Account.BillingStreet;
        this.billingCity = opp.Account.BillingCity;
        this.billingState = opp.Account.BillingState;
        this.billingPostalCode = opp.Account.BillingPostalCode;
        this.contactId = opp.npsp__Primary_Contact__c;

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