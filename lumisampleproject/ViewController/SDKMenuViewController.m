//
//  SDKMenuViewController.m
//  Sample Project
//
//  Created by David Chan on 17/3/2017.
//  Copyright © 2017 WowWee Group Limited. All rights reserved.
//

#import "SDKMenuViewController.h"
#import "FreeFlightViewController.h"

@implementation SDKMenuViewController

static SDKMenuViewController *_sdkMenuViewController = nil;

#pragma mark - Override Methods
- (void)viewDidLoad {
    [super viewDidLoad];
    
    _sdkMenuViewController = self;
    
    [self.labelFirmware setText:[NSString stringWithFormat:@"Version: %@", @""]];
    
    self.arrLEDColor = [NSArray arrayWithObjects:@"Turn Off", @"Red", @"Green", @"Blue", @"Yellow", @"White", @"Purple", @"Orange", @"Cyan", @"Magenta", nil];
    
    
    self.arrSetting = @[@"Get Firmware", @"Get Battery Level", @"Set Wall Detection On/Off", @"Calibrate", @"Reset Calibration"];
    
    self.arrStunt = @[@"Take Off", @"kLumiStuntYawBackAndForth", @"kLumiStuntShortYawLeft", @"kLumiStuntShortYawRight", @"kLumiStuntShortThrustPulse", @"kLumiStuntShortNegThrustPulse", @"kLumiStuntWobbleRoll", @"kLumiStuntWobblePitch", @"kLumiStuntRollPitchL", @"kLumiStuntRollPitchR", @"kLumiStuntPitch", @"kLumiStuntRoll", @"kLumiStuntMoonWalk", @"kLumiStuntSpiralUp", @"kLumiStuntLeftFlip",@"kLumiStuntSwayFrontBack", @"kLumiStuntSwayLeftRight", @"kLumiStuntZigZagUp", @"kLumiStuntZigZagDown", @"kLumiStuntSpiralDown", @"kLumiStuntRightFlip", @"kLumiStuntBackFlip", @"kLumiStuntFrontFlip"];
    
    self.selectionMenuArray = @[@"Change LED color", @"Setting Features", @"Free Flight", @"Stunt (Beacon Mode)"];
    
    [[[LumiFinder sharedInstance] firstConnectedLumi] lumiGetFirmwareVersion];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.menuTable reloadData];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [self.navigationItem setHidesBackButton:YES animated:NO];
    [[[LumiFinder sharedInstance] firstConnectedLumi] setDelegate:self];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (timer == nil)
        timer = [NSTimer scheduledTimerWithTimeInterval:0.5f target:self selector:@selector(cycleProcessAction) userInfo:nil repeats:YES];
    
    stuntController = nil;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (!keepGetStatusRunning) {
        [timer invalidate];
        timer = nil;
    }
}

- (void)cycleProcessAction {
    [[[LumiFinder sharedInstance] firstConnectedLumi] lumiGetStatus];
}

