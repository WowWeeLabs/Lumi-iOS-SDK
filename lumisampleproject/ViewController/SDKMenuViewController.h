//
//  SDKMenuViewController.h
//  Sample Project
//
//  Created by David Chan on 17/3/2017.
//  Copyright © 2017 WowWee Group Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WowWeeLumiPODSDK/WowWeeLumiPODSDK.h>
#import "ItemsSelectionTableViewController.h"
#import "LoadingView.h"

typedef enum _SDKMenuMode {
    SDKMenuMode_LED = 0,
    SDKMenuMode_Setting = 1,
    SDKMenuMode_RemoteControl = 2,
    SDKMenuMode_Stunt = 3,
}SDKMenuMode;

@interface SDKMenuViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, ItemsSelectionTableViewCallback, LumiDelegate> {
    LoadingView                         *loadingView;
    
    kLumiStatus                         currentStatus;
    ItemsSelectionTableViewController   *stuntController;
    
    NSTimer                             *timer;
    BOOL                                keepGetStatusRunning;
}

#pragma mark - Property
@property (readwrite, atomic) IBOutlet UITableView      *menuTable;
@property (readwrite, atomic) IBOutlet UILabel          *labelFirmware;
@property (nonatomic, readwrite) NSArray                *arrLEDColor;
@property (nonatomic, readwrite) NSArray                *arrStunt;
@property (nonatomic, readwrite) NSArray                *arrSetting;

@property (nonatomic, readwrite) NSArray                *selectionMenuArray;

@end
