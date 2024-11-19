public without sharing class DonorAcknowledgmentService {

    public class DonorAcknowledgmentServiceException extends Exception {}

    private static final String INVALID_ACCESS_MESSAGE = 'User does not have access to this data';
    private static final String ACKNOWLEDGMENT_PAGE_PATH = '/apex/DonorAcknowledgment';
    
    public static String generatePDF(String recordId) {
        if (!hasRecordAccess(recordId)) {
            throw new DonorAcknowledgmentServiceException(INVALID_ACCESS_MESSAGE);
        }

        PageReference pdfPage = new PageReference(ACKNOWLEDGMENT_PAGE_PATH);
        pdfPage.getParameters().put('id', recordId);
        Blob pdfBlob = pdfPage.getContentAsPDF();
        String result = EncodingUtil.base64Encode(pdfBlob);
        return result;
    }

    private static Boolean hasRecordAccess(String recordId) {
        List<User> runningUsersInOpportunityAccount = [
            SELECT Id 
              FROM User 
             WHERE Id = :UserInfo.getUserId()
               AND AccountId IN (SELECT AccountId FROM Opportunity WHERE Id = :recordId)
              WITH SYSTEM_MODE 
             LIMIT 1
        ];
        return !runningUsersInOpportunityAccount.isEmpty();
    }

}