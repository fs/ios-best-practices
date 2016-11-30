//
//  Helpers.swift
//  HomeKitExample
//
//  Created by Ellina Kuznecova on 26.11.16.
//  Copyright © 2016 Flatstack. All rights reserved.
//

import Foundation
import HomeKit

public func FSDispatch_after_short (_ delay:Double, block:@escaping ()->()) {
    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: block);
}

let HomeManager = HMHomeManager()
