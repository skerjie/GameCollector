//
//  GameViewController.swift
//  GameCollector
//
//  Created by Andrei Palonski on 05.11.16.
//  Copyright © 2016 Andrei Palonski. All rights reserved.
//

import UIKit
import CoreData

class GameViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
  
  @IBOutlet weak var deleteButton : UIButton!
  @IBOutlet weak var imageView: UIImageView!
  @IBOutlet weak var textField: UITextField!
  @IBOutlet weak var addUpdateButton: UIButton!
  var imagePicker = UIImagePickerController()
  var game : Game? = nil // если запись существует, то !=nil, если не существует то nil. Т.е. если nil, то жмем + и создаем запись, если запись есть, то она не nil мы тапаем по ней и редактируем
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    imagePicker.delegate = self // подписались на поставку данных
    textField.delegate = self // чтобы использовать методы из протоколов
    
    if game != nil {
      imageView.image = UIImage(data: game!.image as! Data)
      textField.text = game!.title
      addUpdateButton.setTitle("Обновить", for: .normal)
    } else {
    deleteButton.isHidden = true
    }
  }
  
  @IBAction func cameraButtonTapped(_ sender: UIBarButtonItem) {
    
    imagePicker.sourceType = .camera
    present(imagePicker, animated: true, completion: nil)
    
  }
  
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
    let image = info[UIImagePickerControllerOriginalImage] as! UIImage
    imageView.image = image
    imagePicker.dismiss(animated: true, completion: nil)
  }
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder() // кнопкой return  клавиатуры можно ее отпустить
    return true
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    self.view.endEditing(true)  // отпускаем клавиатуру тапом в любое мето
  }
  
  @IBAction func photosBTNTapped(_ sender: UIBarButtonItem) {
    
    imagePicker.sourceType = .photoLibrary
    present(imagePicker, animated: true, completion: nil)
    
  }
  
  
  @IBAction func addButtonTapped(_ sender: UIButton) {
    
    if game != nil {
      game!.title = textField.text
      game!.image = UIImagePNGRepresentation(imageView.image!) as NSData?
    } else {
      // сохраняем данные в CoreData
      let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
      let game = Game(context: context)
      game.title = textField.text
      game.image = UIImagePNGRepresentation(imageView.image!) as NSData?
    }

//    // сохраняем данные в CoreData
//    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
//    let game = Game(context: context)
//    game.title = textField.text
//    game.image = UIImagePNGRepresentation(imageView.image!) as NSData?
    
    (UIApplication.shared.delegate as! AppDelegate).saveContext()
    
    navigationController!.popViewController(animated: true) // возвращаемся на предыдущий экран, при нажатии кнопки Добавить
  }
  
  @IBAction func deleteButtonTapped(_ sender: UIButton) {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    context.delete(game!) // удаляем объект(контекст)
    (UIApplication.shared.delegate as! AppDelegate).saveContext()
    
    navigationController!.popViewController(animated: true) //
  }
}
