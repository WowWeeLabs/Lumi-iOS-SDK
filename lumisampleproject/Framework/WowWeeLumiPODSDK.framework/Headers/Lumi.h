//
//  Lumi.h
//  WowWeeLumiPODSDK
//
//  Created by David Chan on 28/3/2017.
//  Copyright © 2017 WowWee. All rights reserved.
//

#import "BluetoothRobot.h"
#import "LumiCommandValues.h"

@class Lumi;
#pragma mark - LumiDelegate
@protocol LumiDelegate <NSObject>

@optional
- (void)lumiDeviceConnected:(Lumi *)lumi;
- (void)lumiDeviceReady:(Lumi *)lumi;
- (void)lumiDeviceDisconnected:(Lumi *)lumi cleanly:(bool)cleanly;
- (void)lumiDeviceFailedToConnect:(Lumi *)lumi error:(NSError *)error;
- (void)lumiDeviceDidReceivedRawData:(Lumi *)lumi data:(NSData*)data;

/**Lumi device call back **/
- (void)lumi:(id)lumi didReceiveBatteryLevel:(int)batteryLevel;
- (void)lumi:(id)lumi didReceiveStatus:(kLumiStatus)lumiStatus;
- (void)lumiDidCalibrated:(id)sender;
- (void)lumi:(id)lumi didReceiveCurrentBeaconMode:(kLumiBeaconMode)beaconMode;
- (void)lumi:(id)lumi didReceiveCurrentAltitudeMode:(kLumiAltitudeMode)altitudeMode;
- (void)lumi:(id)lumi didReceiveIRSignalStrength:(int)strength;
- (void)lumi:(id)lumi didReceivePositionX:(int)posX Y:(int)posY Z:(int)posZ;
- (void)lumi:(id)lumi didReceiveCurrentEstimatedPositionX:(int)posX Y:(int)posY Z:(int)posZ;
- (void)lumi:(id)lumi didReceiveFirmwareVersionHigh:(int)versionHigh low:(int)versionLow;
- (void)lumi:(id)lumi didReceiveWallDetectiobMode:(BOOL)isWallDetectionOn;
- (void)lumi:(id)lumi didReceiveCrashDetectiobMode:(BOOL)isCrashDetectionOn;
- (void)lumi:(id)lumi didReceiveStallDetectiobMode:(BOOL)isStallDetectionOn;
- (void)lumi:(id)lumi didResetIRCalibration:(BOOL)isSuccessReset;
- (void)lumi:(id)lumi didDetectedWall:(kLumiWallDirection)wallDirection;
- (void)lumi:(id)lumi didErrorNotify:(kLumiNotifyError)errorType;
- (void)lumi:(id)lumi didNotifyModifiedZ:(int)ModifiedZ;
- (void)lumiDidNotifyFirstSonar:(id)lumi;

@end

FOUNDATION_EXPORT NSString *const LUMI_CONNECTED_NOTIFICATION_NAME;
FOUNDATION_EXPORT NSString *const LUMI_DISCONNECTED_NOTIFICATION_NAME;

typedef enum : NSUInteger {
    LumiLogLevelNone = 1,
    LumiLogLevelDebug,
    LumiLogLevelErrors,
} LumiLogLevel;


@interface Lumi : BluetoothRobot

@property (nonatomic, weak) id<LumiDelegate> delegate;
@property (nonatomic, assign) int stuntX;
@property (nonatomic, assign) int stuntY;
@property (nonatomic, assign) int stuntZ;

@property (nonatomic, assign) int currentEstimatedX;
@property (nonatomic, assign) int currentEstimatedY;
@property (nonatomic, assign) int currentEstimatedZ;
@property (nonatomic, assign) double estimatedPositionTimestamp;

@property (nonatomic, strong) NSMutableArray *flightErrorList;      // List of LumiNotifyErrorItem

@property (nonatomic, assign) BOOL lumitakeOffAndRejectCommand;


#pragma mark - REV AIR Commands
- (void)lumiFreeFlightWithThrust:(uint16_t)thrust yaw:(int16_t)yaw pitch:(int16_t)pitch roll:(int16_t)roll;
- (void)lumiSpinByTime:(kLumiSpeed)speed time:(int)milliseconds direction:(kLumiDirection)direction height:(uint8_t)height;
- (void)lumiSpinBySpeed:(uint8_t)speed direction:(kLumiDirection)direction; // speed = 0x00 - 0x0a
- (void)lumiStop;
- (void)lumiLandOrTakeOff:(kLumiLandOrTakeOffAction)action height:(uint8_t)height;
- (void)lumiPerformStunt:(kLumiStuntByte)stunt data1:(uint8_t)data1 data2:(uint8_t)data2;
- (void)lumiGoToPosition:(int)xInCM y:(int)yInCM z:(uint8_t)zInCM;
- (void)lumiGoToPosition:(int)xInCM y:(int)yInCM z:(uint8_t)zInCM duration:(float)duration;
- (void)lumiSetFollowMeActivated:(BOOL)followMe;
- (void)lumiCalibrate;
- (void)lumiGetBattery;
- (void)lumiSetLEDColor:(kLumiLEDColor)color;
- (void)lumiGetStatus;
- (void)lumiGetCurrentBeaconMode;
- (void)lumiSetCurrentBeaconMode:(kLumiBeaconMode)beaconMode;
- (void)lumiGetCurrentAltitudeMode;
- (void)lumiSetCurrentAltitudeMode:(kLumiAltitudeMode)altitudeMode;
- (void)lumiGetIRSignalStrength;
- (void)lumiGetPosition;
- (void)lumiGetCurrentEstimatedPosition;
- (void)lumiGetFirmwareVersion;
- (void)lumiSetWallDetectionModeOn:(BOOL)wallDetectionOn;
- (void)lumiGetWallDetectionMode;
- (void)lumiResetIRCalibration;

@end
