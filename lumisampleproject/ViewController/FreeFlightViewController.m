//
//  FlightViewController.m
//  Sample Project
//
//  Created by David Chan on 17/3/2017.
//  Copyright © 2017 WowWee Group Limited. All rights reserved.
//

#import "FreeFlightViewController.h"

@implementation FreeFlightViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    currentStatus = kLumiStatusLanded;
    lastGetStatusTimestamp = CFAbsoluteTimeGetCurrent();
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    timer = [NSTimer scheduledTimerWithTimeInterval:0.05f target:self selector:@selector(cycle) userInfo:nil repeats:YES];
    [self.rightJoystick setDelegate:self];
    [self.rightJoystick setJoystickCenterImage:@"joystick_right_centre.png" frameImage:@"joystick_bg.png"];
    [[LumiFinder sharedInstance] firstConnectedLumi].delegate = self;
    [[[LumiFinder sharedInstance] firstConnectedLumi] lumiSetWallDetectionModeOn:YES];
    [[[LumiFinder sharedInstance] firstConnectedLumi] lumiSetFollowMeActivated:NO];
    [[[LumiFinder sharedInstance] firstConnectedLumi] lumiSetCurrentBeaconMode:kLumiBeaconModeOff];
    [[[LumiFinder sharedInstance] firstConnectedLumi] lumiSetCurrentAltitudeMode:kLumiAltitudeModeOn];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [timer invalidate];
}

#pragma mark - private
- (void)cycle {
    if (CFAbsoluteTimeGetCurrent()-lastGetStatusTimestamp > 0.5f) {
        [[[LumiFinder sharedInstance] firstConnectedLumi] lumiGetStatus];
        lastGetStatusTimestamp = CFAbsoluteTimeGetCurrent();
    }
    
    int pitch  = [[LumiFinder sharedInstance] firstConnectedLumi].stuntY;
    int roll  = [[LumiFinder sharedInstance] firstConnectedLumi].stuntX;
    [[[LumiFinder sharedInstance] firstConnectedLumi] lumiFreeFlightWithThrust:0 yaw:lumiYAW pitch:pitch roll:roll];
    lumiYAW = 0;
    
    [[[LumiFinder sharedInstance] firstConnectedLumi] lumiGoToPosition:0 y:0 z:[[LumiFinder sharedInstance] firstConnectedLumi].stuntZ];
}

#pragma mark - IBAction Methods
- (IBAction)upAction:(id)sender {
    int increment = 5;
    [[LumiFinder sharedInstance] firstConnectedLumi].stuntZ += increment;
    float maxHeight = 130;
    if ([[LumiFinder sharedInstance] firstConnectedLumi].stuntZ > maxHeight) {
        [[LumiFinder sharedInstance] firstConnectedLumi].stuntZ = maxHeight;
    }
}

- (IBAction)downAction:(id)sender {
    int increment = 5;
    [[LumiFinder sharedInstance] firstConnectedLumi].stuntZ -= increment;
    float minHeight = 60;
    if ([[LumiFinder sharedInstance] firstConnectedLumi].stuntZ < minHeight) {
        [[LumiFinder sharedInstance] firstConnectedLumi].stuntZ = minHeight;
    }
}

- (IBAction)leftAction:(id)sender {
    lumiYAW = 2000;
}

- (IBAction)rightAction:(id)sender {
    lumiYAW = -2000;
}

- (IBAction)forceLandAction:(id)sender {
    [[[LumiFinder sharedInstance] firstConnectedLumi] lumiStop];
}

#pragma mark - JoystickDelegate
- (void)joystickUpdate:(JoystickView *)joystick vector:(CGVector)vector {
    [[LumiFinder sharedInstance] firstConnectedLumi].stuntX = (int)(vector.dx * 450);
    [[LumiFinder sharedInstance] firstConnectedLumi].stuntY = (int)(vector.dy * 450);
    
}

- (void)joystickActive: (JoystickView *)joystick {

    [self.joystickBGAnimation setHidden:true];
    [self.joystickBG setHidden:false];
    
    //[joystick_animation invalidate];
    
    self.joystickBG.transform = CGAffineTransformIdentity;
    
    [UIView animateWithDuration:0.3 animations:^{
        self.joystickBG.transform = CGAffineTransformScale(self.joystickBG.transform, joystick.frame.size.width /joystickBGWidth, joystick.frame.size.width /joystickBGWidth);
        
    }];
}

- (void)joystickInactive: (JoystickView *)joystick {
    // self.joystickBG.hidden = true;
    [UIView animateWithDuration:0.3 animations:^{
        self.joystickBG.transform =CGAffineTransformScale(self.joystickBG.transform, joystickBGWidth/joystick.frame.size.width, joystickBGWidth/joystick.frame.size.width);
        
    } completion:^(BOOL finished) {
        self.joystickBG.transform = CGAffineTransformIdentity;
        //[self startJoystickAnimation];
    }];
    
    
}

#pragma mark - IBAction
-(IBAction)takeOffLand:(id)sender {
    lumiYAW = 0;
    if (currentStatus == kLumiStatusLanded) {
        [[[LumiFinder sharedInstance] firstConnectedLumi] lumiSetLEDColor:kLumiWhite];
        [[[LumiFinder sharedInstance] firstConnectedLumi] lumiLandOrTakeOff:kLumiActionTakeOff height:60];
        [[LumiFinder sharedInstance] firstConnectedLumi].lumitakeOffAndRejectCommand = YES;
        
    }else {
        [[[LumiFinder sharedInstance] firstConnectedLumi] lumiLandOrTakeOff:kLumiActionLand height:0];
    }
}

#pragma mark - LumiDelegate
-(void)lumi:(id)lumi didReceiveStatus:(kLumiStatus)lumiStatus {
    currentStatus = lumiStatus;
    if (currentStatus == kLumiStatusLanded) {
        [_takeOffLandBtn setTitle:@"Take Off" forState:UIControlStateNormal];
    }else {
        [_takeOffLandBtn setTitle:@"Land" forState:UIControlStateNormal];
    }
}


-(void)lumiDidNotifyFirstSonar:(id)lumi {
    [[[LumiFinder sharedInstance] firstConnectedLumi] lumiSetLEDColor:kLumiPurple];
    [[LumiFinder sharedInstance] firstConnectedLumi].lumitakeOffAndRejectCommand = NO;
    [[[LumiFinder sharedInstance] firstConnectedLumi] lumiGoToPosition:0 y:0 z:[[LumiFinder sharedInstance] firstConnectedLumi].stuntZ];
}

-(void)lumi:(id)lumi didErrorNotify:(kLumiNotifyError)errorType {
    
    NSString * errorString;
    switch (errorType) {
        case kLumiCrash:
            errorString = @"kLumiCrash";
            break;
        case kLumiStall:
            errorString = @"kLumiStall";
            break;
        case kLumiBeaconTimeout:
            errorString = @"kLumiBeaconTimeout";
            break;
        case kLumiBLETimeout:
            errorString = @"kLumiBLETimeout";
            break;
        case kLumiSonarTimeout:
            errorString = @"kLumiSonarTimeout";
            break;
        case kLumiSonarStep:
            errorString = @"kLumiSonarStep";
            break;
        case kLumiTakeoffOnBadFloor:
            errorString = @"kLumiTakeoffOnBadFloor";
            break;
            
        default:
            errorString = [NSString stringWithFormat:@"%d",errorType];
            break;
    }
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error" message:errorString preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:alertController animated:YES completion:nil];
}

@end
