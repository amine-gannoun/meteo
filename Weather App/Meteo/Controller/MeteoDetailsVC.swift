//
//  MeteoDetailsVC.swift
//  Meteo
//
//  Created by Amine on 26/09/2022.
//

import UIKit
import WeatherAPI

class MeteoDetailsVC: UIViewController {

    var currentVille : Ville = Ville(nom: "", longitude: 1.0, latitude: 1.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = currentVille.nom
        
        WeatherManager.shared.getMeteoInformations(latitude: currentVille.latitude, longitude: currentVille.longitude) { result in
            
            
            let jsonDecoder = JSONDecoder()
            do {
                let owResponse : WeatherResponse = try jsonDecoder.decode(WeatherResponse.self, from: result)
                print("result ws : \(owResponse)")
            } catch {
                print("catch error")
                
            }
            
            
        }
    }
    
}
