//
//  LumiNotifyErrorItem.h
//  WowWeeLumiPODSDK
//
//  Created by David Chan on 28/3/2017.
//  Copyright © 2017 WowWee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LumiCommandValues.h"

@interface LumiNotifyErrorItem : NSObject

@property (nonatomic, assign) double timestamp;
@property (nonatomic, assign) kLumiNotifyError error;

@end
