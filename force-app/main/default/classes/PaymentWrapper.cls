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

    public PaymentWrapper() {}

    public PaymentWrapper(npe01__OppPayment__c p) {
        this.id = p.Id;
        this.amount = p.npe01__Payment_Amount__c;
        this.scheduledDate = p.npe01__Scheduled_Date__c != null ? p.npe01__Scheduled_Date__c : null;
        if (p.npe01__Paid__c) {
            this.paid = true;
            this.paymentDate = p.npe01__Payment_Date__c != null ? p.npe01__Payment_Date__c : null;
            this.paymentMethod = p.npe01__Payment_Method__c != null ? p.npe01__Payment_Method__c : null;
            this.checkReferenceNumber = p.npe01__Check_Reference_Number__c != null ? p.npe01__Check_Reference_Number__c : null;
        } else {
            this.paid = false;
        }
    }

}