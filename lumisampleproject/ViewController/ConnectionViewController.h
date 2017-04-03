//
//  ConnectionViewController.h
//  Sample Project
//
//  Created by David Chan on 3/4/2017.
//  Copyright © 2017 WowWee Group Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import <WowweeLumiPODSDK/WowweeLumiPODSDK.h>
#import "LoadingView.h"

@interface ConnectionViewController : UIViewController <CBCentralManagerDelegate, LumiDelegate> {
    NSMutableArray      *peripheralList;
    BOOL                isConnected;
    LoadingView         *viewLoading;
}

#pragma mark - IBAction
- (IBAction)refreshAction:(id)sender;

#pragma mark - Public Methods
- (void)cleanRobots;
- (void)prepareCBCentralManager;
- (void)startScanning;
- (void)stopScanning;
- (void)changePage;

@property (strong, nonatomic) CBCentralManager              *cm;
@property (atomic, readwrite) IBOutlet UITableView          *tableView;

@end

