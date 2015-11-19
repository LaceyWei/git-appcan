//
//  EUExESurfingRtc.m
//  AppCanPlugin
//
//  Created by cc on 15/5/13.
//  Copyright (c) 2015年 zywx. All rights reserved.
//

#import "EUExESurfingRtc.h"
#import "EUtility.h"
#import "JSONKit.h"
#import "JSON.h"
#import "sdkobj.h"
#import "sdkkey.h"
#import "sdkerrorcode.h"
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>
#import <SystemConfiguration/CaptiveNetwork.h>
#import <AVFoundation/AVCaptureSession.h>
#import "DAPIPView.h"

#define APP_USER_AGENT      @"RTC_AppCan"
#define APP_VERSION         @"V2.1.2_B20150508"


@implementation EUExESurfingRtc
@synthesize currentTime;

- (id)initWithBrwView:(EBrowserView *)eInBrwView
{
    self = [super initWithBrwView:eInBrwView];
    if (self) {
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onRecvEvent:) name:@"NOTIFY_EVENT" object:nil];

        accType = ACCTYPE_APP;
        terminalType = TERMINAL_TYPE_PHONE;
        [terminalType retain];
        
        remoteAccType = ACCTYPE_APP;
        remoteTerminalType = TERMINAL_TYPE_ANY;
        [remoteTerminalType retain];
        
        mMotionManager = [[CMMotionManager alloc]init];
        
        initCWDebugLog();
        [self checkNetWorkReachability];//检测网络切换
        
        //注册本地推送
        if ([UIApplication instancesRespondToSelector:@selector(registerUserNotificationSettings:)]&&[[[UIDevice currentDevice]systemVersion]floatValue]>=8.0)
        {
            [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound categories:nil]];
            CWLogDebug(@"registerUserNotificationSettings");
        }
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enterBackgroundNotification:) name:UIApplicationDidEnterBackgroundNotification object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enterForegroundNotification:) name:UIApplicationWillEnterForegroundNotification object:nil];
    }
    return self;
}

-(void)setAppKeyAndAppId:(NSMutableArray *)inArgument{
    
    if ([inArgument isKindOfClass:[NSMutableArray class]] && [inArgument count] == 2){
        NSLog(@"chen----》》》》%@",inArgument);
        
        self.appkey =[inArgument objectAtIndex:0];
        
        NSLog(@"appkey------>>>.%@",self.appkey);
        self.appid = [inArgument objectAtIndex:1];
        
        if ([self.appkey intValue]>0||[self.appid intValue]>0)
        {
            [self jsSuccessWithName:@"uexESurfingRtc.cbSetAppKeyAndAppId" opId:0 dataType:0 strData:@"OK"];

        }else{
            [self jsSuccessWithName:@"uexESurfingRtc.cbSetAppKeyAndAppId" opId:0 dataType:0 strData:@"ERROR:PARM_ERROR"];
        }
    }
}

//登陆接口
-(void)login:(NSMutableArray*)inArgument{
    
    if ([inArgument isKindOfClass:[NSMutableArray class]] && [inArgument count] == 2)
    {
        NSLog(@"login-----appid----->>>%d...appkey____--->>>>%d",[self.appid intValue],[self.appkey intValue]);
        
        if ([self.appkey intValue] !=0||[self.appid intValue]!=0)
        {
            int  number = [[inArgument objectAtIndex:1] intValue];
            NSLog(@"username:---->>>>>%d",number);
            NSString * infoStr = [inArgument objectAtIndex:0];
            
            NSDictionary * dic = [infoStr JSONValue];
            NSLog(@"chen_____>......>>.%@",dic);
            NSDictionary * dict = [dic objectForKey:@"localView"];
            NSDictionary * dictt = [dic objectForKey:@"remoteView"];
            
            self.x = [[dict objectForKey:@"x"] intValue];
            self.y = [[dict objectForKey:@"y"] intValue];
            self.width = [[dict objectForKey:@"width"]intValue];
            self.height = [[dict objectForKey:@"height"]intValue];
            self.x1 = [[dictt objectForKey:@"x1"]intValue];
            self.y1 = [[dictt objectForKey:@"y1"]intValue];
            self.width1 = [[dictt objectForKey:@"width1"]intValue];
            self.height1 = [[dictt objectForKey:@"height1"]intValue];
            self.str = [NSString stringWithFormat:@"%d",number];
            
            if (mSDKObj)
            {
                if ([mSDKObj isInitOk])
                {
                    [self setLog:@"已初始化成功"];
                    return;
                }
            }
            
            signal(SIGPIPE, SIG_IGN);
            mLogIndex = 0;
            mSDKObj = [[SdkObj alloc]init];
            
            NSLog(@"////%@////%@---",self.appid,self.appkey);
            [mSDKObj setSdkAgent:APP_USER_AGENT terminalType:TERMINAL_TYPE_PHONE UDID:[OpenUDID value] appID:self.appid appKey:self.appkey];
            [mSDKObj setDelegate:self];
            [mSDKObj doNavigation:@"cloud2"];
            
        }else{
           [self jsSuccessWithName:@"uexESurfingRtc.cbLogStatus" opId:0 dataType:0 strData:@"ERROR:PARM_ERROR"];
        }
    }
}

