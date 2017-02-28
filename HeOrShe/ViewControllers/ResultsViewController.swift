//
//  ResultsViewController.swift
//  HeOrShe
//
//  Created by Yigal on 2/26/17.
//  Copyright © 2017 Yigal. All rights reserved.
//

import UIKit

class ResultsViewController: UIViewController
{
    @IBOutlet weak var imgHe: UIImageView!
    @IBOutlet weak var imgHer: UIImageView!
    @IBOutlet weak var lblMaleFemale: UILabel!
    @IBOutlet weak var lblProbability: UILabel!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        if GenderData.instance.gender != "unknown"
        {
            let img = GenderData.instance.gender==Constants.female ? imgHer : imgHe
            self.view.bringSubview(toFront: img!)
            
            lblMaleFemale.text = GenderData.instance.gender==Constants.female ? Constants.femaleCap : Constants.maleCap
        }
        else{
            imgHe.isHidden = true
            imgHer.isHidden = true
            lblMaleFemale.text = "UNKNOWN"
        }
        
        prepareLables()
    }
    
    func prepareLables()
    {
        lblMaleFemale.adjustsFontSizeToFitWidth = true
        
        lblProbability.numberOfLines = 5
        lblProbability.adjustsFontSizeToFitWidth = true
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 0

        var strSample: String = "0"
        let numSampleNS = GenderData.instance.samples as NSNumber
        if let samples = formatter.string(from: numSampleNS)
        {
            strSample = samples
        }
        
        let accuracy = GenderData.instance.accuracy
        let duration = GenderData.instance.duration
        let myMutableString = NSMutableAttributedString(
            string: "The probability is \(accuracy)%\n\nSample size is \(strSample)\n\nResponse time was \(duration)",
            attributes: [:])
        
        var location = 19
        myMutableString.addAttribute(
            NSForegroundColorAttributeName,
            value: UIColor.red,
            range: NSRange(
                location:location,
                length:"\(accuracy)".characters.count+1))
        location += "\(accuracy)".characters.count + 1 + 17
        myMutableString.addAttribute(
            NSForegroundColorAttributeName,
            value: UIColor.red,
            range: NSRange(
                location:location,
                length:strSample.characters.count))
        location += strSample.characters.count + 20
        myMutableString.addAttribute(
            NSForegroundColorAttributeName,
            value: UIColor.red,
            range: NSRange(
                location:location,
                length:duration.characters.count))
        
        lblProbability.attributedText = myMutableString
    }
}
