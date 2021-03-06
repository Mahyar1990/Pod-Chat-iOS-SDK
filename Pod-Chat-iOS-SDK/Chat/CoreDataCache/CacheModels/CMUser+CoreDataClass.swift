//
//  CMUser+CoreDataClass.swift
//  FanapPodChatSDK
//
//  Created by Mahyar Zhiani on 11/1/1397 AP.
//  Copyright © 1397 Mahyar Zhiani. All rights reserved.
//
//

import Foundation
import CoreData


public class CMUser: NSManagedObject {
    
    public func convertCMUserToUserObject() -> User {
        
        var coreUserId:     Int?
        var id:             Int?
        var lastSeen:       Int?
        var receiveEnable:  Bool?
        var sendEnable:     Bool?
        
        
        func createVariables() {
            if let coreUserId2 = self.coreUserId as? Int {
                coreUserId = coreUserId2
            }
            if let id2 = self.id as? Int {
                id = id2
            }
            if let lastSeen2 = self.lastSeen as? Int {
                lastSeen = lastSeen2
            }
            if let receiveEnable2 = self.receiveEnable as? Bool {
                receiveEnable = receiveEnable2
            }
            if let sendEnable2 = self.sendEnable as? Bool {
                sendEnable = sendEnable2
            }
        }
        
        func createUserModel() -> User {
            let userModel = User(cellphoneNumber: self.cellphoneNumber,
                                 coreUserId:    coreUserId,
                                 email:         self.email,
                                 id:            id,
                                 image:         self.image,
                                 lastSeen:      lastSeen,
                                 name:          self.name,
                                 receiveEnable: receiveEnable,
                                 sendEnable:    sendEnable,
                                 username:      username,
                                 chatProfileVO: Profile(bio: bio, metadata: metadata))
            return userModel
        }
        
        createVariables()
        let model = createUserModel()
        
        return model
    }
    
}