- (void)onRegister
{
    if(!mSDKObj)
    {
        [self setLog:@"请先初始化"];
        
         [self jsSuccessWithName:@"uexESurfingRtc.cbLogStatus" opId:0 dataType:0 strData:@"ERROR:UNINIT"];
        return;
    }
    if (!mAccObj)
    {
        [self setLog:@"登录中..."];
        mAccObj = [[AccObj alloc]init];
        [mAccObj bindSdkObj:mSDKObj];
        mAccObj.Delegate = self;
        //此句代码为临时做法，开发者需通过第三方应用平台获取token，无需通过此接口获取
        //获取到返回结果后，请调用doAccRegister接口进行注册，传入参数为服务器返回的结构
        if([self.str isEqualToString:@"0"]){
        
            [self jsSuccessWithName:@"uexESurfingRtc.cbLogStatus" opId:0 dataType:0 strData:@"ERROR:PARM_ERROR"];
            
            return;
        }else{
         [mAccObj getToken:self.str andType:accType andGrant:@"100<200" andAuthType:ACC_AUTH_TO_APPALL];
        }
   
    }
    else if ([mAccObj isRegisted])
    {
        [self setLog:@"登录刷新"];
        [mAccObj doRegisterRefresh];
    }
    else
    {
        [self setLog:@"重新发起登录动作"];
        [mAccObj getToken:self.str andType:accType andGrant:@"100<200" andAuthType:ACC_AUTH_TO_APPALL];
    }
}

//导航结果回调
-(void)onNavigationResp:(int)code error:(NSString*)error
{
    if (0 == code)
    {
        [self setLog:[NSString stringWithFormat:@"初始化成功"]];
        
        [mSDKObj setVideoCodec:[NSNumber numberWithInt:1]];//VP8
        [mSDKObj setAudioCodec:[NSNumber numberWithInt:1]];//iLBC
        [mSDKObj setVideoAttr:[NSNumber numberWithInt:3]];//CIF
        
        [self onRegister];
    }
    else
    {
        [self setLog:[NSString stringWithFormat:@"初始化失败:%d,%@",code,error]];
        [mSDKObj release];
        mSDKObj = nil;
    }
}

-(void)cbLogStatus:(NSString*)senser{
    [self jsSuccessWithName:@"uexESurfingRtc.cbLogStatus" opId:0 dataType:0 strData:senser];
}

//注册结果回调
-(int)onRegisterResponse:(NSDictionary*)result  accObj:(AccObj*)accObj
{
    if([result objectForKey:KEY_CAPABILITYTOKEN])
    {
        NSMutableDictionary *newResult = [NSMutableDictionary dictionaryWithDictionary:result];
        //[newResult setObject:[NSNumber numberWithDouble:2] forKey:KEY_ACC_SRTP];//若与浏览器互通则打开
        [mAccObj doAccRegister:newResult];
        return EC_OK;
    }
    if (nil == result || nil == accObj)
    {
        [self setLog:@"注册请求失败-未知原因"];
        return EC_PARAM_WRONG;
    }
    id obj = [result objectForKey:KEY_REG_EXPIRES];
    if (nil == obj)
    {
        [self setLog:@"注册请求失败-丢失字段KEY_REG_EXPIRES"];
        return EC_PARAM_WRONG;
    }
    int nExpire = [obj intValue];
    
    obj = [result objectForKey:KEY_REG_RSP_CODE];
    if (nil == obj)
    {
        [self setLog:@"注册请求失败-丢失字段KEY_REG_RSP_CODE"];
        return EC_PARAM_WRONG;
    }
    int nRspCode = [obj intValue];
    
    obj = [result objectForKey:KEY_REG_RSP_REASON];
    if (nil == obj)
    {
        [self setLog:@"注册请求失败-丢失字段KEY_REG_RSP_REASON"];
        return EC_PARAM_WRONG;
    }
    NSString* sReason = obj;
    
    if (nRspCode == 200)
    {
        [self setLog:[NSString stringWithFormat:@"登录成功,距下次注册%d秒",nExpire]];
        [self performSelectorOnMainThread:@selector(cbLogStatus:) withObject:@"OK:LOGIN" waitUntilDone:NO];
       
    }
    else
    {
        [self setLog:[NSString stringWithFormat:@"登录失败:%d:%@",nRspCode,sReason]];
        [self performSelectorOnMainThread:@selector(cbLogStatus:) withObject:@"ERROR:PARM_ERROR" waitUntilDone:NO];
        
    }
    
    return EC_OK;
}

