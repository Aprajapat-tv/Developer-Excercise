public class Excercise2 {
    public static Map<Id,Set<Id>> EmployerConsultant(){
        List<Hirinng__c> hiringList = [Select Employer__c, Consultant__c from Hirinng__c];
Map<Id, Set<Id>> empMap = new Map<Id, Set<Id>>();

for (Hirinng__c hr : hiringList) {
    if (empMap.containsKey(hr.Employer__c)) {
        empMap.get(hr.Employer__c).add(hr.Consultant__c);
    } else {
        Set<Id> consultantIdSet = new Set<Id>();
        consultantIdSet.add(hr.Consultant__c);
        empMap.put(hr.Employer__c, consultantIdSet);
    }
}
        return empMap;
            }
    
}
