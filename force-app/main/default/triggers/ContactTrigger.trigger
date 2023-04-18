trigger ContactTrigger on Contact (after insert,after update,after delete,after undelete) {
    
    if(trigger.isAfter){
        if(trigger.isInsert || Trigger.isAfter){
            Exercise5.OneContactMarkedAsPrimary(trigger.new);
             Exercise5.CopyEmailToParent(trigger.new);
            
        }
        
    }
    if(trigger.isAfter){
        if(trigger.isInsert || Trigger.isAfter||Trigger.isDelete||Trigger.isUndelete){
             Exercise5.CountContact(trigger.old,Trigger.new);
            
        }
        
    }
}