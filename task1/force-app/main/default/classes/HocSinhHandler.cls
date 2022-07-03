public class HocSinhHandler {
    
    public static Boolean isAgeValid(Date birthday,Integer beginAge, Integer endDay){
        Integer days = birthday.daysBetween(Date.Today());
        Integer age = Integer.valueOf(days/365);
        if(age >= beginAge && age <= endDay) return true;
        return false;
    }
}