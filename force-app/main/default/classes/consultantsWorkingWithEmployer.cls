public with sharing class consultantsWorkingWithEmployer {
    public static List<String> employer(Id employerId){
        List<hirinng__c> storeConsName=[select employer__r.Id , consultant__r.name  from hirinng__c  where employer__r.Id=: employerId];
         List<String> nameList= new List<String>();
        for(hirinng__c consName : storeConsName){
            nameList.add(consName.consultant__r.name);
        }
        System.debug(nameList);
        return nameList;
    }

}