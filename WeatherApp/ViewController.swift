//
//  ViewController.swift
//  WeatherApp
//
//  Created by Sami Beig on 5/6/20.
//  Copyright © 2020 Sami Beig. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

  
  @IBOutlet weak var degree: UILabel!
  @IBOutlet weak var weatherLabel: UILabel!
  @IBOutlet weak var cityLabel: UILabel!
  @IBOutlet var background: UIView!
  @IBOutlet weak var weatherID: UILabel!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
    
    let urlBeginning = "http://api.openweathermap.org/data/2.5/weather?"
    let zipCode = "zip=11375,us&units=imperial"
    let apiKey = API_KEY
    
    let temp = urlBeginning + zipCode + apiKey
    print(temp)
    
    guard let url = URL(string: urlBeginning + zipCode + apiKey) else { return }
    
    let task = URLSession.shared.dataTask(with: url){ (data, response, error) in
      if let data = data, error == nil {
        do{
          guard let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] else{ return}
          guard let weatherDetails = json["weather"] as? [[String: Any]], let weatherMain = json["main"] as? [String: Any] else{ return }
          let temp = Int(weatherMain["temp"] as? Double ?? 0 )
          let description = (weatherDetails.first?["description"] as? String)
          let jsonID = (weatherDetails.first?["id"] as? Int ?? 0)
          DispatchQueue.main.async{
            self.setWeather(weather: weatherDetails.first?["main"] as? String, description: description, temp:temp, ID: jsonID )
          }
        }
        catch{
         print("ERROR")
        }
      }
      
      
    }
    task.resume()
    
  }
  
  func setWeather(weather: String?, description: String?, temp: Int, ID: Int){
    weatherLabel.text = description ?? "..."
    degree.text = "\(temp)°"
    weatherID.text = "Weather ID = \(ID)"
     
  }


}

