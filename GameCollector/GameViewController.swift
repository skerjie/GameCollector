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
  
  @IBOutlet weak var imageView: UIImageView!
  @IBOutlet weak var textField: UITextField!
  var imagePicker = UIImagePickerController()
  
    override func viewDidLoad() {
        super.viewDidLoad()

        imagePicker.delegate = self // подписались на поставку данных
      textField.delegate = self
    }
  
  @IBAction func cameraButtonTapped(_ sender: UIBarButtonItem) {
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
    
    // сохраняем данные в CoreData
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let game = Game(context: context)
    game.title = textField.text
    game.image = UIImagePNGRepresentation(imageView.image!) as NSData?
    
    (UIApplication.shared.delegate as! AppDelegate).saveContext()
    
    navigationController!.popViewController(animated: true) // возвращаемся на предыдущий экран, при нажатии кнопки Добавить
  }
}
