//
//  MeteoDetailsVC.swift
//  Meteo
//
//  Created by Amine on 26/09/2022.
//

import UIKit
import WeatherAPI

class MeteoDetailsVC: UIViewController {

    //MARK: - UI Outlets
    @IBOutlet weak var nomVilleLabel: UILabel!
    @IBOutlet weak var todayDateLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var weatherImage: UIImageView!
    @IBOutlet weak var windIcon: UIImageView!
    @IBOutlet weak var windLabel: UILabel!
    @IBOutlet weak var precipitationIcon: UIImageView!
    @IBOutlet weak var precipitationLabel: UILabel!
    @IBOutlet weak var forecastIcon: UIImageView!
    @IBOutlet weak var forecastLabel: UILabel!
    @IBOutlet weak var dailyMeteoTV: UITableView!
    
    
    //MARK: - Variables
    var currentVille : Ville = Ville(nom: "", longitude: 1.0, latitude: 1.0)
    var dailyMeteo : [Daily] = []
    
    //MARK: - Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpUiOutlets()
    }
    
    func setUpUiOutlets(){
        
        title = "Météo"
        view.backgroundColor = UIColor(displayP3Red: 139.0/255.0, green: 184.0/255.0, blue: 246.0/255.0, alpha: 1)
        nomVilleLabel.text = ""
        todayDateLabel.text = ""
        temperatureLabel.text = ""
        
        windIcon.image = windIcon.image?.withRenderingMode(.alwaysTemplate)
        windIcon.tintColor = UIColor.white
        precipitationIcon.image = precipitationIcon.image?.withRenderingMode(.alwaysTemplate)
        precipitationIcon.tintColor = UIColor.white
        forecastIcon.image = forecastIcon.image?.withRenderingMode(.alwaysTemplate)
        forecastIcon.tintColor = UIColor.white
        
        dailyMeteoTV.register(UINib(nibName: "DailyMeteoCell", bundle: nil), forCellReuseIdentifier: "DailyMeteoCell")
        dailyMeteoTV.delegate = self
        dailyMeteoTV.dataSource = self
        
        WeatherManager.shared.getMeteoInformations(latitude: currentVille.latitude, longitude: currentVille.longitude) { result in
            
            
            let jsonDecoder = JSONDecoder()
            do {
                let weatherResponse : WeatherResponse = try jsonDecoder.decode(WeatherResponse.self, from: result)
                print("result ws : \(weatherResponse.daily)")
                
                DispatchQueue.main.async {
                    self.nomVilleLabel.text = self.currentVille.nom
                    self.descriptionLabel.text = weatherResponse.current?.weather[0].weatherDescription
                    self.temperatureLabel.text = "\(weatherResponse.current?.temp ?? 0) °C"
                    self.weatherImage.image = UIImage(named: weatherResponse.current?.weather[0].icon ?? "")
                    self.todayDateLabel.text = self.dateFromTimestump(timestump: weatherResponse.current?.dt ?? 1, isDaily: false)
                    self.windLabel.text = "\(weatherResponse.current?.windSpeed ?? 0)Km/h"
                    self.precipitationLabel.text = "\(weatherResponse.current?.dewPoint ?? 0)%"
                    self.forecastLabel.text = "\(weatherResponse.current?.humidity ?? 0)%"
                    
                    self.dailyMeteo = weatherResponse.daily ?? []
                    self.dailyMeteoTV.reloadData()
                    
                }
                
                
            } catch {
                print("catch error")
                let alert = UIAlertController(title: "Erreur", message: "Vérifier que vous êtes connecté à l'internet et réessayer !", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
            
            
        }
        
    }
    
    func dateFromTimestump(timestump : Int, isDaily: Bool) -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(timestump))
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = isDaily ? "dd/MM" : "dd/MM/yyyy"
        let strDate = dateFormatter.string(from: date)
        return strDate
    }
    
}

//MARK: - extension : TV delegate & Data source
extension MeteoDetailsVC : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dailyMeteo.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : DailyMeteoCell = tableView.dequeueReusableCell(withIdentifier: "DailyMeteoCell", for: indexPath) as! DailyMeteoCell
        
        let daily : Daily = dailyMeteo[indexPath.row]
        cell.dateLabel.text = dateFromTimestump(timestump : daily.dt, isDaily: true)
        
        let minTemp : Double = daily.temp.min
        let maxTemp : Double = daily.temp.max
        cell.minMaxLabel.text = "\(minTemp)/\(maxTemp)°C"
        
        cell.weatherImage.image = UIImage(named: daily.weather[0].icon)
        
        cell.selectionStyle = .none
        return cell
    }
    
}
