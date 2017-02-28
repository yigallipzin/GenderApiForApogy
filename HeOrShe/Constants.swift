//
//  Constants.swift
//  HeOrShe
//
//  Created by Yigal on 2/26/17.
//  Copyright © 2017 Yigal. All rights reserved.
//

import UIKit

struct Constants
{
    static let enterName = "Enter any name below\nand be AMAZED by the\nResults"
    static let female = "female"
    static let femaleCap = "FEMALE"
    static let maleCap = "MALE"
}

struct TopConstraintMultipliers
{
    var withKeyboard: CGFloat
    var withoutKeyboard: CGFloat
    
    init(withKB: CGFloat, withoutKB: CGFloat)
    {
        withKeyboard = withKB
        withoutKeyboard = withoutKB
    }
    
    func getValue(keyboardVisible: Bool) -> CGFloat
    {
        return keyboardVisible ? withKeyboard : withoutKeyboard
    }
}
