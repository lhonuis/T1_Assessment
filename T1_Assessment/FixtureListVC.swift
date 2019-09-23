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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.reloadData()
    }
 
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return roomInfo[roomNumSelected].fixtureNames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FixtureCell") as? FixtureCell else { return UITableViewCell() }
        
        cell.fixtureTitleLbl.text = roomInfo[roomNumSelected].fixtureNames[indexPath.row]
        
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
