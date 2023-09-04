public with sharing class DonorHubController {
    
    @AuraEnabled(cacheable=true)
    public static List<GiftWrapper> getGiftHistory(
        String accountId, 
        String dateRange
    ) {
        try {
            List<GiftWrapper> lstGiftWraps = DonorHubSelector.getGiftWrappers(
                accountId, dateRange
            );
            return lstGiftWraps;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

}