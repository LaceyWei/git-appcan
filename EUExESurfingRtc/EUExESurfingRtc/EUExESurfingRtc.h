//
//  EUExESurfingRtc.h
//  AppCanPlugin
//
//  Created by cc on 15/5/13.
//  Copyright (c) 2015年 zywx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EUExBase.h"
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <CoreMotion/CoreMotion.h>
#import "OpenUDID.h"
#import "DAPIPView.h"

#import "sdkobj.h"
#import "tyrtchttpengine.h"
#import "MKNetworkOperation.h"

typedef enum EVENTID
{
    MSG_NEED_VIDEO = 4000,
    MSG_SET_AUDIO_DEVICE = 4001,
    MSG_SET_VIDEO_DEVICE = 4002,
    MSG_HIDE_LOCAL_VIDEO = 4003,
    MSG_ROTATE_REMOTE_VIDEO = 4004,
    MSG_SNAP = 4005,
    MSG_MUTE = 4006,
    MSG_SENDDTMF = 4007,
    MSG_DOHOLD = 4008,
    MSG_UPDATE_CALLDURATION = 4009,
    MSG_HANGUP = 4010,
    MSG_ACCEPT = 4011,
    MSG_REJECT = 4012,
}eventid;

#define CALLINGVIEW_TAG 2000


@interface EUExESurfingRtc : EUExBase<SdkObjCallBackProtocol,AccObjCallBackProtocol,CallObjCallBackProtocol>
{
    SdkObj* mSDKObj;
    AccObj* mAccObj;
    CallObj*  mCallObj;
    
    SDK_ACCTYPE         accType;
    NSString*   terminalType;
    NSString*   remoteTerminalType;
    SDK_ACCTYPE         remoteAccType;
    
    int     mLogIndex;
    
    IOSDisplay *remoteVideoView;
    UIView *localVideoView;
   
    BOOL firstCheckNetwork;
 
    Reachability* hostReach;
    CMMotionManager *mMotionManager;//自动旋转
}
@property(nonatomic,retain)NSString * str;
@property(nonatomic,retain)NSString * callName;

@property(nonatomic,assign)int callTypes;
@property(nonatomic,assign)int accepptType;

@property (strong, nonatomic) DAPIPView * dapiview;

@property(nonatomic,assign)int x;
@property(nonatomic,assign)int y;
@property(nonatomic,assign)int width;
@property(nonatomic,assign)int height;
@property(nonatomic,assign)int x1;
@property(nonatomic,assign)int y1;
@property(nonatomic,assign)int width1;
@property(nonatomic,assign)int height1;

@property(nonatomic,assign)int Resolutions;


@property (nonatomic,copy)NSString *currentTime;

@property(nonatomic,retain)NSString * appkey;
@property(nonatomic,retain)NSString * appid;

-(void)setLog:(NSString*)log;
-(void)onAppEnterBackground;
-(void)onNetworkChanged:(BOOL)netstatus;
-(BOOL)accObjIsRegisted;

@end
