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

    /*
    public class Payment {
        @AuraEnabled
        public Decimal amount;

        @AuraEnabled
        public Boolean paid;

        @AuraEnabled
        public Date paymentDate;

        @AuraEnabled
        public String checkReferenceNumber;

        @AuraEnabled
        public String paymentMethod;
    }

    public class OppProduct {
        @AuraEnabled
        public Decimal unitPrice;

        @AuraEnabled
        public Integer quantity;

        @AuraEnabled
        public Decimal totalPrice;
    }
    */

}