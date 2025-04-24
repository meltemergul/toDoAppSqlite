//
//  Kisiler.swift
//  KisilerUygulamasi
//
//  Created by Kasım on 13.04.2025.
//
class Kisiler {
    var kisi_id:Int?
    var kisi_ad:String?
    var kisi_tel:String?
    
    //Constructor
    //Sınıftan nesne oluşturulduğunda çalışan metodlardır.
    
    init(){
    
    }
    
    init(kisi_id: Int, kisi_ad: String, kisi_tel: String) {
        self.kisi_id = kisi_id//Shadowing
        self.kisi_ad = kisi_ad
        self.kisi_tel = kisi_tel
    }
}
