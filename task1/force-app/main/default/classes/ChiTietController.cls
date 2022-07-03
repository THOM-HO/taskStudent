/**
* ClassName: ChiTietController
* ClassDetail: ChiTietController class
* @created: 2022/06/22 Hồ Thị Thơm
* @modified:
*/
public with sharing class ChiTietController {
    
    public Condition cond {get; set;}// Đối tượng
    
    public ChiTietController() {
        String param = ApexPages.currentPage().getParameters().get('id'); // get ID của Học sinh
        cond= new Condition(); 
        initData(param);
    }
    
    public void initData(String param){ 
         HocSinh__c hs= new HocSinh__c();
         			      hs=[SELECT  MaHocSinh__c,HoHocSinh__c,TenHocSinh__c,NgaySinh__c,GioiTinh__c, Diem1__c, Diem2__c,Diem3__c
						            FROM HocSinh__C
					            	WHERE Id = :param ];
     cond.objHsCondition.TenHocSinh__c = hs.TenHocSinh__c;
     cond.objHsCondition.HoHocSinh__c =hs.HoHocSinh__c;
     cond.objHsCondition.NgaySinh__c = hs.NgaySinh__c;
     cond.objHsCondition.GioiTinh__c = hs.GioiTinh__c;
     cond.objHsCondition.Diem1__c = hs.Diem1__c;
     cond.objHsCondition.Diem2__c = hs.Diem2__c;
     cond.objHsCondition.Diem3__c = hs.Diem3__c;
     cond.objHsCondition.Id = hs.Id;
    }
	
    //Duy chuyển khi back về
    public PageReference back(){         
        PageReference pg = new PageReference('/apex/VF_TimKiem');
		return pg;
    }
    
    //Duy chuyển sang trang VF_CapNhat
    public PageReference updateHS(){
        PageReference pg = new PageReference('/apex/VF_CapNhat');
        pg.getParameters().put('id',cond.objHsCondition.Id);
        pg.getParameters().put('page','VF_ChiTiet');
		return pg;
    }
    
     //Duy chuyển sang trang VF_TimKiem sau khi xóa HS
     public PageReference deleteHS(){
        delete cond.objHsCondition;
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