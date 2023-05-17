public class SearchAccountClass {
    
    String findValue;
    List<Account> results;
    public List<Account> lstAccount 
    {  
        get  
        {  
            if(con != null)  
                return (List<Account>)con.getRecords();  
            else  
                return null ;  
        }  
        set;
    }  
    public ApexPages.StandardSetController con{get;set;}
   
    public String getfindValue(){
        return findValue;
    }
    
    public List<Account> getResult(){
        return results ;
    }
    
    public void setfindValue(String input){
        findValue = input;
    }
    
    public PageReference getAccounts(){
        results = (List<Account>)[Find :findValue in ALL FIELDS Returning Account(name , AccountNumber , AnnualRevenue, Phone)][0];
            con = new ApexPages.StandardSetController(results); 
            con.setPageSize(10);
      
        return null;
    }
    public Boolean hasNext  
    {  
        get  
        {  
            return con.getHasNext();  
        }  
        set;  
    }  
    public Boolean hasPrevious  
    {  
        get  
        {  
            return con.getHasPrevious();  
        }  
        set;  
    }  
    public Integer pageNumber  
    {  
        get  
        {  
            return con.getPageNumber();  
        }  
        set;  
    }  
    public void previous()  
    {  
        con.previous();  
    }  
    public void next()  
    {  
        con.next();  
    }  
     public void first()  
    {  
        con.first();  
    }
    public void last()  
    {  
        con.last();  
    }
    
}