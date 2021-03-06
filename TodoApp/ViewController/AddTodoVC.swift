//
//  AddTodoVC.swift
//  TodoApp
//
//  Created by Patrick Wong on 10/25/18.
//  Copyright © 2018 Patrick Wong. All rights reserved.
//

import UIKit
import CoreData

class AddTodoVC: UIViewController {
    
    // Mark: - Properties
    
    var managedContext: NSManagedObjectContext!
    var todo: Todo?
    
    // MARK: - Outlets

    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //loads keyboard
            NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow(with:)),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object:nil)

        //uploads the keyboard when the + button is touched
        textView.becomeFirstResponder()
        
        if let todo = todo{
            textView.text = todo.listVar
            textView.text = todo.listVar
            segmentedControl.selectedSegmentIndex = Int(todo.priorityLevel)
        }
    }
    
    // Mark: - Actions
    
    //displays keyboard with an animation
    @objc func keyboardWillShow(with notification: Notification){
        let key = "UIKeyboardFrameEndUserInfoKey"
        guard let keyboardFrame = notification.userInfo?[key] as? NSValue else { return }
        
        //puts a gap between the keyboard and
        let keyboardHeight = keyboardFrame.cgRectValue.height + 15
        
        bottomConstraint.constant = keyboardHeight
        UIView.animate(withDuration: 0.3){
                    self.view.layoutIfNeeded()
        }
    }
    @IBAction func cancel(_ sender: UIButton) {
        dismiss(animated: true)
        textView.resignFirstResponder()
    }
    
    fileprivate func dismissDone() {
        dismiss(animated: true)
        textView.resignFirstResponder()
    }
    
    @IBAction func done(_ sender: UIButton) {
        guard let listVar = textView.text, !listVar.isEmpty else{
            return
        }
        
 
        
        
        if let todo = self.todo{
            todo.listVar = listVar
            todo.priorityLevel = Int16(segmentedControl.selectedSegmentIndex)
        }
        else{
            let todo = Todo(context: managedContext)
            todo.listVar = listVar
            todo.priorityLevel = Int16(segmentedControl.selectedSegmentIndex)
            todo.date = Date()
            
            /*let date = Date()
            let formatter = DateFormatter()
            formatter.dateFormat = "MM.dd.yyyy"
            let result = formatter.string(from: date)
            print(result)
            */
            
            
        }
        
        do{
            try managedContext.save()
            dismissDone()
        }
        catch{
            print("Error saving todo: \(error)")
        }
        
    
        dismiss(animated: true)
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    
}

extension AddTodoVC: UITextViewDelegate{
    func textViewDidChangeSelection(_ textView: UITextView){
        // for when a character is pressed the instant words will be changed to the person's typing or deleting
        // displays the done button when something is pressed
        if doneButton.isHidden{
            textView.text.removeAll()
            textView.textColor = .black
            doneButton.isHidden = false;
            UIView.animate(withDuration: 0.3){
                self.view.layoutIfNeeded()
            }
        }
    }
}
