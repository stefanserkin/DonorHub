public with sharing class TestGiftReceiptController {
    
    @AuraEnabled
    public static String generatePDF(String recordId) {
        return TestGiftReceiptService.generatePDF(recordId);
    }

}