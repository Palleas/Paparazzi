import Foundation

extension NSMetadataItem {
    func value(for name: String) -> String? {
        guard let value = self.value(forAttribute: name) else { return nil }
        
        return value as? String
    }
    
    func date(for name: String) -> Date? {
        guard let value = self.value(forAttribute: name) else { return nil }
        
        return value as? Date
    }
    
    
    var displayName: String? {
        return value(for: NSMetadataItemDisplayNameKey)
    }
    
    var path: String? {
        return value(for: NSMetadataItemPathKey)
    }
    
    var contentChangedAt: Date? {
        return date(for: NSMetadataItemFSContentChangeDateKey)
    }
}
