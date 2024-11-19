public without sharing class GiftReceiptTestController {
    public class OpportunityWrapper {
        public String Name {get;set;}
        public Date CloseDate {get;set;}
        public Decimal Amount {get;set;}
        public String StageName {get;set;}
    }

    public OpportunityWrapper opportunityData { get; private set; }

    public GiftReceiptTestController() {
        String opportunityId = ApexPages.currentPage().getParameters().get('id');
        if (opportunityId != null) {
            try {
                Opportunity opp = [
                    SELECT Name, CloseDate, Amount, StageName
                    FROM Opportunity
                    WHERE Id = :opportunityId
                     WITH SYSTEM_MODE
                    LIMIT 1
                ];
                opportunityData = new OpportunityWrapper();
                opportunityData.Name = opp.Name;
                opportunityData.CloseDate = opp.CloseDate;
                opportunityData.Amount = opp.Amount;
                opportunityData.StageName = opp.StageName;
            } catch (Exception e) {
                System.debug('Error fetching Opportunity: ' + e.getMessage());
                opportunityData = null; // Handle errors gracefully
            }
        }
    }
}
