public with sharing class OpportunityInvoiceController {
    private final Opportunity opp;

    public OpportunityInvoiceController(ApexPages.StandardController stdController) {
        this.opp = (Opportunity) stdController.getRecord();
    }

    public List<npe01__OppPayment__c> getPayments() {
        return [
            SELECT Id, 
                   npe01__Payment_Method__c, 
                   npe01__Payment_Date__c, 
                   npe01__Check_Reference_Number__c, 
                   npe01__Payment_Amount__c
              FROM npe01__OppPayment__c
             WHERE npe01__Opportunity__c = :opp.Id
               AND npe01__Paid__c = true
             LIMIT 200
        ];
    }

    public List<OpportunityLineItem> getOlis() {
        return [
            SELECT Id, 
                   Name, 
                   UnitPrice,
                   Quantity, 
                   TotalPrice
              FROM OpportunityLineItem
             WHERE OpportunityId = :opp.Id
             LIMIT 200
        ];
    }

}