// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 14/02/2019.
//  All code (c) 2019 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import Foundation

/// Singleton which supports registering bundles to search for localizations.
public class Localization {
    static var bundlesToSearch: [Bundle] = [Bundle.main]
    
    /// Register a bundle to be searched when looking for localizations.
    /// This allows for client packages and frameworks to contain their own localization files,
    /// and to add themselves to the search list dynamically.
    public class func registerLocalizationBundle(_ bundle: Bundle) {
        bundlesToSearch.append(bundle)
    }
}
