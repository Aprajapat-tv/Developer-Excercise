public class NoOfWorkingDays {
public static Integer dayCount(Date startDate , Date endDate){
     Integer num = 0;
        DateTime dT = startDate;
        while(dT<=endDate){
            if(dT.format('EEEE') != 'Saturday' && dt.format('EEEE') != 'Sunday'){
                num++;
            }
            dT = dT.addDays(1);
        }
     return num;

}}