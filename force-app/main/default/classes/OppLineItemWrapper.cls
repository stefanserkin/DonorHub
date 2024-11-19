public class OppLineItemWrapper {

    @AuraEnabled
    public String id {get;set;}

    @AuraEnabled
    public String name {get;set;}

    @AuraEnabled
    public Decimal unitPrice {get;set;}

    @AuraEnabled
    public Integer quantity {get;set;}

    @AuraEnabled
    public Decimal totalPrice {get;set;}

    public OppLineItemWrapper(OpportunityLineItem oli) {
        this.id = oli.Id;
        this.name = oli.Name;
        this.unitPrice = oli.UnitPrice;
        this.quantity = Integer.valueOf( oli.Quantity );
        this.totalPrice = oli.TotalPrice;
    }
    
}