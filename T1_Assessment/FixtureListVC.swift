//
//  FixtureListVC.swift
//  T1_Assessment
//
//  Created by Louis Hon on 23/9/2019.
//  Copyright © 2019 Louis Hon. All rights reserved.
//

import UIKit

class FixtureListVC: UIViewController, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var roomInfo = [RoomDataModel]()
    var roomNumSelected = Int()
    var tempInfoString: String = "Loading..."
    let userDefaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = roomInfo[roomNumSelected].roomName
        self.tableView.reloadData()
        getWeatherData()
    }
    
    func getWeatherData() {
        let resourceURL = "https://www.metaweather.com/api/location/2165352/"
        guard let url = URL(string: resourceURL) else {
            print("The URL is invalid.")
            return
        }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let jsonData = data else { return }
            let decoder = JSONDecoder()
            do {
                let weatherInfo = try decoder.decode(Welcome.self, from: jsonData)
                print("Weather JSON decoded.")
                self.tempInfoString = String(format: "%.1f", weatherInfo.consolidatedWeather[0].theTemp)
                self.checkTemp(temp: weatherInfo.consolidatedWeather[0].theTemp)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            } catch let error {
                print("An error occured.", error)
            }
            }.resume()
    }
    
    func checkTemp(temp: Double) {
        if temp > 25 {
            let url = URL(string: "https://private-anon-c8ecc4b87c-house4591.apiary-mock.com/weather/cold")!
            let request = URLRequest(url: url)
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if let response = response {
                    print(response)
                    if let data = data, let body = String(data: data, encoding: .utf8) {
                        print(body)
                    }
                } else {
                    print(error ?? "Unknown error")
                }
                }.resume()
            
            roomInfo[0].status[2] = true
        } else {
            let url = URL(string: "https://private-anon-c8ecc4b87c-house4591.apiary-mock.com/weather/warm")!
            let request = URLRequest(url: url)
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if let response = response {
                    print(response)
                    if let data = data, let body = String(data: data, encoding: .utf8) {
                        print(body)
                    }
                } else {
                    print(error ?? "Unknown error")
                }
                }.resume()
            
            roomInfo[0].status[2] = false
        }
       
    }
 
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return roomInfo[roomNumSelected].fixtureNames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FixtureCell") as? FixtureCell else { return UITableViewCell() }
        
        cell.fixtureTitleLbl.text = roomInfo[roomNumSelected].fixtureNames[indexPath.row]
        
        if cell.fixtureTitleLbl.text == "AC" {
            cell.temperatureLbl.isHidden = false
            cell.temperatureLbl.text = tempInfoString
        }
        
        if roomInfo[roomNumSelected].status[indexPath.row] {
            cell.fixtureSwitch.isOn = true
        } else {
            cell.fixtureSwitch.isOn = false
        }
        
        cell.fixtureSwitch.tag = indexPath.row
        cell.fixtureSwitch.addTarget(self, action:  #selector(toggle(_:)), for: .valueChanged)
        
        return cell
    }
    
    @objc func toggle(_ sender: UISwitch) {
        
        if sender.isOn {
            toggleFixture(index: sender.tag, status: "on")
            roomInfo[roomNumSelected].status[sender.tag] = true
        } else {
            toggleFixture(index: sender.tag, status: "off")
            roomInfo[roomNumSelected].status[sender.tag] = false
        }
        let encoder = JSONEncoder()
        do {
            let jsonData = try encoder.encode(roomInfo)
            let jsonString = String(data: jsonData, encoding: .utf8)
            userDefaults.set(jsonString, forKey: "isSwitched")
        }
        catch {
            print("Error.")
        }
    }
    
    func toggleFixture(index: Int, status: String) {
        
        let url = URL(string: "https://private-anon-c8ecc4b87c-house4591.apiary-mock.com/\(roomInfo[roomNumSelected].roomName)/\(roomInfo[roomNumSelected].fixtureNames[index])/\(status)")!
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let response = response {
                print(response)
                if let data = data, let body = String(data: data, encoding: .utf8) {
                    print(body)
                }
            } else {
                print(error ?? "Unknown error")
            }
            }.resume()
    }
}
