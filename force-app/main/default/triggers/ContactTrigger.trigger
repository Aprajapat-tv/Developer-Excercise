trigger ContactTrigger on Contact (after insert,after update,after delete,after undelete) {
    
    if(trigger.isAfter){
        if(trigger.isInsert||trigger.isUpdate){
            Exercise5.OneContactMarkedAsPrimary(trigger.new);
            Exercise5.CopyEmailToParent(trigger.new);
            
        }
          if(trigger.isInsert ||Trigger.isDelete||Trigger.isUndelete){
             Exercise5.CountContact(trigger.old,Trigger.new);
            
        }
    }
   
}