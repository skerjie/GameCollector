//
//  ViewController.swift
//  GameCollector
//
//  Created by Andrei Palonski on 05.11.16.
//  Copyright © 2016 Andrei Palonski. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
  
  var gamesArray : [Game] = []
  
  @IBOutlet weak var tableView: UITableView!

  override func viewDidLoad() {
    super.viewDidLoad()

    tableView.delegate = self // поставляем все сами для таблицы
    tableView.dataSource = self
    
  }
  
  override func viewWillAppear(_ animated: Bool) {
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    do {
    gamesArray = try context.fetch(Game.fetchRequest())
      tableView.reloadData()
      print(gamesArray)
    } catch {
      print(error.localizedDescription)
    }
  }
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return gamesArray.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = UITableViewCell()
    let game = gamesArray[indexPath.row]
    cell.textLabel?.text = game.title
    cell.imageView?.image = UIImage(data: game.image as! Data)
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let game = gamesArray[indexPath.row]
    performSegue(withIdentifier: "gameSegue", sender: game)
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    let dvc = segue.destination as! GameViewController
    dvc.game = sender as? Game
  }
}

