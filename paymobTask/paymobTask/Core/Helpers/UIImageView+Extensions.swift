//
//  UIImageView+Extensions.swift
//  paymobTask
//
//  Created by Rawan Ashraf on 27/08/2025.
//

import Foundation
import UIKit
import Kingfisher

extension UIImageView {
    
    /// Set image from URL with cache-first strategy and offline support
    /// - Parameters:
    ///   - urlString: Image URL string
    ///   - placeholder: Optional placeholder image
    func setCachedImage(urlString: String, placeholder: UIImage? = nil) {
        guard let url = URL(string: urlString) else {
            self.image = placeholder
            return
        }
        
        let cache = ImageCache.default
        
        // Try to retrieve from cache first
        cache.retrieveImage(forKey: url.absoluteString) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let value):
                if let cachedImage = value.image {
                    // Image found in cache
                    DispatchQueue.main.async {
                        self.image = cachedImage
                    }
                } else {
                    // Not in cache: download only if online
                    if NetworkMonitor.shared.isConnected {
                        DispatchQueue.main.async {
                            self.kf.setImage(
                                with: url,
                                placeholder: placeholder,
                                options: [.cacheOriginalImage]
                            )
                        }
                    } else {
                        // Offline and not cached: show placeholder
                        DispatchQueue.main.async {
                            self.image = placeholder
                        }
                    }
                }
            case .failure(let error):
                print("Kingfisher cache retrieval error: \(error)")
                DispatchQueue.main.async {
                    self.image = placeholder
                }
            }
        }
    }
}
