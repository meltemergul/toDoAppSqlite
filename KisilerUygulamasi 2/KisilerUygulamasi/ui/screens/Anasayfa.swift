//
//  ViewController.swift
//  KisilerUygulamasi
//
//  Created by Kasım on 13.04.2025.
//

import UIKit

//Protocol = Interface
//Protocoller sınıflara özellik katar.
//Bir sınıfa birden fazla protocol eklenebilir.
//Önemli : Kalıtımda bir sınıfa sadece bir adet sınıf eklenebilir.

class Anasayfa: UIViewController {
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var kisilerTableView: UITableView!
    var kisilerListesi = [Kisiler]()
    var anasayfaViewModel = AnasayfaViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Yaşam döngüsü metodu
        //Sayfa açıldığında bir kere çalışır.
        print("viewDidLoad() metodu çalıştı.")
        searchBar.delegate = self
        
        kisilerTableView.delegate = self
        kisilerTableView.dataSource = self
        
        _ = anasayfaViewModel.kisilerListesi.subscribe(onNext: { liste in//Dinleme
            self.kisilerListesi = liste
            self.kisilerTableView.reloadData()
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //Sayfa her göründüğünde çalışır.
        //Sayfaya geri dönüldüğünü anlayabiliriz.
        print("viewWillAppear çalıştı.")
        anasayfaViewModel.kisileriYukle()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        //Sayfa her görünmez olduğunda çalışır.
        print("viewDidDisappear çalıştı.")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("Geçiş yapıldı")
        if segue.identifier == "toDetay" {
            print("toDetay çalıştı")
            //Any : bütün sınıfların üstündedir.Java Object
            if let kisi = sender as? Kisiler {//as? downcasting : Super class > Sub class dönüştürmektir.
                print("Veri : \(kisi.kisi_ad!)")
                let gidilecekVC = segue.destination as! KisiDetay
                //as? : downcasting,hata olma ihtimali yüksekse bunu kullanıyoruz.
                //as! : downcasting,hata olma ihtimali düşükse bunu kullanıyoruz.
                gidilecekVC.kisi = kisi
            }
        }
    }
    
    
}

extension Anasayfa : UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        anasayfaViewModel.ara(aramaKelimesi: searchText)
    }
}

extension Anasayfa : UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return kisilerListesi.count
    }//Kaç tane satır oluşturucak
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //Satır sayısına göre tekrarlı çalışacak.
        let hucre = tableView.dequeueReusableCell(withIdentifier: "kisilerHucre") as! KisilerHucre
        //0,1,2
        let kisi = kisilerListesi[indexPath.row]
        
        hucre.labelKisiAd.text = kisi.kisi_ad
        hucre.labelKisiTel.text = kisi.kisi_tel
        
        return hucre
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let kisi = kisilerListesi[indexPath.row]
        performSegue(withIdentifier: "toDetay", sender: kisi)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let silAction = UIContextualAction(style: .destructive, title: "Sil"){
            contextualAction,view,bool in//closure
            
            let kisi = self.kisilerListesi[indexPath.row]
    
            let alert = UIAlertController(title: "Silme İşlemi", message: "\(kisi.kisi_ad!) silinsin mi?", preferredStyle: .alert)
            
            let iptalAction = UIAlertAction(title: "İptal", style: .cancel)
            alert.addAction(iptalAction)
            
            let evetAction = UIAlertAction(title: "Evet",style: .destructive){ action in
                self.anasayfaViewModel.sil(kisi_id: kisi.kisi_id!)
            }
            alert.addAction(evetAction)
            
            self.present(alert, animated: true)
            
        }
        
        return UISwipeActionsConfiguration(actions: [silAction])
    }
}


