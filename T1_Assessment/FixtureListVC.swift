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
        
        return cell
    }
}
