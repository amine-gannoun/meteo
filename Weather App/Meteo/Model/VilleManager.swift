//
//  VilleManager.swift
//  Meteo
//
//  Created by Amine on 24/09/2022.
//

import UIKit
import CoreData

class VilleManager: NSObject {

    // VideoCacheManager is a singleton
    static let shared: VilleManager = {
        return VilleManager.init()
    }()
    
    // MARK: - Initializer
    private override init() {
        super.init()
        
    }
    
    // MARK: - Write Data
    func addVilleToCash(ville : Ville) {
        
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: "VilleEntity", in: context)!
        let villeEntity = NSManagedObject(entity: entity, insertInto: context)
        
        villeEntity.setValue(ville.nom, forKey: "nom")
        villeEntity.setValue(ville.latitude, forKey: "lat")
        villeEntity.setValue(ville.longitude, forKey: "long")
        
        do {
            try context.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
        
    }
    
    func deleteVilleFromCash(atIndex index: Int){
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "VilleEntity")
        
        do {
            let villesFromCash = try managedContext.fetch(fetchRequest)
            
            managedContext.delete(villesFromCash[index])
            
            do {
                try managedContext.save()
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
            }
                        
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    // MARK: - Read Data
    func fetchAllVilles() -> [Ville] {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return []
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "VilleEntity")
        
        do {
            let villesFromCash = try managedContext.fetch(fetchRequest)
            var villes : [Ville] = []
            
            for ville in villesFromCash {
                villes.append(Ville(nom: ville.value(forKey: "nom") as! String,
                                    longitude: ville.value(forKey: "long") as! Double,
                                    latitude: ville.value(forKey: "lat") as! Double))
            }
            
            return villes
            
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
            return []
        }
        
    }
    
}
