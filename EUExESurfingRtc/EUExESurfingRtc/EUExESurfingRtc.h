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
#import "OpenUDID.h"
#import "DAPIPView.h"

#import "sdkobj.h"
#import "tyrtchttpengine.h"
#import "MKNetworkOperation.h"
static int cameraIndex = 1;//切换摄像头索引

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
    CGSize  mVideoSize;
    
    SDK_ACCTYPE         accType;
    NSString*   terminalType;
    NSString*   remoteTerminalType;
    SDK_ACCTYPE         remoteAccType;
    
    BOOL isAutoRotationVideo;//是否自动适配本地采集的视频,使发送出去的视频永远是人头朝上
    int     mLogIndex;
    IOSDisplay *videoView;
    UIView *localVideoView;
       
   
     BOOL firstCheckNetwork;
    
    EUExESurfingRtc * EUEx_object;
    
    UIImageView *_frameView;
    UIImageView *_displayView;
    BOOL mMuteState;//NO 未静音;YES 已静音

    
    BOOL mHoldState;//NO 未Hold,YES 已HOLD
    
    IOSDisplay * ivItem;
    UIView* vItem;
 

}
@property(nonatomic,retain)NSString * str;
@property(nonatomic,retain)NSString * callName;

@property(nonatomic,assign)int callTypes;
@property(nonatomic,assign)int accepptType;

@property (strong, nonatomic) DAPIPView * dapiview;
@property (strong, nonatomic) IOSDisplay *remoteVideoView;
@property(nonatomic,assign)BOOL isCallOut;
@property(nonatomic,assign)BOOL isVideo;
@property(nonatomic,assign)BOOL isAutoRotate;
@property (strong, nonatomic) UIView *localVideoView;
@property (nonatomic) UIEdgeInsets borderInsets;
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

//@property(nonatomic,retain)NSString * appkeys;
//@property(nonatomic,retain)NSString * appids;


@property(nonatomic,retain)NSString * appkey;
@property(nonatomic,retain)NSString * appid;







-(void)setLog:(NSString*)log;
-(CGRect)calcBtnRect:(CGPoint)start index:(int)index size:(CGSize)size linSep:(int)lineSep colSep:(int)colSep;
-(BOOL)addGridBtn:(NSString*)title  func:(SEL)func rect:(CGRect)rect;
- (void)onApplicationWillEnterForeground:(UIApplication *)application;
-(void)onAppEnterBackground;
-(void)onNetworkChanged:(BOOL)netstatus;
-(BOOL)accObjIsRegisted;

-(void)onCallOk;
-(void)setCallStatus:(NSString*)log;

@end
