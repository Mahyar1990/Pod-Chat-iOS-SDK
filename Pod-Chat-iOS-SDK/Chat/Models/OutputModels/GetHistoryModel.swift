//
//  GetHistoryModel.swift
//  Chat
//
//  Created by Mahyar Zhiani on 7/23/1397 AP.
//  Copyright © 1397 Mahyar Zhiani. All rights reserved.
//

import Foundation
import SwiftyJSON


open class GetHistoryModel {
    /*
     ---------------------------------------
     * responseAsJSON:
     *  - hasError      Bool
     *  - errorMessage  String
     *  - errorCode     Int
     *  + result            [JSON]:
     *      - contentCount      Int
     *      - hasNext           Bool
     *      - nextOffset        Int
     *      + history           HistoryAsJSON
     *          - delivered:      Bool?
     *          - editable:       Bool?
     *          - edited:         Bool?
     *          - id:             Int?
     *          - message:        String?
     *          - metadata:       String?
     *          - ownerId:        Int?
     *          - previousId:     Int?
     *          - seen:           Bool?
     *          - threadId:       Int?
     *          - time:           Int?
     *          - uniqueId:       String?
     
     *          + conversation:   Conversation?
     *          + forwardInfo:    ForwardInfo?
     *          + participant:    Participant?
     *          + replyInfo:      ReplyInfo?
     ---------------------------------------
     * responseAsModel:
     *  - hasError      Bool
     *  - errorMessage  String
     *  - errorCode     Int
     *  + history       [Message]
     ---------------------------------------
     */
    
    
    // GetHistory model properties
    public let hasError:           Bool
    public let errorMessage:       String
    public let errorCode:          Int
    
    // result model
    public var contentCount:       Int = 0
    public var hasNext:            Bool = false
    public var nextOffset:         Int = 0
    public var threadId:           Int?
    
    public var history:            [Message] = []
    public var historyJSON:        [JSON] = []
    
    public init(messageContent: [JSON],
                contentCount:   Int,
                count:          Int,
                offset:         Int,
                hasError:       Bool,
                errorMessage:   String,
                errorCode:      Int,
                threadId:       Int?) {
        
        self.hasError           = hasError
        self.errorMessage       = errorMessage
        self.errorCode          = errorCode
        
        if let tId = threadId {
            self.threadId = tId
        }
        
        let messageLength = messageContent.count
        self.contentCount = contentCount
        self.hasNext = false
        let x: Int = count + offset
        if (x < contentCount) && (messageLength > 0) {
            self.hasNext = true
        }
        self.nextOffset = offset + messageLength
        
        for item in messageContent {
            let message = Message(threadId: nil, pushMessageVO: item)
            let messageJSON = message.formatToJSON()
            
            history.append(message)
            historyJSON.append(messageJSON)
        }
    }
    
    public init(messageContent: [Message]?,
                contentCount:   Int,
                count:          Int,
                offset:         Int,
                hasError:       Bool,
                errorMessage:   String,
                errorCode:      Int,
                threadId:       Int?) {
        
        self.hasError           = hasError
        self.errorMessage       = errorMessage
        self.errorCode          = errorCode
        
        if let tId = threadId {
            self.threadId = tId
        }
        
        self.contentCount = contentCount
        self.hasNext = false
        
        if let messages = messageContent {
            
            let messageLength = messages.count
            let x: Int = count + offset
            if (x < contentCount) && (messageLength > 0) {
                self.hasNext = true
            }
            self.nextOffset = offset + messageLength
            
            for item in messages {
                history.append(item)
                
                let messageJSON = item.formatToJSON()
                historyJSON.append(messageJSON)
            }
        }
    }
    
    
    public func returnDataAsJSON() -> JSON {
        let result: JSON = ["contentCount": contentCount,
                            "hasNext":      hasNext,
                            "nextOffset":   nextOffset,
                            "threadId":     threadId ?? NSNull(),
                            "history":      historyJSON]
        
        let finalResult: JSON = ["result":      result,
                                 "hasError":    hasError,
                                 "errorMessage": errorMessage,
                                 "errorCode":   errorCode]
        
        return finalResult
    }
}



