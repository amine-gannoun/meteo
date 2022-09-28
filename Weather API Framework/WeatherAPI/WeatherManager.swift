//
//  WeatherManager.swift
//  WeatherAPI
//
//  Created by Amine on 27/09/2022.
//

import UIKit

public class WeatherManager: NSObject {
    
    // WeatherManager is a singleton
    public static let shared: WeatherManager = {
        return WeatherManager.init()
    }()
    
    // MARK: - Initializer
    private override init() {
        super.init()
    }
    
    public func getMeteoInformations(latitude : Double, longitude : Double, completion : @escaping((Data) -> ())) {
        
        let url : URL = URL(string: "https://api.openweathermap.org/data/2.5/onecall?lat=\(latitude)&lon=\(longitude)&appid=\(WeatherAppID)&lang=fr&units=metric")!
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            
            completion(data!)
            
        }
        
        task.resume()
        
    }
    
}
