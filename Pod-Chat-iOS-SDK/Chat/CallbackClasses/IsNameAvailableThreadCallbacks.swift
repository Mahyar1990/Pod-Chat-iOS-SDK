//
//  IsNameAvailableThreadCallbacks.swift
//  FanapPodChatSDK
//
//  Created by MahyarZhiani on 12/25/1398 AP.
//  Copyright © 1398 Mahyar Zhiani. All rights reserved.
//

import Foundation
import SwiftyJSON
import SwiftyBeaver
import FanapPodAsyncSDK


extension Chat {
    
    func responseOfIsNameAvailableThread(withMessage message: ChatMessage) {
        log.verbose("Message of type 'IS_NAME_AVAILABLE' recieved", context: "Chat")
        
        let returnData = CreateReturnData(hasError:         false,
                                          errorMessage:     "",
                                          errorCode:        0,
                                          result:           message.content?.convertToJSON() ?? [:],
                                          resultAsArray:    nil,
                                          resultAsString:   nil,
                                          contentCount:     message.contentCount,
                                          subjectId:        message.subjectId)
        
        if (Chat.map[message.uniqueId] != nil) {
            let callback: CallbackProtocol = Chat.map[message.uniqueId]!
            callback.onResultCallback(uID:      message.uniqueId,
                                      response: returnData,
                                      success:  { (successJSON) in
                self.isNameAvailableThreadCallbackToUser?(successJSON)
            }) { _ in }
            Chat.map.removeValue(forKey: message.uniqueId)
        }
        
    }
    
    public class IsNameAvailableThreadCallbacks: CallbackProtocol {
        func onResultCallback(uID:      String,
                              response: CreateReturnData,
                              success:  @escaping callbackTypeAlias,
                              failure:  @escaping callbackTypeAlias) {
            log.verbose("IsNameAvailableThreadCallback", context: "Chat")
            
            if let content = response.result {
                let isAvailableNameThreadModel = IsAvailableNameModel(messageContent:   content,
                                                                      hasError:         response.hasError,
                                                                      errorMessage:     response.errorMessage,
                                                                      errorCode:        response.errorCode)
                success(isAvailableNameThreadModel)
            }
            
        }
        
    }
    
}
