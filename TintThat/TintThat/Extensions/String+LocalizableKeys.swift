//
//  String+LocalizableKeys.swift
//  TintThat
//
//  Created by Sebastian Cruz on 08/06/21.
//

import UIKit

extension String {
    
    /* Palette model */
    static var myPalette: String { NSLocalizedString("myPalette", comment: "") }
    
    /* Main tab bar */
    static var editor: String { NSLocalizedString("editor", comment: "") }
    static var myPalettes: String { NSLocalizedString("myPalettes", comment: "") }
    static var settings: String { NSLocalizedString("settings", comment: "") }

    /* Editor view controller */
    static var empty: String { NSLocalizedString("empty", comment: "") }

}