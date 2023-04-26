@isTest
public class TestClassForContact {
    
    // Test class for Exercise 5.1
    @isTest
    static void testIsPrimary() {
        Account account = new Account(Name = 'Ajay');
        insert account;
        
        Contact firstPrimaryContact = new Contact(LastName = 'Prajapat', Is_Primary__c = true, AccountId = account.Id);
        insert firstPrimaryContact;
        
        System.assertEquals('Prajapat', [Select Id, LastName, Is_Primary__c from Contact where Is_Primary__c = true limit 1].LastName);
    }
    
    @isTest
    static void testIsPrimaryMultiple() {
        Account account = new Account(Name = 'Ajay');
        insert account;
        
        Contact firstPrimaryContact = new Contact(LastName = 'Prajapat', Is_Primary__c = true, AccountId = account.Id);
        insert firstPrimaryContact;
        
        Contact secondPrimaryContact = new Contact(LastName = 'Mayank', Is_Primary__c = true, AccountId = account.Id);
        insert secondPrimaryContact;
        
        System.assertEquals('Prajapat', [Select Id, LastName, Is_Primary__c from Contact where Is_Primary__c = false limit 1].LastName);
    }
    
    
    // Test class for Exercise 5.2
    
     @isTest static void ChkEmailCopyOrNot(){
  // creat parent account and its contact
        Account account=new Account();
        account.Name='Ajay prajapat';
        insert account;
        Id aId=account.Id;
        
        Contact parentContact= new Contact();
        parentContact.LastName='Sharma';
        parentContact.AccountId=aId;
        parentContact.Is_Primary__c=true;
        insert parentContact;
        
// create Child Account and its Contact 
        Account childAccount=new Account();
        childAccount.Name='Ajay2Prajapat';
        childAccount.ParentId=aId;
        insert childAccount;
        Id childId=childAccount.Id;
       
        Contact contact=new Contact();
        contact.Email='ajay@gmail.com';
        String StoreEmail='ajay@gmail.com';
        contact.LastName='Prajapat';
        contact.Is_Primary__c=true;
        contact.AccountId= childId;
        insert contact;
        
        List<Account> ParentAccoountId=[Select ParentId from Account where Id=:childId];
        List<Id> ParentIds=new List<Id>();
        for(Account i:ParentAccoountId){
            ParentIds.add(i.ParentId);
        }
        
        List<Contact> ParentIdContacts=[Select Id ,Email from contact where AccountId In:ParentIds and Is_Primary__c=true ];
        String CopyEmail;
        for(Contact i:ParentIdContacts){
            CopyEmail=i.Email;
        }
        System.assertEquals(StoreEmail,CopyEmail);
        
        
    }
    
    
    // Test Class for Exercise 5.3
    @isTest static void chkContactCount(){
        Account account= new Account();
        account.Name='Ajay';
        insert account;
      Id accountId = account.Id;
        
       Contact contact= new Contact();
        contact.LastName= 'Ajay1';
        contact.AccountId=accountId;
        insert contact;
        Contact contact1= new Contact();
        contact1.LastName= 'Ajay2';
        contact1.AccountId=accountId;
        insert contact1;
        Contact contact2= new Contact();
        contact2.LastName= 'Ajay3';
        contact2.AccountId=accountId;
        insert contact2;
        contact2.LastName= 'Ajay343';
        update contact2;
        List<Contact> contactList=[Select Id from contact where AccountId=:AccountId];
        Integer Count=contactList.size();
        System.assertEquals(3,Count);
        
        
        }
}