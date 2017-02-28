//
//  MainViewController.swift
//  HeOrShe
//
//  Created by Yigal on 2/24/17.
//  Copyright © 2017 Yigal. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, UITextFieldDelegate
{
    let lblWelcomeMult = TopConstraintMultipliers(withKB: 0.144, withoutKB: 0.294)
    let lblEnterNameMult = TopConstraintMultipliers(withKB: 0.573, withoutKB: 0.72)
    let lblNameMult = TopConstraintMultipliers(withKB: 0.98, withoutKB: 1.13)
    let txtNameMult = TopConstraintMultipliers(withKB: 1.03, withoutKB: 1.18)
    let viewDottedMult = TopConstraintMultipliers(withKB: 1.127, withoutKB: 1.277)

    @IBOutlet weak var dottedView: UIView!
    @IBOutlet weak var btnSubmit: UIButton!
    @IBOutlet weak var lblWelcome: UILabel!
    @IBOutlet weak var lblEnterName: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var txtEnterName: UITextField!
    
    @IBOutlet weak var viewDottedTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var lblWelcomeTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var txtEnterNameTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var lblNameTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var lblEnterNameTopConstraint: NSLayoutConstraint!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        
        dottedView.addDashedLine(color: UIColor.gray)
        prepareControls()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK Methods
    
    func prepareControls()
    {
        lblEnterName.numberOfLines = 3
        lblEnterName.text = Constants.enterName
        lblEnterName.adjustsFontSizeToFitWidth = true
        
        lblWelcome.numberOfLines = 2
        lblWelcome.adjustsFontSizeToFitWidth = true
        let myMutableString = NSMutableAttributedString(
            string: "Welcome to\nHe or She",
            attributes: [:])
        
        myMutableString.addAttribute(
            NSForegroundColorAttributeName,
            value: UIColor.red,
            range: NSRange(
                location:10,
                length:10))
        lblWelcome.attributedText = myMutableString
        
        lblName.adjustsFontSizeToFitWidth = true
        
        txtEnterName.delegate = self
        txtEnterName.text?.removeAll()
    }
    
    func updateControlsVerticalPos(isKeyboardVisible withKeyboard: Bool)
    {
        UIView.animate(withDuration: 0.2, animations: { _ in
            // change your constraints here
            self.lblWelcomeTopConstraint = self.updateConstraintMultiplier(constraint: self.lblWelcomeTopConstraint, multiplier: self.lblWelcomeMult, withKeyboard: withKeyboard)
            self.lblEnterNameTopConstraint = self.updateConstraintMultiplier(constraint: self.lblEnterNameTopConstraint, multiplier: self.lblEnterNameMult, withKeyboard: withKeyboard)
            self.lblNameTopConstraint = self.updateConstraintMultiplier(constraint: self.lblNameTopConstraint, multiplier: self.lblNameMult, withKeyboard: withKeyboard)
            self.txtEnterNameTopConstraint = self.updateConstraintMultiplier(constraint: self.txtEnterNameTopConstraint, multiplier: self.txtNameMult, withKeyboard: withKeyboard)
            self.viewDottedTopConstraint = self.updateConstraintMultiplier(constraint: self.viewDottedTopConstraint, multiplier: self.viewDottedMult, withKeyboard: withKeyboard)
            
            self.view.layoutIfNeeded()
        }, completion: nil)
        
        
    }
    
    func updateConstraintMultiplier(constraint: NSLayoutConstraint, multiplier: TopConstraintMultipliers, withKeyboard: Bool) ->NSLayoutConstraint
    {
        let newConstraint = constraint.constraintWithMultiplier(multiplier: multiplier.getValue(keyboardVisible: withKeyboard))
        NSLayoutConstraint.deactivate([constraint])
        NSLayoutConstraint.activate([newConstraint])
        return newConstraint
    }
    
    func getResultsForName(apiName: String?)
    {
        guard let name = apiName, !name.isEmpty else
        {
            return
        }
        GenderData.GetGender(name: name, completion: genderResponseCompletion)
    }
    
    func genderResponseCompletion()
    {
        self.performSegue(withIdentifier: "ShowResults", sender: nil)
    }
    
    //MARK Text Delegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        if let text = textField.text, text.isEmpty
        {
            return false
        }
        txtEnterName.resignFirstResponder()
        getResultsForName(apiName: txtEnterName.text)
        
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == txtEnterName
        {
            if let oldStr1 = txtEnterName.text
            {
                let oldStr = oldStr1 as NSString
                let newStr = oldStr.replacingCharacters(in: range, with: string) as NSString
                btnSubmit.isEnabled = newStr.length > 0
            }
            else{
                btnSubmit.isEnabled = false
            }
        }
        return true
    }
    
    // MARK UI Callback Methods
    
    @IBAction func handleTap(recognizer: UITapGestureRecognizer)
    {
         txtEnterName.resignFirstResponder()
    }
    
    @IBAction func onSubmitTouchUp(_ sender: Any)
    {
        getResultsForName(apiName: txtEnterName.text)
    }
    
    @IBAction func txtNameEditingDidBegin(_ sender: Any) {
        updateControlsVerticalPos(isKeyboardVisible: true)
    }
    
    @IBAction func txtNameEditingDidEnd(_ sender: Any) {
        updateControlsVerticalPos(isKeyboardVisible: false)
    }
}
