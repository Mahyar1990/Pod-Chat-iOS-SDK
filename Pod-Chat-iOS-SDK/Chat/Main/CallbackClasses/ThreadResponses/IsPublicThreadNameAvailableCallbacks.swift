//
//  IsPublicThreadNameAvailableCallbacks.swift
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
    
    /// IsPublicThreadNameAvailable Response comes from server
    ///
    /// - Outputs:
    ///    - it doesn't have direct output,
    ///    - but on the situation where the response is valid,
    ///    - it will call the "onResultCallback" callback to isPublicThreadNameAvailable function (by using "joinPublicThreadCallbackToUser")
    func responseOfIsPublicThreadNameAvailable(withMessage message: ChatMessage) {
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
                self.isPublicThreadNameAvailableCallbackToUser?(successJSON)
            }) { _ in }
            Chat.map.removeValue(forKey: message.uniqueId)
        }
        
    }
    
    public class IsPublicThreadNameAvailableCallbacks: CallbackProtocol {
        func onResultCallback(uID:      String,
                              response: CreateReturnData,
                              success:  @escaping callbackTypeAlias,
                              failure:  @escaping callbackTypeAlias) {
            log.verbose("IsNameAvailableThreadCallback", context: "Chat")
            
            if let content = response.result {
                let isAvailableNameThreadModel = IsAvailableNameResponse(messageContent:    content,
                                                                         hasError:          response.hasError,
                                                                         errorMessage:      response.errorMessage,
                                                                         errorCode:         response.errorCode)
                success(isAvailableNameThreadModel)
            }
            
        }
        
    }
    
}
