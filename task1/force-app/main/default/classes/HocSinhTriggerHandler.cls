public class HocSinhTriggerHandler {
    
    private static String STR_ERROR_EMPTY = 'Chưa nhập {0}';
    private static String STR_ISVALIDATE = '{0} chưa hợp lệ!';
    private static final Integer beginDay = 6, endDay = 18 ;
    private static String STR_EMPTY_MATH = 'Hãy vào điểm cho môn {0}';
    
    //Before
    public static void onBeforeInsert(List<HocSinh__c> list_trigger_new){
       for(HocSinh__c hs : list_trigger_new ){
            if(hs.NgaySinh__c == null){
                hs.NgaySinh__c.addError(String.format(STR_ERROR_EMPTY, new List<String> {'ngày sinh'}));
            }
            
            if(!HocSinhHandler.isAgeValid(hs.NgaySinh__c, beginDay, endDay ))
                hs.NgaySinh__c.addError(String.format(STR_ISVALIDATE, new List<String> {'Tuổi'}));
          
            if(hs.Diem1__c == null){
                hs.Diem1__c.addError(String.format(STR_EMPTY_MATH, new List<String> {'Hóa'}));
            }
            if(hs.Diem2__c == null){
                hs.Diem2__c.addError(String.format(STR_EMPTY_MATH, new List<String> {'Lý'}));
            }
            if(hs.Diem3__c == null){
                hs.Diem3__c.addError(String.format(STR_EMPTY_MATH, new List<String> {'Toán'}));
            }
        }  
    }
     public static void onBeforeUpdate(List<HocSinh__c> list_trigger_new, Map< Id, HocSinh__c> list_trigger_oldMap ){
        //
    }
     public static void onBeforeDelete(List<HocSinh__c> list_trigger_new, Map< Id, HocSinh__c> list_trigger_oldMap){
        //
    }
    
    // After
    public static void onAfterInsert(List<HocSinh__c> list_trigger_new){
          /*Map< ID, Integer> maphs = new Map<ID, Integer>();     
          for(HocSinh__c hs : list_trigger_new ){
              if(!maphs.containsKey(hs.Lop__c)){
                  maphs.put(hs.Lop__c,1);
              }else{
                  maphs.put(hs.Lop__c,maphs.get(hs.Lop__c)+1 );
              }
          }*/
        Lop__c lc= new Lop__c();
        lc= Database.query('SELECT Id,SiSo__c, HocSinhRot__c, HocSinhDau__c FROM Lop__c WHERE Id = \''+list_trigger_new[0].Lop__c+ '\'');
        lc.SiSo__c +=1;
        Double diemtb= (list_trigger_new[0].Diem1__c + list_trigger_new[0].Diem2__c + list_trigger_new[0].Diem3__c)/3;
        System.debug('diemtb'+diemtb);
        
        if(diemtb >= 5){
           lc.HocSinhDau__c +=1; 
        }else{
           lc.HocSinhRot__c +=1;
        }
        update lc;
    }
    
     public static void onAfterUpdate(List<HocSinh__c> list_trigger_new, List<HocSinh__c> list_trigger_old){
        Lop__c lcnew= new Lop__c();
        lcnew= Database.query('SELECT Id,SiSo__c FROM Lop__c WHERE Id = \''+list_trigger_new[0].Lop__c+ '\'');
        lcnew.SiSo__c +=1;
        Double diemtb= (list_trigger_new[0].Diem1__c + list_trigger_new[0].Diem2__c + list_trigger_new[0].Diem3__c)/3;
        if(diemtb >= 5){
           lcnew.HocSinhDau__c +=1; 
        }else{
           lcnew.HocSinhRot__c +=1;
        }
         
        Lop__c lcold= new Lop__c();
        lcold= Database.query('SELECT Id,SiSo__c FROM Lop__c WHERE Id = \''+list_trigger_old[0].Lop__c+ '\'');
        lcold.SiSo__c -=1;
        Double diemtb1= (list_trigger_old[0].Diem1__c + list_trigger_old[0].Diem2__c + list_trigger_old[0].Diem3__c)/3;
        if(diemtb >= 5){
           lcnew.HocSinhDau__c -=1; 
        }else{
           lcnew.HocSinhRot__c -=1;
        }
         
        update lcnew;
        update lcold;
    }
    
     public static void onAfterDelete(List<HocSinh__c> list_trigger_old){
       UpdateLop(list_trigger_old);
    }
    
    public static void UpdateLop(List<HocSinh__c> listHocSinh){
 //Lọc số học sinh của mỗi lớp bị xóa hs.Lop_c : 2 (lớp abc có 2 học sinh bị xóa)
        Map< ID, Integer> maphs = new Map<ID, Integer>();     
          for(HocSinh__c hs : listHocSinh ){
              if(!maphs.containsKey(hs.Lop__c)){
                  maphs.put(hs.Lop__c,1);
              }
              //else{
               //   maphs.put(hs.Lop__c,maphs.get(hs.Lop__c)+1 );
             // }
          }
         List<Lop__c> lops= new List<Lop__c> ();
         for (String key : maphs.keySet()) {
    		 Lop__c c = Database.query('SELECT Id,SiSo__c, HocSinhRot__c, HocSinhDau__c FROM Lop__c WHERE Id = \''+key+ '\'');
             c.SiSo__c = Database.countQuery('SELECT COUNT() FROM HocSinh__c WHERE Lop__c = \''+key+'\'' );
             c.HocSinhRot__c = Database.countQuery('SELECT COUNT() FROM HocSinh__c WHERE Lop__c = \''+key+'\' AND DiemTB__c < 5 ' );
             c.HocSinhDau__c = Database.countQuery('SELECT COUNT() FROM HocSinh__c WHERE Lop__c = \''+key+'\' AND DiemTB__c >= 5 ' );
             lops.add(c);
		}
         update lops;
 }
}


/*
Lop__c lcold= new Lop__c();
        lcold= Database.query('SELECT Id,SiSo__c FROM Lop__c WHERE Id = \''+list_trigger_old[0].Lop__c+ '\'');
        lcold.SiSo__c -=1;
         Double diemtb= (list_trigger_old[0].Diem1__c + list_trigger_old[0].Diem2__c + list_trigger_old[0].Diem3__c)/3;
        if(diemtb >= 5){
           lcold.HocSinhDau__c -=1; 
        }else{
           lcold.HocSinhRot__c -=1;
        }
         
        update lcold;
*/