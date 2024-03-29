//
//  HomeTableVC.swift
//  T1_Assessment
//
//  Created by Louis Hon on 23/9/2019.
//  Copyright © 2019 Louis Hon. All rights reserved.
//

import UIKit

class HomeTableVC: UITableViewController {

    var data = [RoomDataModel]()
    let userDefaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.tableFooterView = UIView()
        navigationController?.navigationBar.prefersLargeTitles = true
        loadData()
    }
  
    func loadData() {
        if let savedData = userDefaults.string(forKey: "isSwitched") {
            let jsonData = savedData.data(using: .utf8)!
            let decoder = JSONDecoder()
            do {
                let decodedData = try decoder.decode([RoomDataModel].self, from: jsonData)
                data = decodedData
            }
            catch {
                print("Error.")
            }
        } else {
            getRoomData { (rooms) in
                self.data = rooms
                self.tableView.reloadData()
            }
        }
    }

    func getRoomData(completion: @escaping (_ rooms: [RoomDataModel]) -> Void) {
        
        var rooms: [RoomDataModel] = []
        let resourceURL = "https://private-anon-c8ecc4b87c-house4591.apiary-mock.com/rooms"
        guard let url = URL(string: resourceURL) else {
            print("The URL is invalid.")
            return
        }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let jsonData = data else { return }
            let decoder = JSONDecoder()
            do {
                let roomInfo = try decoder.decode(Root.self, from: jsonData)
                print("Room JSON decoded.")
                
                let room1 = RoomDataModel()
                room1.roomName = "bedroom"
                for index in 0...2 {
                    room1.fixtureNames.append(roomInfo.rooms.bedroom.fixtures[index])
                    room1.status.append(false)
                }
                room1.isACIncluded = true
                room1.temperature = 24
                
                let room2 = RoomDataModel()
                room2.roomName = "living-room"
                for index in 0...1 {
                    room2.fixtureNames.append(roomInfo.rooms.livingRoom.fixtures[index])
                    room2.status.append(false)
                }
                
                let room3 = RoomDataModel()
                room3.roomName = "kitchen"
                for index in 0...2 {
                    room3.fixtureNames.append(roomInfo.rooms.kitchen.fixtures[index])
                    room3.status.append(false)
                }
                
                rooms.append(room1)
                rooms.append(room2)
                rooms.append(room3)
                
                DispatchQueue.main.async {
                    completion(rooms)
                }
            } catch let error {
                print("An error occured.", error)
            }
            }.resume()
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = data[indexPath.row].roomName
        
        if cell.textLabel?.text == "bedroom" {
            cell.textLabel?.text = "Bedroom"
        } else if cell.textLabel?.text == "living-room" {
            cell.textLabel?.text = "Living Room"
        } else {
            cell.textLabel?.text = "Kitchen"
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destVC = segue.destination as! FixtureListVC
        destVC.roomNumSelected = tableView.indexPathForSelectedRow!.row
        destVC.roomInfo = data
    }
    
}
