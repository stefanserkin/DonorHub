public with sharing class MyFirstPDFController {
    
    @AuraEnabled
    public static String generatePDF(String recordId) {
        PageReference pdfPage = new PageReference('/apex/MyFirstPDF');
        pdfPage.getParameters().put('id', recordId);
        Blob pdfBlob = pdfPage.getContentAsPDF();
        return EncodingUtil.base64Encode(pdfBlob);
    }

}