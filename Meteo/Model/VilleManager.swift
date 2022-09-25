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
        let homeVideo = NSManagedObject(entity: entity, insertInto: context)
        
        homeVideo.setValue(ville.nom, forKey: "nom")
        homeVideo.setValue(ville.latitude, forKey: "lat")
        homeVideo.setValue(ville.longitude, forKey: "long")
        
        do {
            try context.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
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
