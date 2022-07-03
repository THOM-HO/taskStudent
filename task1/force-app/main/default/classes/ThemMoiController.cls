/**
* ClassName: ThemMoiController
* ClassDetail: ThemMoiController class
* @created: 2022/06/22 Nguyen Van A
* @modified:
*/
public with sharing class ThemMoiController {
    public List<SelectOption> options {get; set;}// list danh sách lớp
    public Condition cond {get; set;} //đối tượng Cond
    
    
    public ThemMoiController() {
        options = new List<SelectOption>();
        cond= new Condition();  
        initData();
    }
    
    // Khời tạo
    public void initData(){
        try {
            for(Lop__c lop : [SELECT Id, TenLop__c FROM Lop__c LIMIT 10]) {
               options.add(new SelectOption(lop.Id, lop.TenLop__c) )  ;           
            }
            if (options.isEmpty()) {
                //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, System.Label.MSG_ERROR_NORESULT));
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Data not found'));
            }
        } catch (Exception ex) {
            System.debug('error');
        }
        
    }
    
    //Quay về trang trước
    public PageReference back(){         
        PageReference pg = new PageReference('/apex/VF_TimKiem');
        return pg;
    }
    
    //Thêm học sinh vào Database
    public PageReference addHocSinh(){
        HocSinh__c hs= new HocSinh__c();
        hs.Lop__c= cond.lopId;
        hs.TenHocSinh__c= cond.objHsCondition.TenHocSinh__c;
        hs.HoHocSinh__c =  cond.objHsCondition.HoHocSinh__c;
        hs.GioiTinh__c= cond.objHsCondition.GioiTinh__c;
        hs.NgaySinh__c= cond.objHsCondition.NgaySinh__c;
        hs.Diem1__c=cond.objHsCondition.Diem1__c;
        hs.Diem2__c=cond.objHsCondition.Diem2__c;
        hs.Diem3__c=cond.objHsCondition.Diem3__c;
        
     insert hs;
     PageReference pg = new PageReference('/apex/VF_TimKiem');
        return pg;
    }
    class Condition {
        public HocSinh__c objHsCondition {get; set;}
        public String lopId {get; set;}
        
        public Condition () {
            objHsCondition = new HocSinh__c();
        }
        
    } 
}