#pragma mark - ItemsSelectionTableViewCallback
- (void)viewController:(ItemsSelectionTableViewController *)controller didSelectRow:(int)selection Mode:(int)_mode {
    if ([[LumiFinder sharedInstance] firstConnectedLumi] != nil) {
        Lumi *robot = [[LumiFinder sharedInstance] firstConnectedLumi];
        robot.delegate = self;
        switch (_mode) {
            case ItemsSelectionTableViewControllerMode_LED:
                switch (selection) {
                    case kLumiOff:
                        [robot lumiSetLEDColor:kLumiOff];
                        break;
                    case kLumiRed:
                        [robot lumiSetLEDColor:kLumiRed];
                        break;
                    case kLumiGreen:
                        [robot lumiSetLEDColor:kLumiGreen];
                        break;
                    case kLumiBlue:
                        [robot lumiSetLEDColor:kLumiBlue];
                        break;
                    case kLumiYellow:
                        [robot lumiSetLEDColor:kLumiYellow];
                        break;
                    case kLumiWhite:
                        [robot lumiSetLEDColor:kLumiWhite];
                        break;
                    case kLumiPurple:
                        [robot lumiSetLEDColor:kLumiPurple];
                        break;
                    case kLumiOrange:
                        [robot lumiSetLEDColor:kLumiOrange];
                        break;
                    case kLumiCyan:
                        [robot lumiSetLEDColor:kLumiCyan];
                        break;
                    case kLumiMagenta:
                        [robot lumiSetLEDColor:kLumiMagenta];
                        break;
                    default:
                        break;
                }
                break;
            case ItemsSelectionTableViewControllerMode_Setting:
                switch (selection) {
                    case 0:
                        [robot lumiGetFirmwareVersion];
                        break;
                    case 1:
                        [robot lumiGetBattery];
                        break;
                    case 2:{
                        NSString *titleString = @"";
                        if (selection == 2)
                            titleString = @"Wall Detection";
                        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:titleString message:@"" preferredStyle:UIAlertControllerStyleAlert];
                        [alertController addAction:[UIAlertAction actionWithTitle:@"Disable" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                            if (selection == 1) {
                                [robot lumiSetWallDetectionModeOn:NO];
                                [robot lumiGetWallDetectionMode];
                            }
                        }]];
                        [alertController addAction:[UIAlertAction actionWithTitle:@"Enable" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                            if (selection == 1) {
                                [robot lumiSetWallDetectionModeOn:YES];
                                [robot lumiGetWallDetectionMode];
                            }
                        }]];
                        [self presentViewController:alertController animated:YES completion:nil];
                    }
                        break;
                    case 3:
                        [robot lumiCalibrate];
                        break;
                    case 4:
                        [robot lumiResetIRCalibration];
                        break;
                    default:
                        break;
                }
                break;
            case ItemsSelectionTableViewControllerMode_StuntSelection:
                switch (selection) {
                    case 0:
                        if (currentStatus == kLumiStatusLanded) {
                            [robot lumiLandOrTakeOff:kLumiActionTakeOff height:120];
                            robot.lumitakeOffAndRejectCommand = YES;
                        }
                        else
                            [robot lumiLandOrTakeOff:kLumiActionLand height:0];
                        break;
                    default:
                        switch (selection-1) {
                            case kLumiStuntYawBackAndForth:
                            case kLumiStuntShortYawLeft:
                            case kLumiStuntShortYawRight:
                                [robot lumiPerformStunt:(kLumiStuntByte)(selection-1) data1:0 data2:0];
                                break;
                            case kLumiStuntShortThrustPulse: {
                                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"kLumiStuntShortThrustPulse" message:@"" preferredStyle:UIAlertControllerStyleAlert];
                                
                                [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
                                    textField.placeholder = @"Intensity: (0-255)";
                                    textField.keyboardType = UIKeyboardTypeNumberPad;
                                }];
                                [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
                                    textField.placeholder = @"Duration: 10ms (0-255)";
                                    textField.keyboardType = UIKeyboardTypeNumberPad;
                                }];
                                
                                [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                                }]];
                                [alertController addAction:[UIAlertAction actionWithTitle:@"Fill Default Value" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                                    [robot lumiPerformStunt:selection-1 data1:50 data2:50];
                                }]];
                                [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                                    NSString *intensityString = ((UITextField *)[alertController.textFields objectAtIndex:0]).text;
                                    NSString *durationString = ((UITextField *)[alertController.textFields objectAtIndex:1]).text;
                                    if (![intensityString isEqualToString:@""] && ![durationString isEqualToString:@""]) {
                                        if ([[NSCharacterSet decimalDigitCharacterSet] characterIsMember:[intensityString characterAtIndex:0]] &&
                                            [[NSCharacterSet decimalDigitCharacterSet] characterIsMember:[durationString characterAtIndex:0]]) {
                                            [robot lumiPerformStunt:selection-1 data1:[intensityString intValue] data2:[durationString intValue]];
                                        }
                                    }
                                    
                                }]];
                                [self presentViewController:alertController animated:YES completion:nil];
                            }
                                break;
                            case kLumiStuntShortNegThrustPulse: {
                                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"kLumiStuntShortThrustPulse" message:@"" preferredStyle:UIAlertControllerStyleAlert];
                                
                                [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
                                    textField.placeholder = @"Duration: 10ms (0-255)";
                                    textField.keyboardType = UIKeyboardTypeNumberPad;
                                }];
                                
                                [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                                }]];
                                [alertController addAction:[UIAlertAction actionWithTitle:@"Fill Default Value" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                                    [robot lumiPerformStunt:selection-1 data1:0 data2:50];
                                }]];
                                [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                                    NSString *durationString = ((UITextField *)[alertController.textFields objectAtIndex:0]).text;
                                    if (![durationString isEqualToString:@""] && ![durationString isEqualToString:@""]) {
                                        if ([[NSCharacterSet decimalDigitCharacterSet] characterIsMember:[durationString characterAtIndex:0]]) {
                                            [robot lumiPerformStunt:selection-1 data1:0 data2:[durationString intValue]];
                                        }
                                    }
                                    
                                }]];
                                [self presentViewController:alertController animated:YES completion:nil];
                            }
                                break;
                            case kLumiStuntRollPitchL:
                            case kLumiStuntRollPitchR:
                            case kLumiStuntPitch:
                            case kLumiStuntRoll: {
                                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"kLumiStuntShortThrustPulse" message:@"" preferredStyle:UIAlertControllerStyleAlert];
                                
                                [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
                                    textField.placeholder = @"Degree: (-180-180)";
                                    textField.keyboardType = UIKeyboardTypeNumberPad;
                                }];
                                [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
                                    textField.placeholder = @"Duration: 10ms (0-255)";
                                    textField.keyboardType = UIKeyboardTypeNumberPad;
                                }];
                                
                                [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                                }]];
                                [alertController addAction:[UIAlertAction actionWithTitle:@"Fill Default Value" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                                    [robot lumiPerformStunt:selection-1 data1:50 data2:50];
                                }]];
                                [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                                    NSString *intensityString = ((UITextField *)[alertController.textFields objectAtIndex:0]).text;
                                    NSString *durationString = ((UITextField *)[alertController.textFields objectAtIndex:1]).text;
                                    if (![intensityString isEqualToString:@""] && ![durationString isEqualToString:@""]) {
                                        if ([[NSCharacterSet decimalDigitCharacterSet] characterIsMember:[intensityString characterAtIndex:0]] &&
                                            [[NSCharacterSet decimalDigitCharacterSet] characterIsMember:[durationString characterAtIndex:0]]) {
                                            [robot lumiPerformStunt:selection-1 data1:[intensityString intValue] data2:[durationString intValue]];
                                        }
                                    }
                                    
                                }]];
                                [self presentViewController:alertController animated:YES completion:nil];
                            }
                                break;
                            case kLumiStuntWobbleRoll:
                            case kLumiStuntWobblePitch:
                            case kLumiStuntMoonWalk:
                            case kLumiStuntSpiralUp:
                            case kLumiStuntLeftFlip:
                            case kLumiStuntSwayFrontBack:
                            case kLumiStuntSwayLeftRight:
                            case kLumiStuntZigZagUp:
                            case kLumiStuntZigZagDown:
                            case kLumiStuntSpiralDown:
                            case kLumiStuntRightFlip:
                            case kLumiStuntBackFlip:
                            case kLumiStuntFrontFlip:
                                [robot lumiPerformStunt:(kLumiStuntByte)(selection-1) data1:0 data2:0];
                                break;
                            default:
                                break;
                        }
                        break;
                }
                break;
            default:
                break;
        }
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.selectionMenuArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString* identifierString = @"TableViewCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierString];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifierString];
    }
    
    [cell.textLabel setText:[self.selectionMenuArray objectAtIndex:indexPath.row]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    keepGetStatusRunning = NO;
    if (indexPath.row == SDKMenuMode_LED) {
        UIStoryboard* sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        ItemsSelectionTableViewController* controller = [sb instantiateViewControllerWithIdentifier:@"ItemsSelectionTableViewController"];
        controller.arrItems = self.arrLEDColor;
        controller.delegate = self;
        controller.mode = ItemsSelectionTableViewControllerMode_LED;
        [self.navigationController pushViewController:controller animated:YES];
        [self.navigationController setNavigationBarHidden:NO animated:NO];
    }
    else if (indexPath.row == SDKMenuMode_RemoteControl) {
        UIStoryboard* sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        FreeFlightViewController *controller = [sb instantiateViewControllerWithIdentifier:@"FreeFlightViewController"];
        [self.navigationController pushViewController:controller animated:YES];
        [self.navigationController setNavigationBarHidden:NO animated:NO];
    }
    else if (indexPath.row == SDKMenuMode_Setting) {
        UIStoryboard* sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        ItemsSelectionTableViewController* controller = [sb instantiateViewControllerWithIdentifier:@"ItemsSelectionTableViewController"];
        controller.arrItems = self.arrSetting;
        controller.delegate = self;
        controller.mode = ItemsSelectionTableViewControllerMode_Setting;
        [self.navigationController pushViewController:controller animated:YES];
        [self.navigationController setNavigationBarHidden:NO animated:NO];
    }
    else if (indexPath.row == SDKMenuMode_Stunt) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Stunt (Beacon Mode)" message:@"Please turn on LUMI Pod to play this mode." preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            keepGetStatusRunning = YES;
            [[[LumiFinder sharedInstance] firstConnectedLumi] lumiSetLEDColor:kLumiBlue];
            [[[LumiFinder sharedInstance] firstConnectedLumi] lumiSetCurrentBeaconMode:kLumiBeaconModeOn];
            [[[LumiFinder sharedInstance] firstConnectedLumi] lumiSetFollowMeActivated:NO];
            [[[LumiFinder sharedInstance] firstConnectedLumi] lumiSetCurrentAltitudeMode:kLumiAltitudeModeOn];
            UIStoryboard* sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            stuntController = [sb instantiateViewControllerWithIdentifier:@"ItemsSelectionTableViewController"];
            stuntController.arrItems = self.arrStunt;
            stuntController.delegate = self;
            stuntController.mode = ItemsSelectionTableViewControllerMode_StuntSelection;
            [self.navigationController pushViewController:stuntController animated:YES];
            [self.navigationController setNavigationBarHidden:NO animated:NO];
        }]];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}


