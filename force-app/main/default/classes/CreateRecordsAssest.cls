public class CreateRecordsAssest {

public static void createAssetOrderRecord(List<Order> orderList,Map<Id,Order> oldOrderMap){ 
    List<Asset> assetList = new List<Asset>();
    List<Asset> assetListPocTrue=new List<Asset>();
     List<BusinessHours>businessHours = [SELECT id from BusinessHours];
    List<Entitlement> enList = new List<Entitlement>();
        Set<Id> idSet = new Set<Id>();
        for(Order o : orderList){
            if(oldOrderMap.containsKey(o.Id)){
                if(o.Status=='Activated' && oldOrderMap.get(o.Id).Status=='Draft'){
                    idSet.add(o.id);
                }
            } 
        }
    List<OrderItem> orIdList = [Select id , order.Accountid , UnitPrice , Quantity , Product2.family , order.opportunityId from OrderItem where order.id in : idSet];
        if(!idSet.isEmpty()){
            for(orderItem i : orIdList){
            if(i.Product2.family == 'Software'){
                for(integer j = 0 ; j < i.Quantity ; j++ ){
                    Asset a = new Asset();
                    a.Name = 'Asset' + i.Order.Name + i.Product2.ProductCode + j;
                    a.AccountId =  i.order.AccountId;
                    a.Opportunity__c = i.order.OpportunityId;
                   	a.Status = 'Purchased'; 
                    a.Quantity = 1;
                    a.Price = i.UnitPrice;
                    a.Product2Id =  i.Product2Id;
                    a.PurchaseDate = i.order.EffectiveDate;
                    if(i.Product2.Poc__c==false){
                        assetList.add(a); 
                    }   
                    if(i.Product2.Poc__c==true){
                        assetListPocTrue.add(a);
                    }
                } 
                
                 
            }
        }
          insert assetList;   
            insert assetListPocTrue;
        }
        for(Asset i:assetList){
        	Entitlement a = new Entitlement();
            a.Name=i.Name;
            a.AccountId=i.AccountId;
            a.Id=i.Id;
            a.StartDate=i.PurchaseDate; 
            a.EndDate=i.PurchaseDate+365;
             a.BusinessHoursId = businessHours[0].id;
            enList.add(a);
            
    }
    for(Asset i:assetListPocTrue){
        	Entitlement a = new Entitlement();
            a.Name=i.Name;
            a.AccountId=i.AccountId;
            a.Id=i.Id;
            a.StartDate=i.PurchaseDate; 
            a.EndDate=i.PurchaseDate+90;
        a.BusinessHoursId = businessHours[0].id;
            enList.add(a);
            
    }
    insert enList;
       
    }
    
    // update asset records
     public static void updateAssets(List<Order> orderList, Map<Id,Order> oldOrderList)
    {
        Set<Id> shippedOrder=new Set<Id>();
        for(Order ord:orderList)
        {
            if(oldOrderList.containsKey(ord.Id)&& oldOrderList.get(ord.Id).Status=='Activated' && ord.Status=='Shipped')
            {
                shippedOrder.add(ord.Id);
            }
        }
        if(shippedOrder.size()==0) return;
        
         List<OrderItem> orderValues=[select OrderId,UnitPrice,Order.EffectiveDate,Product2.POC__c,Order.OpportunityId,
                                     Order.AccountId,Order.status,Product2.Id,Product2.Name,Product2.ProductCode, 
                                     Product2.Family,Quantity from OrderItem where Product2.Family='Software' and OrderId In :shippedOrder];
        List<String> assetName = new List<String>();
        for(OrderItem ordItem : orderValues)
        {
            Integer totalAsset=(Integer)ordItem.Quantity;
            for(Integer i=0;i<totalAsset;i++)
            {
                String Name=(String)'Asset '+ ordItem.Product2.Name +' '+ ordItem.Product2.ProductCode + i;
                System.debug(Name);
                assetName.add(Name);
            }  
        }
        List<Asset> allAssets =[select Status,Actual_Ship_Date__c,Name from Asset where Name In :assetName];
        System.debug('Asset List :- '+allAssets);
        for(Asset assets: allAssets)
        {
            assets.Status='Shipped';
            assets.Actual_Ship_Date__c=Date.today();  
        }
        update allAssets;
    }
      //function to create user record
      public static void createUserRecords(List<Order> orderList)
    {
         Set<Id> oppIdSet = new Set<Id>();
        for (Order order : orderList) {
            if (order.Status == 'Shipped' && order.OpportunityId != null) {
                oppIdSet.add(order.OpportunityId);
            }
        }

        List<OpportunityContactRole> opportunityContactRoleList = [Select Id, Contact.Id, Contact.Name, Contact.Email, OpportunityId, IsPrimary from OpportunityContactRole where IsPrimary = true and OpportunityId in :oppIdSet and Contact.Email != null];

        Map<String, String> usernameToNameMap = new Map<String, String>();
        for (OpportunityContactRole opportunityContactRole : opportunityContactRoleList) {
            usernameToNameMap.put(opportunityContactRole.Contact.Email, opportunityContactRole.Contact.Name);
        }

        if (usernameToNameMap.size() == 0) return;

        Profile customerCommunityLoginUserProfile = [Select Id, Name from Profile where Name = 'Customer Community Login User' limit 1];
        

        List<User> userList = [Select Id, Name, Email, Username, IsActive from User where Username in :usernameToNameMap.keySet()];
        Set<Id> userIdSet = new Set<Id>();
        List<User> newUserList = new List<User>();
        for (String username : usernameToNameMap.keySet()) {
            Boolean isUserExists = false;
            for (User iteratedUser : userList) {
                if (iteratedUser.Username == username) {
                    isUserExists = true;
                    // User Exists
                    if (iteratedUser.IsActive != null && iteratedUser.IsActive == false) {
                        iteratedUser.IsActive = true;
                        userIdSet.add(iteratedUser.Id);
                    }
                }
            }

            if (!isUserExists) {
                Id contactId;
                for (OpportunityContactRole opportunityContactRole : opportunityContactRoleList) {
                    if (opportunityContactRole.Contact.Email == username) {
                        contactId = opportunityContactRole.Contact.Id;
                        break;
                    }
                }
                User user = new User();
                user.Username = username;
                user.FirstName = usernameToNameMap.get(username);
                user.LastName = usernameToNameMap.get(username);
                user.Alias = usernameToNameMap.get(username).substring(0, 5);
                user.Email = username;
                user.TimeZoneSidKey = 'America/New_York';
                user.LocaleSidKey = 'en_US';
                user.EmailEncodingKey = 'ISO-8859-1';
                user.ProfileId = customerCommunityLoginUserProfile.Id;
                user.LanguageLocaleKey = 'en_US';
                user.IsActive = true;
                user.ContactId = contactId;

                System.debug(user);
                newUserList.add(user);
            }
        }

        if (userIdSet.size() != 0) {
            updateUserToActive(userIdSet);
        }
        if (newUserList.size() != 0) {
            insert newUserList;
        }

    }

    @future
    static void updateUserToActive(Set<Id> userIdSet) {
        List<User> userList = [Select Id, IsActive from User where Id in :userIdSet];

        for (User user : userList) {
            user.IsActive = true;
        }

        update userList;
    }
      
    //function to check dripCampaign
    public static void contactToDripCampaign(List<Order> orderList, Map<Id,Order> oldOrderList)
    {
        Set<Id> ShippedOrder=new Set<Id>();
        for(Order ord:orderList)
        {
            if(oldOrderList.containsKey(ord.Id)&& oldOrderList.get(ord.Id).Status=='Activated' && ord.Status=='Shipped')
            {
                ShippedOrder.add(ord.OpportunityId);
            }
        } 
       	if (ShippedOrder.size() == 0) return;
        List<OpportunityContactRole> oppoConRole= [Select ContactId, role, OpportunityId from OpportunityContactRole where role='Primary Support' and OpportunityId In :ShippedOrder];
        List<Id> contactId=new List<Id>();
        
        for(OpportunityContactRole oppConRole : oppoConRole)
        {
            contactId.add(oppConRole.ContactId);
        }
        List<Contact> contactList=[Select Id, DripCampaign__c from Contact where Id In : contactId];
        List<Contact> updatedContactList = new List<Contact>();
        for(Contact con : contactList)
        {
            if(con.DripCampaign__c== false)
            {
                con.DripCampaign__c=true;
                updatedContactList.add(con);
            }
        }
        update updatedContactList;
    }
    
}