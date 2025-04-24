//
//  KisilerRepository.swift
//  KisilerUygulamasi
//
//  Created by Kasım on 20.04.2025.
//

import Foundation
import RxSwift

class KisilerRepository {
    var kisilerListesi = BehaviorSubject<[Kisiler]>(value: [Kisiler]())
    
    let db:FMDatabase?
    
    init(){
        let hedefYol = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        let veritabaniYolu = URL(fileURLWithPath: hedefYol).appendingPathComponent("rehber.sqlite")
        db = FMDatabase(path: veritabaniYolu.path)
    }
    
    func kaydet(kisi_ad:String,kisi_tel:String){
        db?.open()
        
        do{
            try db!.executeUpdate("INSERT INTO kisiler (kisi_ad,kisi_tel) VALUES (?,?)", values: [kisi_ad,kisi_tel])
        }catch{
            print(error.localizedDescription)
        }
        
        db?.close()
    }
    
    func guncelle(kisi_id:Int,kisi_ad:String,kisi_tel:String){
        db?.open()
        
        do{
            try db!.executeUpdate("UPDATE kisiler SET kisi_ad=?,kisi_tel=? WHERE kisi_id=?", values: [kisi_ad,kisi_tel,kisi_id])
        }catch{
            print(error.localizedDescription)
        }
        
        db?.close()
    }
    
    func ara(aramaKelimesi:String){
        db?.open()
        
        do {
            var liste = [Kisiler]()
            
            let result = try db!.executeQuery("SELECT * FROM kisiler WHERE kisi_ad LIKE '%\(aramaKelimesi)%'", values: nil)
            
            while result.next() {
                let kisi_id = Int(result.string(forColumn: "kisi_id"))!
                let kisi_ad = result.string(forColumn: "kisi_ad")!
                let kisi_tel = result.string(forColumn: "kisi_tel")!
                
                let kisi = Kisiler(kisi_id: kisi_id, kisi_ad: kisi_ad, kisi_tel: kisi_tel)
                
                liste.append(kisi)
            }
            
            kisilerListesi.onNext(liste)//Tetikleme
        }catch{
            print(error.localizedDescription)
        }
        
        db?.close()
    }
    
    func sil(kisi_id:Int){
        db?.open()
        
        do{
            try db!.executeUpdate("DELETE FROM kisiler WHERE kisi_id=?", values: [kisi_id])
        }catch{
            print(error.localizedDescription)
        }
        
        db?.close()
    }
    
    func kisileriYukle(){
        db?.open()
        
        do {
            var liste = [Kisiler]()
            
            let result = try db!.executeQuery("SELECT * FROM kisiler", values: nil)
            
            while result.next() {
                let kisi_id = Int(result.string(forColumn: "kisi_id"))!
                let kisi_ad = result.string(forColumn: "kisi_ad")!
                let kisi_tel = result.string(forColumn: "kisi_tel")!
                
                let kisi = Kisiler(kisi_id: kisi_id, kisi_ad: kisi_ad, kisi_tel: kisi_tel)
                
                liste.append(kisi)
            }
            
            kisilerListesi.onNext(liste)//Tetikleme
        }catch{
            print(error.localizedDescription)
        }
        
        db?.close()
    }
    
    
}