#pragma mark - LumiDelegate
- (void)lumi:(id)lumi didReceiveFirmwareVersionHigh:(int)versionHigh low:(int)versionLow {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Firmware" message:[NSString stringWithFormat:@"%d.%d", versionHigh, versionLow] preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
    }]];
    [self presentViewController:alertController animated:YES completion:nil];
    [self.labelFirmware setText:[NSString stringWithFormat:@"Version: %@", [NSString stringWithFormat:@"%d.%d", versionHigh, versionLow]]];
}

- (void)lumi:(id)lumi didReceiveWallDetectiobMode:(BOOL)isWallDetectionOn {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Wall Detection" message:[NSString stringWithFormat:@"%@", isWallDetectionOn?@"YES":@"NO"] preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
    }]];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)lumi:(id)lumi didReceiveCrashDetectiobMode:(BOOL)isCrashDetectionOn {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Crash Detection" message:[NSString stringWithFormat:@"%@", isCrashDetectionOn?@"YES":@"NO"] preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
    }]];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)lumi:(id)lumi didReceiveStallDetectiobMode:(BOOL)isStallDetectionOn {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Stall Detection" message:[NSString stringWithFormat:@"%@", isStallDetectionOn?@"YES":@"NO"] preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
    }]];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)lumiDidCalibrated:(id)sender {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Calibration" message:@"Success" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
    }]];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)lumi:(id)lumi didResetIRCalibration:(BOOL)isSuccessReset {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Reset Calibration" message:isSuccessReset?@"Success":@"Fail" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
    }]];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)lumi:(id)lumi didReceiveBatteryLevel:(int)batteryLevel {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Battery Level" message:[NSString stringWithFormat:@"%d", batteryLevel] preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
    }]];
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - LumiDelegate
-(void)lumi:(id)lumi didReceiveStatus:(kLumiStatus)lumiStatus
{
    currentStatus = lumiStatus;
    if (currentStatus == kLumiStatusLanded)
    {
        NSMutableArray *arr = [NSMutableArray arrayWithArray:self.arrStunt];
        [arr replaceObjectAtIndex:0 withObject:@"Take Off"];
        stuntController.arrItems = arr;
        [stuntController.tableView reloadData];
    }else
    {
        NSMutableArray *arr = [NSMutableArray arrayWithArray:self.arrStunt];
        [arr replaceObjectAtIndex:0 withObject:@"Stop"];
        stuntController.arrItems = arr;
        [stuntController.tableView reloadData];
    }
}

-(void)lumiDidNotifyFirstSonar:(id)lumi
{
    [[[LumiFinder sharedInstance] firstConnectedLumi] lumiGoToPosition:0 y:0 z:[[LumiFinder sharedInstance] firstConnectedLumi].stuntZ];
    [[[LumiFinder sharedInstance] firstConnectedLumi] lumiSetLEDColor:kLumiGreen];
    [[LumiFinder sharedInstance] firstConnectedLumi].lumitakeOffAndRejectCommand = NO;
}

@end
