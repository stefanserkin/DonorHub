public with sharing class DonorHubController {
    
    @AuraEnabled(cacheable=true)
    public static List<GiftWrapper> getGiftHistory(
        String accountId
    ) {
        try {
            List<Opportunity> lstOpps = [
                SELECT Id, Amount, CloseDate, StageName, Committed_Date__c
                  FROM Opportunity
                 WHERE AccountId = :accountId
                   AND Committed__c = true
                  WITH SYSTEM_MODE
                 LIMIT 10000
            ];
            List<GiftWrapper> lstGifts = new List<GiftWrapper>();
            for (Opportunity opp : lstOpps) {
                GiftWrapper wrap = new GiftWrapper();
                wrap.id = opp.Id;
                wrap.amount = opp.Amount;
                wrap.closeDate = opp.CloseDate;
                wrap.stageName = opp.StageName;
                wrap.committedDate = opp.Committed_Date__c;
                wrap.disableReceipt = false;
                lstGifts.add(wrap);
            }
            return lstGifts;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    public class GiftWrapper {
        @AuraEnabled
        public Id id {get;set;}
        @AuraEnabled
        public Double amount {get;set;}
        @AuraEnabled
        public Date closeDate {get;set;}
        @AuraEnabled
        public Date committedDate {get;set;}
        @AuraEnabled
        public String stageName {get;set;}
        @AuraEnabled
        public Boolean disableReceipt {get;set;}
    }

}