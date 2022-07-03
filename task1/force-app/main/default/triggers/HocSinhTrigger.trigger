trigger HocSinhTrigger on HocSinh__c (before delete, before insert, before update, after delete, after insert, after update) {  
 
if (Trigger.isBefore) {
    
    if (Trigger.isInsert) {
        List<HocSinh__c> hs= new List<HocSinh__c>();
        for(HocSinh__c item : Trigger.new ){
            hs.add(item);
        }
  		HocSinhTriggerHandler.onBeforeInsert(hs);
    } 
    if (Trigger.isUpdate) {
        HocSinhTriggerHandler.onBeforeUpdate(Trigger.new, Trigger.oldMap);
    }
    if (Trigger.isDelete) {
        HocSinhTriggerHandler.onBeforeDelete(Trigger.new, Trigger.oldMap);
    }
 }
    
if (Trigger.isAfter) {
   if (Trigger.isInsert) {
       List<HocSinh__c> hs= new List<HocSinh__c>();
       hs=Trigger_new();
  	   HocSinhTriggerHandler.onAfterInsert(hs);
    } 
    if (Trigger.isUpdate) {
       List<HocSinh__c> hs= new List<HocSinh__c>();
       hs=Trigger_new();
       List<HocSinh__c> hsold= new List<HocSinh__c>();
       hsold=Trigger_old();
        
       HocSinhTriggerHandler.onAfterUpdate(hs, hsold);
    }
    if (Trigger.isDelete) {
       List<HocSinh__c> hsold= new List<HocSinh__c>();
       hsold=Trigger_old();
       HocSinhTriggerHandler.onAfterDelete(hsold);
    }
 }
    
    public List<HocSinh__c> Trigger_new (){
        List<HocSinh__c> hs = new List<HocSinh__c>();
        for(HocSinh__c item : Trigger.new ){
            hs.add(item);
        }
        return hs;
    }
    
    public List<HocSinh__c> Trigger_old(){
        List<HocSinh__c> hs = new List<HocSinh__c>();
        for(HocSinh__c item : Trigger.old ){
            hs.add(item);
        }
        return hs;
    }
}