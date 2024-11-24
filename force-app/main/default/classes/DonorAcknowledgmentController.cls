public without sharing class DonorAcknowledgmentController {

    public GiftWrapper opportunityData {get; private set;}

    public DonorAcknowledgmentController() {
        String opportunityId = ApexPages.currentPage().getParameters().get('id');
        if (opportunityId != null) {
            try {
                Opportunity opp = [
                    SELECT Id, Name, Amount, CloseDate, StageName, Committed_Date__c, Type, Public_Memo__c, 
                           npsp__Primary_Contact__c, AccountId, Account.Name, Account.npo02__Formal_Greeting__c, 
                           Account.BillingStreet, Account.BillingCity, Account.BillingState, Account.BillingPostalCode, 
                           (SELECT Id, Name, UnitPrice, Quantity, TotalPrice 
                              FROM OpportunityLineItems),
                           (SELECT Id, npe01__Payment_Method__c, npe01__Paid__c, npe01__Payment_Date__c, npe01__Scheduled_Date__c, npe01__Check_Reference_Number__c, npe01__Payment_Amount__c 
                              FROM npe01__OppPayment__r)
                      FROM Opportunity
                     WHERE Id = :opportunityId
                      WITH SYSTEM_MODE
                     LIMIT 1
                ];
                opportunityData = new GiftWrapper(opp);
            } catch (Exception e) {
                System.debug('Error fetching Opportunity: ' + e.getMessage());
                opportunityData = null;
            }
        }
    }

}