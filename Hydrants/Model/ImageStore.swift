//
//  ImageStore.swift
//  Hydrants
//
//  Created by Guled Ali on 3/26/19.
//  Copyright © 2019 Guled Ali. All rights reserved.
//

import Foundation
import UIKit

class ImageStore {
    
    func setImage(_ image: UIImage, forKey key: String) {
        
        let url = imageURL(forKey: key)
        if let data = image.jpegData(compressionQuality: 0.5) {
            let _ = try? data.write(to: url, options: [.atomic])
        }
    }
    
    func image(forKey key: String) -> UIImage? {
        
        let url = imageURL(forKey: key)
        
        guard let imagaFromDisk = UIImage(contentsOfFile: url.path) else {
           return nil
        }
        return imagaFromDisk
        
    }
    
    func imageURL(forKey key: String) -> URL {
        let documetsDirectories = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documetDirectory = documetsDirectories.first!
        return documetDirectory.appendingPathComponent(key)
    }
    
    
}
