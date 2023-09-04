public class GiftWrapper {

    /**
     * Opportunity record id
     */
    @AuraEnabled
    public String id {get;set;}

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

    @AuraEnabled
    public PaymentWrapper[] payments {get;set;}

    @AuraEnabled
    public OppLineItemWrapper[] olis {get;set;}

}