-(void)setLog:(NSString*)log
{
    //回调信息；
    NSDateFormatter *dateFormat=[[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"mm:ss"];
    [dateFormat setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    NSLocale *usLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    [dateFormat setLocale:usLocale];
    [usLocale release];
    NSString* datestr = [dateFormat stringFromDate:[NSDate date]];
    [dateFormat release];
    
    NSString* strs = [NSString stringWithFormat:@"%@:%@",datestr,log];
    NSLog(@"++++==>>>%@",strs);
    [self jsSuccessWithName:@"uexESurfingRtc.onGlobalStatus" opId:0 dataType:1 strData:strs];
   // [[NSUserDefaults standardUserDefaults]setObject:str forKey:[NSString stringWithFormat:@"ViewLog%d",mLogIndex]];
    mLogIndex++;
}

//用户在线状态查询结果回调
-(int)onAccStatusQueryResponse:(NSDictionary*)result accObj:(AccObj*)accObj
{
    return EC_OK;
}

-(int)onNotifyMessage:(NSDictionary*)result  accObj:(AccObj*)accObj
{
    return EC_OK;
}

-(int)onGroupResponse:(NSDictionary*)result grpObj:(CallObj*)grpObj
{
    return EC_OK;
}

-(int)onGroupCreate:(NSDictionary*)param withNewCallObj:(CallObj*)newCallObj accObj:(AccObj*)accObj
{
    return EC_OK;
}

//--------------onRecvEvent----监听-----------------------------------------------
-(void)onRecvEvent:(NSNotification *)notification
{
    if (nil == notification)
    {
        return;
    }
    if (nil == [notification userInfo])
    {
        return;
    }
    NSDictionary * data=[notification userInfo];
    NSLog(@"监听者：》》》》》%@",data);
    int msgid = [[data objectForKey:@"msgid"]intValue];
    NSLog(@"%d",msgid);
    
    if (MSG_NEED_VIDEO == msgid)//发起呼叫
    {
        BOOL isCallOut = [[data objectForKey:@"iscallout"]boolValue];
        
        if (mCallObj ==nil && isCallOut )
        {
            mCallObj = [[CallObj alloc]init];
            mCallObj.Delegate = self;
            [mCallObj bindAcc:mAccObj];
            
           // SDK_CALLTYPE callType = (remoteV != 0)? VIDEO_CALL:AUDIO_CALL;
            if (self.callTypes == AUDIO_CALL || self.callTypes == AUDIO_CALL_SENDONLY || self.callTypes == AUDIO_CALL_RECVONLY)
            {
                mCallObj.CallMedia = MEDIA_TYPE_AUDIO;
            }
            else
                mCallObj.CallMedia = MEDIA_TYPE_VIDEO;
            
            NSString* remoteUri = self.callName;
            NSDictionary* dic = [NSDictionary dictionaryWithObjectsAndKeys:
                                 remoteUri,KEY_CALLED,
                                 [NSNumber numberWithInt:self.callTypes],KEY_CALL_TYPE,
                                 [NSNumber numberWithInt:ACCTYPE_APP],KEY_CALL_REMOTE_ACC_TYPE,
                                 remoteTerminalType,KEY_CALL_REMOTE_TERMINAL_TYPE,
                                 @"",KEY_CALL_INFO,
                                 nil];
            NSLog(@"发送信息=======>>>%@",dic);
            //发起呼叫 doMakeCall:
            //[self jsSuccessWithName:@"uexESurfingRtc.cbCallStatus" opId:0 dataType:0 strData:@"OK:CALLING"];
            int ret = [mCallObj doMakeCall:dic];
            if (EC_OK > ret)
            {
                if (mCallObj)
                {
                    [mCallObj doHangupCall];
                    [mCallObj release];
                    mCallObj = nil;
                }
                
                [self setLog:[NSString stringWithFormat:@"创建呼叫失败:%@",[SdkObj ECodeToStr:ret]]];
                [self jsSuccessWithName:@"uexESurfingRtc.cbCallStatus" opId:0 dataType:0 strData:@"ERROR:PARM_ERROR"];

            }
            //切换音频播放设备；doSwitchAudioDevice:
            [mCallObj doSwitchAudioDevice:SDK_AUDIO_OUTPUT_DEFAULT];
        }
        return;
    }
    //接听
    if (MSG_ACCEPT == msgid)//接听
    {
        if (mCallObj.CallMedia == MEDIA_TYPE_AUDIO)
        {
            
            [mCallObj doAcceptCall:[NSNumber numberWithInt:self.accepptType]];
            [self setLog:@"音频已接听"];
            //[mCallObj doSwitchAudioDevice:SDK_AUDIO_OUTPUT_SPEAKER];
        }
        else
        {
            [self setLog:@"视频已接听"];
            [mCallObj doAcceptCall:[NSNumber numberWithInt:self.accepptType]];
        }
        return;
    }
    if (MSG_REJECT == msgid)//拒接
    {
        [self setLog:@"拒接中......"];
       
        if (mCallObj)
        {
            [mCallObj doRejectCall];
            [mCallObj release];
            mCallObj = nil;
        }
        
        [localVideoView removeFromSuperview];
        [remoteVideoView removeFromSuperview];
        
        return;
    }
    if (MSG_HANGUP == msgid)//挂断
    {
        if (mCallObj)
        {
            [mCallObj doHangupCall];
            [mCallObj release];
            mCallObj = nil;
        }
        
        [self setLog:@"呼叫已结束"];
        [localVideoView removeFromSuperview];
        [remoteVideoView removeFromSuperview];
       
        return;
    }
    if (MSG_MUTE == msgid)//静音
    {
        if (!mCallObj)
        {
            [self setLog:@"静音前请先呼叫"];
            return;
        }
        if ([mCallObj MuteStatus] == NO)
        {
            [mCallObj doMuteMic:MUTE_DOMUTE];
            [self setLog:@"静音"];
        }
        else
        {
            [mCallObj doMuteMic:MUTE_DOUNMUTE];
            [self setLog:@"解除静音"];
        }
        return;
    }
    if (MSG_SET_AUDIO_DEVICE == msgid)//切换音频输出设备(扬声器)
    {
        if (!mCallObj)
        {
            [self setLog:@"切换放音设备前请先呼叫"];
            return;
        }
        SDK_AUDIO_OUTPUT_DEVICE ad = [mCallObj getAudioOutputDeviceType];
        if (SDK_AUDIO_OUTPUT_DEFAULT == ad || SDK_AUDIO_OUTPUT_HEADSET == ad)
        {
            [mCallObj doSwitchAudioDevice:SDK_AUDIO_OUTPUT_SPEAKER];
            [self setLog:@"放音设备切换到外放"];
        }
        else
        {
            [mCallObj doSwitchAudioDevice:SDK_AUDIO_OUTPUT_DEFAULT];
            [self setLog: @"放音设备切换到听筒/耳机"];
        }
        return;
    }
}
//>>>>>>>>>>>>>>>>>>>>>>>>>>>>以上为”监听“部分>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
-(void)cbCallStatus:(NSString*)senser{
    [self jsSuccessWithName:@"uexESurfingRtc.cbCallStatus" opId:0 dataType:0 strData:senser];
}

//呼叫事件回调
-(int)onCallBack:(SDK_CALLBACK_TYPE)type code:(int)code callObj:(CallObj*)callObj
{
    [self setLog:[NSString stringWithFormat:@"呼叫事件:%d code:%d",type,code]];
    //不同事件类型见SDK_CALLBACK_TYPE
    if(type == SDK_CALLBACK_RING)
    {
        [self performSelectorOnMainThread:@selector(cbCallStatus:) withObject:@"OK:CALLING" waitUntilDone:NO];
    }
    else if (type == SDK_CALLBACK_ACCEPTED)
    {
        [self performSelectorOnMainThread:@selector(cbCallStatus:) withObject:@"OK:ACCEPTING" waitUntilDone:NO];
        [self setCallIncomingFlag:NO];
    }
    else  if (type == SDK_CALLBACK_CLOSED)
    {
        [self performSelectorOnMainThread:@selector(cbCallStatus:) withObject:@"OK:CLOSING" waitUntilDone:NO];
        [localVideoView removeFromSuperview];
        [remoteVideoView removeFromSuperview];
        if (mCallObj)
        {
            [mCallObj release];
            mCallObj = nil;
        }
        [self setCallIncomingFlag:NO];
    }
    else  if (type == SDK_CALLBACK_FAILED)
    {
        [self performSelectorOnMainThread:@selector(cbCallStatus:) withObject:@"OK:FAILLING" waitUntilDone:NO];
        [localVideoView removeFromSuperview];
        [remoteVideoView removeFromSuperview];
        if (mCallObj)
        {
            [mCallObj release];
            mCallObj = nil;
        }
        [self setCallIncomingFlag:NO];
    }
    
    return 0;
}

#define CALL_INCOMING_FLAG  @"CALL_INCOMING_FLAG"
-(BOOL)isBackground
{
    return [[UIApplication sharedApplication] applicationState] == UIApplicationStateBackground
    ||[[UIApplication sharedApplication] applicationState] == UIApplicationStateInactive;
}

//标志后台来电中的状态
-(void)setCallIncomingFlag:(BOOL)reg
{
    [[NSUserDefaults standardUserDefaults]setObject:[NSNumber numberWithBool:reg] forKey:CALL_INCOMING_FLAG];
}

-(BOOL)getCallIncomingFlag
{
    id obj = [[NSUserDefaults standardUserDefaults]objectForKey:CALL_INCOMING_FLAG];
    if (obj)
    {
        return [obj boolValue];
    }
    return NO;
}

//呼叫媒体建立事件通知
-(int)onCallMediaCreated:(int)mediaType callObj:(CallObj *)callObj
{
    if (mediaType == MEDIA_TYPE_VIDEO)
    {
        int ret = [callObj doSetCallVideoWindow:remoteVideoView localVideoWindow:localVideoView];
        NSLog(@">>>%d",ret);
        [self setLog:[NSString stringWithFormat:@"%d",ret]];
    }
    [self setMotionStatus:YES];
    [self setCallIncomingFlag:NO];
    return 0;
}

//在这里增加来电后台通知或前台弹呼叫接听页面
-(int)onCallIncoming:(NSDictionary*)param withNewCallObj:(CallObj*)newCallObj accObj:(AccObj*)accObj
{
    mCallObj = newCallObj;
    [mCallObj setDelegate:self];
    int callType = [[param objectForKey:KEY_CALL_TYPE]intValue];
    NSLog(@"%d",callType);
    NSString* uri = [param objectForKey:KEY_CALLER];
    
    if ([self isBackground])
    {
        const char* cacc = [uri UTF8String];
        int strindex1=0,strindex2=0;
        int l = (int)strlen(cacc);
        for(int i = 0;i<l;i++)
        {
            if(cacc[i]=='-')
            {
                strindex1=i;
                break;
            }
        }
        for(int i = 0;i<l;i++)
        {
            if(cacc[i]=='~')
            {
                strindex2=i;
                break;
            }
        }
        NSString* accNum = [[NSString stringWithUTF8String:cacc] substringWithRange:NSMakeRange(strindex1+1, strindex2-strindex1-1)];
        
        [self setCallIncomingFlag:YES];
        [[NSUserDefaults standardUserDefaults]setObject:[NSNumber numberWithInt:callType] forKey:KEY_CALL_TYPE];
        [[NSUserDefaults standardUserDefaults]setObject:uri     forKey:KEY_CALLER];
        makeNotification(@"接听",[NSString stringWithFormat:@"来电:%@",accNum],UILocalNotificationDefaultSoundName,YES);
        [self setLog:[NSString stringWithFormat:@"来电:%@",accNum]];
        return 0;
    }
    if (callType==1||callType==5||callType==9)
    {
         //[self jsSuccessWithName:@"uexESurfingRtc.cbCallStatus" opId:0 dataType:0 strData:@"OK:INCOMING"];
        [self performSelectorOnMainThread:@selector(cbCallStatus:) withObject:@"OK:INCOMING" waitUntilDone:NO];
    }
    
    if (callType == 3 || callType == 7 || callType == 11)
    {
        //[self jsSuccessWithName:@"uexESurfingRtc.cbCallStatus" opId:0 dataType:0 strData:@"OK:INCOMING"];
        [self performSelectorOnMainThread:@selector(cbCallStatus:) withObject:@"OK:INCOMING" waitUntilDone:NO];

        DAPIPView* dvItem = [[DAPIPView alloc] init];
        self.dapiview = dvItem;
        
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
        {
            self.dapiview.borderInsets = UIEdgeInsetsMake(1.0f,       // top
                                                          1.0f,       // left
                                                          1.0f,      // bottom
                                                          1.0f);      // right
        }
        else
        {
            self.dapiview.borderInsets = UIEdgeInsetsMake(1.0f,       // top
                                                          1.0f,       // left
                                                          1.0f,       // bottom
                                                          1.0f);      // right
        }
        
        //远端窗口
        remoteVideoView = [[IOSDisplay alloc]initWithFrame:CGRectMake(self.x1,self.y1, self.width, self.height1)];
        remoteVideoView.backgroundColor = [UIColor whiteColor];
        [EUtility brwView:meBrwView  addSubview:remoteVideoView];
        
        //本地窗口;
        localVideoView = [[UIView alloc]initWithFrame:CGRectMake(self.x, self.y, self.width, self.height)];
        NSLog(@"%@",NSStringFromCGRect(localVideoView.frame));
        localVideoView.backgroundColor = [UIColor whiteColor];
        // vItem.center = CGPointMake(self.dapiview.bounds.size.width/2, self.dapiview.bounds.size.height/2);
        [EUtility brwView: meBrwView  addSubview:localVideoView];
        
        [dvItem release];
        
    }
    
    return 0;
}

//>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>以上为登陆>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

//call；
-(void)call:(NSMutableArray *)inArgument
{
    if ([inArgument isKindOfClass:[NSMutableArray class]] && [inArgument count] == 2){
        
        self.callTypes = [[inArgument objectAtIndex:0] intValue];
        int str =  [[inArgument objectAtIndex:1] intValue];
        self.callName = [NSString stringWithFormat:@"%d",str];
       
    if(!mSDKObj)
    {
        [self setLog:@"请先初始化"];
         [self jsSuccessWithName:@"uexESurfingRtc.cbCallStatus" opId:0 dataType:0 strData:@"ERROR:UNREGISTER"];
        
        return;
    }
    
    if (self.callTypes==3||self.callTypes==7||self.callTypes==11)
    {
        DAPIPView* dvItem = [[DAPIPView alloc] init];
        self.dapiview = dvItem;
        
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
        {
            self.dapiview.borderInsets = UIEdgeInsetsMake(1.0f,       // top
                                                          1.0f,       // left
                                                          1.0f,      // bottom
                                                          1.0f);      // right
        }
        else
        {
            self.dapiview.borderInsets = UIEdgeInsetsMake(1.0f,       // top
                                                          1.0f,       // left
                                                          1.0f,       // bottom
                                                          1.0f);      // right
        }
        
        //远端窗口
        remoteVideoView = [[IOSDisplay alloc]initWithFrame:CGRectMake(self.x1,self.y1, self.width1, self.height1)];
        remoteVideoView.backgroundColor = [UIColor whiteColor];
        [EUtility brwView:meBrwView  addSubview:remoteVideoView];
        
        //本地窗口;
        localVideoView = [[UIView alloc]initWithFrame:CGRectMake(self.x, self.y, self.width, self.height)];
        NSLog(@"%@",NSStringFromCGRect(localVideoView.frame));
        localVideoView.backgroundColor = [UIColor whiteColor];
       // vItem.center = CGPointMake(self.dapiview.bounds.size.width/2, self.dapiview.bounds.size.height/2);
        [EUtility brwView: meBrwView  addSubview:localVideoView];
        
        [dvItem release];
    }
    NSDictionary* params = [NSDictionary dictionaryWithObjectsAndKeys:@"", @"params",
                            [NSNumber numberWithInt:MSG_NEED_VIDEO],@"msgid",
                            [NSNumber numberWithInt:0],@"arg",
                            [NSNumber numberWithBool:YES],@"iscallout",
                            nil];
    NSLog(@"发送监听：：》》》》%@",params);
    [[NSNotificationCenter defaultCenter]  postNotificationName:@"NOTIFY_EVENT" object:nil userInfo:params];
        
    }
}
//>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>以上为呼出音频+视频>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

//接听acceptCall接口；
-(void)acceptCall:(NSMutableArray*)inArgument
{
    if ([inArgument isKindOfClass:[NSMutableArray class]] && [inArgument count] == 1){
        
        NSLog(@"%@",inArgument);
        self.accepptType = [[inArgument objectAtIndex:0] intValue];
    
        if(!mSDKObj)
        {
            [self setLog:@"请先初始化"];
             [self jsSuccessWithName:@"uexESurfingRtc.cbCallStatus" opId:0 dataType:0 strData:@"ERROR:UNREGISTER"];
            return;
        }
        
        NSDictionary* params = [NSDictionary dictionaryWithObjectsAndKeys:@"", @"params",
                                [NSNumber numberWithInt:MSG_ACCEPT],@"msgid",
                                [NSNumber numberWithInt:0],@"arg",
                                nil];
    
        NSLog(@"+++++>>>>接听:%@",params);
        [self setLog:@"音频接听中......."];
        [[NSNotificationCenter defaultCenter]  postNotificationName:@"NOTIFY_EVENT" object:nil userInfo:params];
     }
}

//>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>以上为接听>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

//拒接rejectCall接口；
-(void)rejectCall:(NSMutableArray*)inArgument
{
    if(!mSDKObj)
    {
        [self setLog:@"请先初始化"];
        
        return;
    }
    
    NSDictionary* params = [NSDictionary dictionaryWithObjectsAndKeys:@"", @"params",
                            [NSNumber numberWithInt:MSG_REJECT],@"msgid",
                            [NSNumber numberWithInt:0],@"arg",
                            nil];
    
    [[NSNotificationCenter defaultCenter]  postNotificationName:@"NOTIFY_EVENT" object:nil userInfo:params];
}
//>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>以上拒接>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
//注销logout接口；
-(void)logout: (NSMutableArray *)inArgument
{
    if (mAccObj)
    {
        [mAccObj doUnRegister];
        [mAccObj release];
        mAccObj = nil;
        [self setLog:@"注销完毕"];
        
        if(mSDKObj)
        {
            [mSDKObj release];
            mSDKObj = nil;
            mLogIndex = 0;
            [self setLog:@"release完毕"];
            [self jsSuccessWithName:@"uexESurfingRtc.cbLogStatus" opId:0 dataType:0 strData:@"OK:LOGOUT"];
        }
        [localVideoView removeFromSuperview];
        [remoteVideoView removeFromSuperview];
//        self.appid=0;
//        self.appkeys = 0;
    }
    else
    {
        [self setLog:@"请先登录"];
    }
}
//>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>以上部分为注销logout接口>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
//挂断hangUp接口；
-(void)hangUp:(NSMutableArray*)inArgument
{
    NSDictionary* params = [NSDictionary dictionaryWithObjectsAndKeys:@"", @"params",
                            [NSNumber numberWithInt:MSG_HANGUP],@"msgid",
                            [NSNumber numberWithInt:0],@"arg",
                            nil];
    [[NSNotificationCenter defaultCenter]  postNotificationName:@"NOTIFY_EVENT" object:nil userInfo:params];
}
//>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>以上部分为挂断接口hangUp>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

//静音mute接口
-(void)mute:(NSMutableArray*)inArgument
{
    NSDictionary* params = [NSDictionary dictionaryWithObjectsAndKeys:@"", @"params",
                            [NSNumber numberWithInt:MSG_MUTE],@"msgid",
                            [NSNumber numberWithInt:0],@"arg",
                            nil];
    [[NSNotificationCenter defaultCenter]  postNotificationName:@"NOTIFY_EVENT" object:nil userInfo:params];
}

//>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>以上为静音mute接口>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

//扬声器

-(void)loudSpeaker:(NSMutableArray*)inArgument
{
    NSDictionary* params = [NSDictionary dictionaryWithObjectsAndKeys:@"", @"params",
                            [NSNumber numberWithInt:MSG_SET_AUDIO_DEVICE],@"msgid",
                            [NSNumber numberWithInt:0],@"arg",
                            nil];
    [[NSNotificationCenter defaultCenter]  postNotificationName:@"NOTIFY_EVENT" object:nil userInfo:params];
}


//呼叫网络状态事件通知
-(int)onNetworkStatus:(NSString*)desc callObj:(CallObj*)callObj
{
    return 0;
}

//>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>一下部分set分辨率接口》》》》》》》》》》》》》》》》》》》》》》》


-(void)setVideoAttr:(NSMutableArray*)inArgument
{
    if ([inArgument isKindOfClass:[NSMutableArray class]] && [inArgument count] == 1){
        
        if (!mSDKObj)
        {
            [self setLog:@"请先初始化"];
        }
        else{
            
            self.Resolutions = [[inArgument objectAtIndex:0] intValue];
            
            if (self.Resolutions ==0) {
                
               [mSDKObj setVideoAttr:[NSNumber numberWithInt:1]];
                
            } if (self.Resolutions ==1) {
                
                [mSDKObj setVideoAttr:[NSNumber numberWithInt:3]];
                
            } if (self.Resolutions ==2) {
                
                [mSDKObj setVideoAttr:[NSNumber numberWithInt:5]];
                
            }
            
        }
    }
}
//>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>以上为分辨率>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

-(void)takeRemotePicture:(NSMutableArray*)inArgument{
    
        if (!mCallObj || mCallObj.CallMedia!= MEDIA_TYPE_VIDEO)
        {
            [self setLog:@"请先呼叫"];
            return;
        }
    
        //获取应用程序沙盒的Documents目录
        NSBundle* mainBundle = [NSBundle mainBundle];
    
        NSDictionary* infoDictionary =  [mainBundle infoDictionary];
    
        NSString * bundleName = [infoDictionary objectForKey:@"CFBundleName"];
        //创建目录下的文件路径；
        NSString *path = [[[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:bundleName ]stringByAppendingPathComponent:@"photo"];
    
        NSFileManager *fileManager = [NSFileManager defaultManager];
        //进行创建；
        [fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    
        self.currentTime = [self getCurrentTime];
    
        NSLog(@"当前时间:%@",self.currentTime);
    
        NSString *resultPath = [NSString stringWithFormat:@"%@/%@.png",path,self.currentTime];
    
        NSLog(@"当前时间的路径 :%@",resultPath);

        [mCallObj doSnapImage:resultPath overWrite:YES];
    
        [self callBackMethodSuccess:[NSString stringWithFormat:@"%@",resultPath]];
    
      return;
}

-(void)callBackMethodSuccess:(NSString *)jsString{
    if (self.meBrwView) {
        jsString = [NSString stringWithFormat:@"uexESurfingRtc.cbRemotePicPath(\"0\",\"0\",\'%@\');",jsString];
        
        NSLog(@"保存到图片完成的(完成后调用)js========:%@",jsString);
        
        [self.meBrwView stringByEvaluatingJavaScriptFromString:jsString];
    }
}

//获取当前的时间；
- (NSString *)getCurrentTime{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyMMddhhmmss"];
    NSString *dateTime =[formatter stringFromDate:[NSDate date]];
    self.currentTime = dateTime;
    [formatter release];
    return currentTime;
}

-(NSInteger)calcRotation:(double)xy z:(double)z
{
    if ((z >= 45 && z <= 135) || (z >= -135 && z <= -45))//处于正向水平,反向水平位置,此时可作为竖直方向
    {
        return 0;
    }
    if (xy <= 180 && xy > 135)//竖直方向,向右侧倾斜,但未到角度
    {
        return 0;
    }
    if (xy <= 135 && xy >= 90)//竖直方向,向右倾斜,已经到位
    {
        return 90;
    }
    if (xy < 90 && xy >= 45) //斜向下方向,尚未到位
    {
        return 90;
    }
    if (xy < 45 && xy >= 0)//头朝下,已到位
    {
        return 180;
    }
    if (xy < 0 && xy >= -45)//头朝下,未到位
    {
        return 180;
    }
    if (xy < -45 && xy >= -90)//头朝下,已到位
    {
        return 270;
    }
    if (xy < -90 && xy >= -135)//头朝下,未到位
    {
        return 270;
    }
    if (xy < -135 && xy >= -180)//头朝上,偏左,已到位
    {
        return 0;
    }
    return 0;
}

-(void)setMotionStatus:(BOOL)doStart
{
    if (doStart)//对端接收的图像始终保持竖直方向
    {
        [mMotionManager startDeviceMotionUpdatesToQueue:[[[NSOperationQueue alloc] init] autorelease]
                                            withHandler:^(CMDeviceMotion *motion, NSError *error) {
                                                dispatch_sync(dispatch_get_main_queue(), ^(void) {
                                                    double gravityX = motion.gravity.x;
                                                    double gravityY = motion.gravity.y;
                                                    double gravityZ = motion.gravity.z;
                                                    double xyTheta = atan2(gravityX,gravityY)/M_PI*180.0;
                                                    double zTheta = atan2(gravityZ,sqrtf(gravityX*gravityX+gravityY*gravityY))/M_PI*180.0;
                                                    NSInteger rotation = [self calcRotation:xyTheta z:zTheta];
                                                    [[NSNotificationCenter defaultCenter]postNotificationName:@"MOTIONCHECK_NOTIFY"
                                                                                                       object:nil
                                                                                                     userInfo:
                                                     [NSDictionary dictionaryWithObjectsAndKeys:
                                                      [NSNumber numberWithInteger:rotation],@"rotation",
                                                      nil]];
                                                    
                                                });
                                            }];
    }
    else//对端接收的图像会随着本地设备的旋转而旋转
    {
        [mMotionManager stopDeviceMotionUpdates];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"MOTIONCHECK_NOTIFY"
                                                           object:nil
                                                         userInfo:
         [NSDictionary dictionaryWithObjectsAndKeys:
          [NSNumber numberWithInteger:0],@"rotation",
          nil]];
        
    }
}

-(void)checkNetWorkReachability
{
    firstCheckNetwork=YES;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reachabilityNetWorkStatusChanged:)
                                                 name: kReachabilityChangedNotification
                                               object: nil];
    
    hostReach = [[Reachability reachabilityWithHostname:@"www.apple.com"] retain];
    [hostReach startNotifier];
}

-(BOOL)accObjIsRegisted
{
    if (mAccObj && [mAccObj isRegisted])
        return  YES;
    return NO;
}

- (void) reachabilityNetWorkStatusChanged: (NSNotification* )note
{
    Reachability* curReach = [note object];
    int networkStatus = [curReach currentReachabilityStatus];
    BOOL isLogin = [self accObjIsRegisted];
    if (isLogin)
    {
        if (networkStatus==NotReachable)
        {
            //网络断开后销毁网络数据
            [self onNetworkChanged:NO];
        }
        else
        {
            if (firstCheckNetwork)
            {
                firstCheckNetwork=NO;
                return;
            }
            //网络恢复后进行重连
            [self onNetworkChanged:YES];
        }
    }
    
    firstCheckNetwork=NO;
}

-(void)onNetworkChanged:(BOOL)netstatus
{
    if (nil == mSDKObj || nil == mAccObj || NO == [mSDKObj isInitOk] || NO == [mAccObj isRegisted])
        return;
    CWLogDebug(@"networkChanged");
    if(netstatus)
        [mSDKObj onAppEnterBackground];//网络恢复后进行重连
    else
    {
        [mSDKObj onNetworkChanged];//网络断开后销毁网络数据
        
        if(mCallObj)//通话被迫结束，销毁通话界面
        {
            [mCallObj doHangupCall];
            [mCallObj release];
            mCallObj = nil;
        }
        [localVideoView removeFromSuperview];
        [remoteVideoView removeFromSuperview];
    }
}

- (void)keepAlive
{
    [self onAppEnterBackground];
}

-(void)onAppEnterBackground
{
    if (nil == mSDKObj || nil == mAccObj || NO == [mSDKObj isInitOk] || NO == [mAccObj isRegisted])
        return;
    [mSDKObj onAppEnterBackground];//SDK长连接
}

-(void)enterBackgroundNotification:(NSNotification *) notification
{
    //后台重连
    [NSRunLoop currentRunLoop];
    [self performSelectorOnMainThread:@selector(keepAlive) withObject:nil waitUntilDone:YES];
    [[UIApplication sharedApplication] setKeepAliveTimeout:600 handler: ^{
        [self performSelectorOnMainThread:@selector(keepAlive) withObject:nil waitUntilDone:YES];
    }];
}

-(void)enterForegroundNotification:(NSNotification *) notification
{
    if ([self getCallIncomingFlag])
    {
        [self setCallIncomingFlag:NO];
        int callType = [[[NSUserDefaults standardUserDefaults]objectForKey:KEY_CALL_TYPE]intValue];
        
        //延时等待应用唤醒后，再创建界面
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5*NSEC_PER_SEC)),dispatch_get_main_queue(),^
                       {
                           if (callType==1||callType==5||callType==9)
                           {
                               //[self jsSuccessWithName:@"uexESurfingRtc.cbCallStatus" opId:0 dataType:0 strData:@"OK:INCOMING"];
                               [self performSelectorOnMainThread:@selector(cbCallStatus:) withObject:@"OK:INCOMING" waitUntilDone:NO];
                           }
                           
                           if (callType == 3 || callType == 7 || callType == 11)
                           {
                               [self performSelectorOnMainThread:@selector(cbCallStatus:) withObject:@"OK:INCOMING" waitUntilDone:NO];
                               //[self jsSuccessWithName:@"uexESurfingRtc.cbCallStatus" opId:0 dataType:0 strData:@"OK:INCOMING"];
                               
                               DAPIPView* dvItem = [[DAPIPView alloc] init];
                               self.dapiview = dvItem;
                               
                               if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
                               {
                                   self.dapiview.borderInsets = UIEdgeInsetsMake(1.0f,       // top
                                                                                 1.0f,       // left
                                                                                 1.0f,      // bottom
                                                                                 1.0f);      // right
                               }
                               else
                               {
                                   self.dapiview.borderInsets = UIEdgeInsetsMake(1.0f,       // top
                                                                                 1.0f,       // left
                                                                                 1.0f,       // bottom
                                                                                 1.0f);      // right
                               }
                               
                               //远端窗口
                               remoteVideoView = [[IOSDisplay alloc]initWithFrame:CGRectMake(self.x1,self.y1, self.width, self.height1)];
                               remoteVideoView.backgroundColor = [UIColor whiteColor];
                               [EUtility brwView:meBrwView  addSubview:remoteVideoView];
                               
                               //本地窗口;
                               localVideoView = [[UIView alloc]initWithFrame:CGRectMake(self.x, self.y, self.width, self.height)];
                               NSLog(@"%@",NSStringFromCGRect(localVideoView.frame));
                               localVideoView.backgroundColor = [UIColor whiteColor];
                               // vItem.center = CGPointMake(self.dapiview.bounds.size.width/2, self.dapiview.bounds.size.height/2);
                               [EUtility brwView: meBrwView  addSubview:localVideoView];
                               
                               [dvItem release];
                               
                           }
                       });
    }
}

@end
