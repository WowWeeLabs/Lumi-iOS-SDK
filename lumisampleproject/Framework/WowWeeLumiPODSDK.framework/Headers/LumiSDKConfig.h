//
//  LumiSDKConfig.h
//  BluetoothRobotControlLibrary
//
//  Created by David Chan on 28/3/2017.
//  Copyright (c) 2017 WowWee Group Limited. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    MPFLumiScanOptionMask_ShowAllDevices       = 0,
    MPFLumiScanOptionMask_FilterByProductId    = 1 << 0,
    MPFLumiScanOptionMask_FilterByServices     = 1 << 1,
    MPFLumiScanOptionMask_FilterByDeviceName   = 1 << 2,
} LumiFinderScanOptions;

#ifndef LUMI_SCAN_OPTIONS
#define LUMI_SCAN_OPTIONS MPFLumiScanOptionMask_ShowAllDevices | MPFLumiScanOptionMask_FilterByProductId
#endif

@interface LumiSDKConfig : NSObject

@end
