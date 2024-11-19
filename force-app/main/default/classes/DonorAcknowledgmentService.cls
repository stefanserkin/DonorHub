public with sharing class DonorAcknowledgmentService {
    
    public static String generatePDF(String recordId) {
        System.debug(':::::: generatePDF');
        PageReference pdfPage = new PageReference('/apex/DonorAcknowledgment');
        System.debug(':::::: pdfPage --> ' + pdfPage);
        pdfPage.getParameters().put('id', recordId);
        System.debug(':::::: id --> ' + recordId);
        Blob pdfBlob = pdfPage.getContentAsPDF();
        System.debug(':::::: pdfBlob --> ' + pdfBlob);
        String result = EncodingUtil.base64Encode(pdfBlob);
        System.debug(':::::: result --> ' + result);
        return result;
    }

}