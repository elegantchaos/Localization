// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 08/06/22.
//  All code (c) 2022 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import Foundation

extension String {
    
    /**
     Look up a simple localized version of the string, using the default search strategy.
     */
    
    public var localized: String {
        return localized(with: [:])
    }
    
    /**
     Look up a localized version of the string.
     If a bundle is specified, we only search there.
     If no bundle is specified, we search in a set of registered bundles.
     This always includes the main bundle, but can have other bundles added to it, allowing you
     to automatically pick up translations from framework bundles (without having to search through
     every loaded bundle).
     */
    
    public func localized(with args: [String:Any], tableName: String? = nil, bundle: Bundle? = nil, value: String = "", comment: String = "") -> String {
        var string = self
        let bundlesToSearch = bundle == nil ? Localization.bundlesToSearch : [bundle!]
        
        for bundle in bundlesToSearch {
            string = NSLocalizedString(self, tableName: tableName, bundle: bundle, value: value, comment: comment)
            if string != self {
                break
            }
        }
        
        for (key, value) in args {
            string = string.replacingOccurrences(of: "{\(key)}", with: String(describing: value))
        }
        return string
    }
    
    
    /**
     Return a count string. The exact text is pulled from the translation,
     but is generally of the form "x entit(y/ies)", or "no entities".
     
     If a selection count is also supplied, the string is expected to
     instead be "x
     */
    
    public func localized(count: Int, selected: Int = 0) -> String {
        var key = self
        if count > 0 && count == selected {
            key += ".all"
        } else {
            switch count {
                case 0: key += ".none"
                case 1: key += ".singular"
                default: key += ".plural"
            }
        }
        
        return key.localized(with: ["count": count, "selected": selected])
    }
}
