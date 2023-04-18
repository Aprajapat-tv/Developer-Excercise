public class Exercise5 {
    public static void OneContactMarkedAsPrimary(List<Contact> clist){
          Set<Id> accountIds = new Set<Id>();
        Map<Id, Contact> primaryContactsMap = new Map<Id, Contact>();
        for (Contact contact : clist) {
            if (contact.Is_Primary__c && contact.AccountId != null) {
                accountIds.add(contact.AccountId);
                primaryContactsMap.put(contact.AccountId, contact);
            }
        }

        List<Contact> contactsToUpdate = new List<Contact>();
        for (Contact contact : [SELECT Id, Is_Primary__c, AccountId FROM Contact WHERE AccountId IN :accountIds AND Is_Primary__c = true]) {
            if (!primaryContactsMap.containsKey(contact.AccountId) || primaryContactsMap.get(contact.AccountId).Id != contact.Id) {
                contact.Is_Primary__c = false;
                contactsToUpdate.add(contact);
            }
        }

        if (!contactsToUpdate.isEmpty()) {
            update contactsToUpdate;
        }
    
    }
    
    public static void CopyEmailToParent(List<Contact> clist){
        
        Map<Id,String> ContactList=new Map<Id,String>();
    Set<Id> AcctId=new Set<Id>();
    for(Contact contact: clist){
        if(contact.Is_Primary__c && contact.AccountId != null){
            ContactList.put(contact.AccountId,contact.Email);
            AcctId.add(contact.AccountId);
        }
    }
    List<Account> parentId=[Select ParentId,Id from account where id in :AcctId];
    
    Set<Id> parentIdSet = new Set<Id>();
    for (Account account : parentId) {
        if (account.ParentId != null) {
            parentIdSet.add(account.ParentId);
        }
    }
    
   List<Account> accList = [Select Id, (Select Id, Email, Is_Primary__c FROM Contacts) From Account where Id in :parentIdSet];
    
    List<Contact> updatedContactList = new List<Contact>();
    for (Id accountId : ContactList.keySet()) {
        String contactEmail = ContactList.get(accountId);
        
        Id parentAccountId = null;
        for (Account accountToParent : parentId) {
            if (accountId == accountToParent.Id) {
                parentAccountId = accountToParent.ParentId;
                break;
            }
        }
        
        if (parentAccountId != null) {
            for (Account parent : accList) {
                if (parentAccountId == parent.Id) {
                    for (Contact contact : parent.Contacts) {
                        if (contact.Is_Primary__c == true) {
                            contact.Email = contactEmail;
                            updatedContactList.add(contact);
                        }
                    }
                }
            }
        }
    }

      update updatedContactList;
    }
    
    public static void CountContact(List<Contact> coldlist,List<Contact> cnewlist){
          if(trigger.isafter){
        Set<id> accId = new Set<id>();
        if(cnewlist != NUll){
            for(Contact c: cnewlist){
            if(c.accountId != NULL){
                accId.add(c.accountId);
            }
        }
        }
        if(coldlist != NULL){
            for(Contact c: coldlist){
            if(c.accountId != NULL){
                accId.add(c.accountId);
            }
        }
        }
       
        List <Account> acc = [select id, Contact_Count__c,(select id from Contacts) from Account where Id in :accId];
        if(!acc.isEmpty()){
            for(Account a : acc){
                a.Contact_Count__c = a.Contacts.size();
            }
        }
        update acc;
    
    }
 
    }
}