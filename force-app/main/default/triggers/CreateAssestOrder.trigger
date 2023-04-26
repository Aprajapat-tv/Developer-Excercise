trigger CreateAssestOrder on Order (after update) {
   switch on Trigger.operationType{
        when AFTER_UPDATE{
            CreateRecordsAssest.createAssetOrderRecord(Trigger.new , Trigger.oldMap);
            CreateRecordsAssest.createUserRecords(Trigger.new);
            CreateRecordsAssest.updateAssets(Trigger.new,Trigger.oldMap);
            
           CreateRecordsAssest.contactToDripCampaign(Trigger.new,Trigger.oldMap);
            
        }
    }
}