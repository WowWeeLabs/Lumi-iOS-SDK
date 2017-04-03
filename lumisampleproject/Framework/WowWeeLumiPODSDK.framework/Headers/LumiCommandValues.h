//
//  LumiCommandValues.h
//  WowWeeLumiPODSDK
//
//  Created by David Chan on 28/3/2017.
//  Copyright © 2017 WowWee. All rights reserved.
//

#import <Foundation/Foundation.h>

// Battery Level Calculations
#define BATTERY_VALUE_TO_VOLTAGE(x)    (x/256.0f*1.2f*3*4.2f) // (x/256.0f*1.2f*3*3.8f)//
#define BATTERY_MAX 3.7f//4.2f
#define BATTERY_MIN 2.5f//3.4f
#define BATTERY_ROUNDTOZERO(voltage)    fabs((fmin(BATTERY_MAX, voltage) - BATTERY_MIN))

typedef enum :int
{
    kLumiOff = 0,
    kLumiRed,
    kLumiGreen,
    kLumiBlue,
    kLumiYellow,
    kLumiWhite,
    kLumiPurple,
    kLumiOrange,
    kLumiCyan,
    kLumiMagenta
}
kLumiLEDColor;

typedef enum : uint8_t {
    kLumiDirectionLeft = 0x00,
    kLumiDirectionRight = 0x01,
} kLumiDirection;

typedef enum : uint8_t {
    kLumiSpeedLevel1 = 0x00,
    kLumiSpeedLevel2,
    kLumiSpeedLevel3,
    kLumiSpeedLevel4
} kLumiSpeed;

typedef enum : uint8_t {
    kLumiActionLand = 0x00,
    kLumiActionTakeOff = 0x01,
} kLumiLandOrTakeOffAction;

typedef enum : uint8_t {
    kLumiStuntYawBackAndForth = 0x00,
    kLumiStuntShortYawLeft = 0x01,
    kLumiStuntShortYawRight = 0x02,
    kLumiStuntShortThrustPulse = 0x03, //intensity,	Length in intervals of 10ms
    kLumiStuntShortNegThrustPulse = 0x04, //NULL	Length in intervals of 10ms
    kLumiStuntWobbleRoll = 0x05,
    kLumiStuntWobblePitch = 0x06,
    kLumiStuntRollPitchL = 0x07, //angle in degrees (signed),	Length in intervals of 10ms
    kLumiStuntRollPitchR = 0x08, //angle in degrees (signed),	Length in intervals of 10ms
    kLumiStuntPitch = 0x09, //angle in degrees (signed),	Length in intervals of 10ms
    kLumiStuntRoll = 0x0a, //angle in degrees (signed),	Length in intervals of 10ms
    kLumiStuntMoonWalk = 0x0b,
    kLumiStuntSpiralUp= 0x0c,
    kLumiStuntLeftFlip = 0x0d,
    kLumiStuntSwayFrontBack = 0x0e,
    kLumiStuntSwayLeftRight = 0x0f,
    kLumiStuntZigZagUp = 0x10,
    kLumiStuntZigZagDown = 0x11,
    kLumiStuntSpiralDown = 0x12,
    kLumiStuntRightFlip = 0x13,
    kLumiStuntBackFlip = 0x14,
    kLumiStuntFrontFlip = 0x15,
} kLumiStuntByte;

typedef enum : uint8_t {
    kLumiStatusLanded = 0x00,
    kLumiStatusFlying = 0x01,
    kLumiStatusCrashed = 0x02,
} kLumiStatus;

typedef enum : uint8_t {
    kLumiBeaconModeOff = 0x00,
    kLumiBeaconModeOn = 0x01,
} kLumiBeaconMode;

typedef enum : uint8_t {
    kLumiAltitudeModeOff = 0x00,
    kLumiAltitudeModeOn = 0x01,
} kLumiAltitudeMode;

typedef enum : uint8_t {
    kLumiBackWall = 0x00,
    kLumiLeftWall = 0x01,
    kLumiFrontWall = 0x02,
    kLumiRightWall = 0x03,
} kLumiWallDirection;

typedef enum : uint8_t {
    kLumiCrash = 0x00,
    kLumiStall = 0x01,
    kLumiBeaconTimeout = 0x02,
    kLumiBLETimeout = 0x03,
    kLumiSonarTimeout = 0x04,
    kLumiSonarStep = 0x05,
    kLumiTakeoffOnBadFloor = 0x06,
} kLumiNotifyError;

@interface LumiCommandValues : NSObject

@end

