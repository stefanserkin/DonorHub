public with sharing class ParticipantScorecardController {
    public Id programEngagementId { get; set; }
    public pmdm__ProgramEngagement__c programEngagement { get; set; }
    public List<Self_Assessment__c> selfAssessments { get; set; }
    public List<pmdm__ServiceDelivery__c> serviceDeliveries { get; set; }

    public ParticipantScorecardController() {
        // Assuming the ID is passed as a URL parameter
        programEngagementId = ApexPages.currentPage().getParameters().get('id');
        if (programEngagementId != null) {
            loadData();
        }
    }

    private void loadData() {
        // Query the Program Engagement
        programEngagement = [
            SELECT Id, Name
              FROM pmdm__ProgramEngagement__c
             WHERE Id = :programEngagementId
             LIMIT 1
        ];

        // Query the Self-Assessments related to the Program Engagement
        selfAssessments = [
            SELECT Id, Name,
                   (SELECT Id, Question__c, Answer_Number__c, Answer_Text_Area__c
                      FROM Self_Assessment_Answers__r)
              FROM Self_Assessment__c
             WHERE Program_Engagement__c = :programEngagementId
        ];

        // Query the Service Deliveries related to the Program Engagement
        serviceDeliveries = [
            SELECT Id, Name, pmdm__DeliveryDate__c, pmdm__AttendanceStatus__c
              FROM pmdm__ServiceDelivery__c
             WHERE pmdm__ProgramEngagement__c = :programEngagementId
        ];
    }
}
