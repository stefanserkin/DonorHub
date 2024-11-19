public with sharing class DonorHubController {
    
    @AuraEnabled(cacheable=true)
    public static List<GiftWrapper> getGiftHistory(String accountId, String dateRange) {
        try {
            List<GiftWrapper> lstGiftWraps = DonorHubSelector.getGiftWrappers(
                accountId, 
                dateRange
            );
            return lstGiftWraps;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }


    @AuraEnabled(cacheable=true)
    public static List<GiftWrapper> getOutstandingPledges(String accountId) {
        try {
            List<GiftWrapper> lstPledges = DonorHubSelector.getOutstandingPledges(accountId);
            return lstPledges;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled(cacheable=false)
    public static String generatePDF(String recordId) {
        return DonorAcknowledgmentService.generatePDF(recordId);
    }

}