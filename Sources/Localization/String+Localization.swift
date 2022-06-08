// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 08/06/22.
//  All code (c) 2022 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import Foundation

public extension String {
    
    /// Look up a simple localized version of the string, using the default search strategy.
    
    var localized: String {
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
    
    func localized(with args: [String:Any], tableName: String? = nil, bundle: Bundle? = nil, value: String = "", comment: String = "") -> String {
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
    
    
    /// Return a translated count string, in forms that depend on the exact count, such as: "x items",
    /// "x of y items", "all the items", and so on.
    ///
    /// The exact text is pulled from the translation, using a variation of this string
    /// as the key. Which variation to use depends on the value of the ``count`` and ``selected`` parameters.
    ///
    /// For example, if the value of this string is `foo`, and the count is 0, and the selection is 0 (or not
    /// supplied), we will look up a translation using the key `foo.none`.
    ///
    /// If the count is 1, the key will be `foo.singular`. If the count is > 1, the key will be `foo.plural`.
    ///
    /// Supplying a non-zero ``selected`` parameter modifies this behaviour slightly. If count is non-zero and
    /// equal to ``selected``, the key is instead `foo.all`.
    ///
    /// In addition to these rules for the key, any occurrences of `{count}` and `{selected}` within the translation
    /// are replaced with the supplied parameter values.
    ///
    /// This allows you to generate translations of the form "x of y items", "x items", "all the items", or whatever
    /// other variation makes most sense in the context.
    /// - Parameters:
    ///   - count: The number of items the translated text is referring to.
    ///   - selected: The number of selected items the translated text is referring to.
    /// - Returns: The translated text.
    func localized(count: Int, selected: Int = 0) -> String {
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
