//
//  HydrantStore.swift
//  Hydrants
//
//  Created by Guled Ali on 3/26/19.
//  Copyright © 2019 Guled Ali. All rights reserved.
//

import Foundation
import  UIKit

class HydrantStore{
    
    var hydrantUpdates: [HydrantUpdate] = []
    var imageStore: ImageStore
    
    let hydrantArchiveURl: URL = {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let docmentDicrectory = documentsDirectory.first!
        
        return docmentDicrectory.appendingPathComponent("hydrantds.archive")
    }()
    
    init() {
        imageStore = ImageStore()
        
        do {
            let data = try Data(contentsOf: hydrantArchiveURl)
            let archiveItems = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? [HydrantUpdate]
            
          hydrantUpdates = archiveItems!
            
        } catch {
            print("Error unarchiving: \(error)")
        }
    }
    

    func addHydrantUpdate(hydrant: HydrantUpdate, image: UIImage) {
        hydrantUpdates.append(hydrant)
        imageStore.setImage(image, forKey: hydrant.imageKey)
        
    }
    
    func getImage(forKey: String) -> UIImage? {
        return imageStore.image(forKey: forKey)
    }
    
//Saving changes made
    func archivreChanges() {
        do {
            let data = try NSKeyedArchiver.archivedData(withRootObject: hydrantUpdates, requiringSecureCoding: false)
            try data.write(to: hydrantArchiveURl)
            print("archived items to \(hydrantArchiveURl)")
        } catch {
            print("Error archiving items \(error)")
        }
    }
}
