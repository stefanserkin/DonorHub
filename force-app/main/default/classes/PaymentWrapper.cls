public class PaymentWrapper {

    @AuraEnabled
    public String id {get;set;}
    
    @AuraEnabled
    public Decimal amount {get;set;}

    @AuraEnabled
    public Boolean paid {get;set;}

    @AuraEnabled
    public Date scheduledDate {get;set;}

    @AuraEnabled
    public Date paymentDate {get;set;}

    @AuraEnabled
    public String checkReferenceNumber {get;set;}

    @AuraEnabled
    public String paymentMethod {get;set;}

}