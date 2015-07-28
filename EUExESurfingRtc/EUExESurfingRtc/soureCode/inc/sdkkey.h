#ifndef __sdk_key_h
#define __sdk_key_h

#define SDK_DEFAULT_ADDRESS 1 //使用默认地址
#define SDK_HAS_VIDEO 1 //开启视频通话
#define SDK_HAS_GROUP 1 //开启多人会话

//视频参数
#define KEY_NAME						@"name"
#define KEY_PAYLOAD_TYPE				@"pt"
#define KEY_VIDEO_WIDTH					@"w"
#define KEY_VIDEO_HEIGHT				@"h"
#define KEY_VIDEO_FRAMESPEED			@"f"
#define KEY_VIDEO_AVG_BITRATE			@"br"
#define KEY_VIDEO_MAX_BITRATE			@"xbr"
#define KEY_VIDEO_NACK					@"nack"

//呼叫参数
#define KEY_ACC_NAME					@"acc.name"
#define KEY_ACC_URI						@"acc.uri"
#define KEY_ACC_PWD						@"acc.pwd"
#define KEY_ACC_DOMAIN					@"acc.domain"
#define KEY_ACC_REALM					@"acc.realm"
#define KEY_ACC_SVR						@"acc.svr"
#define KEY_ACC_ID						@"acc.id"
#define KEY_ACC_SRTP                    @"srtp.mode"

#define KEY_REG_RETRY					@"reg.retry"
#define KEY_REG_DO						@"reg.do"
#define KEY_REG_EXPIRES					@"reg.expires"
#define KEY_REG_RSP_REASON              @"reg.rsp.reason"
#define KEY_REG_RSP_CODE                @"reg.rsp.code"
#define KEY_REASON                      @"reason"
#define KEY_RESULT                      @"code"

#define KEY_KEEPALIVE_SEC				@"ka.sec"
#define KEY_KEEPALIVE_TEXT				@"ka.text"
#define KEY_SESSION_TIMER_TYPE			@"se.type"
#define KEY_SESSION_TIMER_MIN			@"se.min"
#define KEY_SESSION_TIMER_CUR			@"se.cur"
#define KEY_RTP_PORT					@"rtp.port"
#define KEY_LINE_CNT					@"line.cnt"
#define KEY_TLS_PEM						@"tls.pem"

#define KEY_MESSAGE					    @"msg"
#define KEY_ALERT_INFO					@"alert-info"
#define KEY_CALL_INFO					@"ci"
#define KEY_CALL_ID						@"call.id"
#define KEY_CALL_TYPE					@"call.type"
#define KEY_CALLED						@"call.ed"
#define KEY_CALLER						@"call.er"
#define KEY_LOCAL_VIDEO_WINDOW			@"call.video.lwindow"
#define KEY_REMOTE_VIDEO_WINDOW			@"call.video.rwindow"
#define KEY_CALL_FAILED_CODE            @"call.errcode"
#define KEY_CALL_ACC_TYPE               @"call.acctype"
#define KEY_CALL_REMOTE                 @"call.remote"
#define KEY_CALL_REMOTE_ACC_TYPE        @"call.remote.acctype"
#define KEY_CALL_REMOTE_TERMINAL_TYPE   @"call.remote.tntype"

#define KEY_CODEC_NAME                  @"codec.name"
#define KEY_CODEC_ENABLE                @"codec.enable"
#define KEY_CODEC_PAYLOAD               @"codec.pt"

#define KEY_CAPABILITYTOKEN             @"capabilityToken"
#define KEY_RTCACCOUNTID                @"rtcaccountID"

//终端类型
#define TERMINAL_TYPE_ANY    		    @"Any"
#define TERMINAL_TYPE_TV     		    @"TV"
#define TERMINAL_TYPE_PAD    		    @"Pad"
#define TERMINAL_TYPE_PHONE  		    @"Phone"
#define TERMINAL_TYPE_PC     		    @"PC"
#define TERMINAL_TYPE_BROWSER		    @"Browser"
#define TERMINAL_TYPE_OTHER  		    @"Other"

//账号体系，10 应用自有体系,11 天翼账号,12 新浪微博账号,13 QQ账号
typedef enum _SDK_ACCTYPE
{
    ACCTYPE_APP = 10,
    ACCTYPE_TY,
    ACCTYPE_SINAWEIBO,
    ACCTYPE_QQ,
}SDK_ACCTYPE;

//呼叫类型
typedef enum _SDK_CALLTYPE
{
    AUDIO_CALL = 1,
#if (SDK_HAS_VIDEO>0)
    VIDEO_CALL = 3,
#endif
    AUDIO_CALL_RECVONLY = 5,
#if (SDK_HAS_VIDEO>0)
    VIDEO_CALL_RECVONLY = 7,
#endif
    AUDIO_CALL_SENDONLY = 9,
#if (SDK_HAS_VIDEO>0)
    VIDEO_CALL_SENDONLY = 11,
#endif
}SDK_CALLTYPE;

//静音
typedef enum _SDK_MUTE
{
    MUTE_DOUNMUTE = 0,
    MUTE_DOMUTE,
}SDK_MUTE;

//媒体类型
typedef enum _SDK_MEDIA_TYPE
{
    MEDIA_TYPE_AUDIO = 0,
#if (SDK_HAS_VIDEO>0)
    MEDIA_TYPE_VIDEO,
#endif
}SDK_MEDIA_TYPE;

//画面隐藏
#if (SDK_HAS_VIDEO>0)
typedef enum  _SDK_HIDE_LOCAL_VIDEO
{
    DO_SHOW_LOCAL_VIDEO = 0,
    DO_HIDE_LOCAL_VIDEO,
}SDK_HIDE_LOCAL_VIDEO;
#endif

//音频输出设备
typedef enum _SDK_AUDIO_OUTPUT_DEVICE
{
    SDK_AUDIO_OUTPUT_UNKNOW = -1,
    SDK_AUDIO_OUTPUT_DEFAULT = 0,//机身听筒
    SDK_AUDIO_OUTPUT_SPEAKER,//机身外放
    SDK_AUDIO_OUTPUT_HEADSET,//耳机
}SDK_AUDIO_OUTPUT_DEVICE;

#if (SDK_HAS_VIDEO>0)
//画面旋转
typedef enum  _SDK_VIDEO_ROTATE
{
    SDK_VIDEO_ROTATE_0 = 0,
    SDK_VIDEO_ROTATE_90,
    SDK_VIDEO_ROTATE_180,
    SDK_VIDEO_ROTATE_270,
    SDK_VIDEO_ROTATE_AUTO,//自动旋转控制
}SDK_VIDEO_ROTATE;
#endif

//呼叫保持
typedef enum _SDK_HOLD_ACTION
{
    SDK_DO_UNHOLD = 0,
    SDK_DO_HOLD,
}SDK_HOLD_ACTION;

typedef enum _SDK_HOLD_STATUS
{
    SDK_NORMAL=0,
    SDK_HOLDED,
}SDK_HOLD_STATUS;

//log类型
typedef enum _SDK_LOG_LEVEL
{
    SDK_LOG_NORMAL = 0,
    SDK_LOG_DEBUG,
    SDK_LOG_WARNING,
    SDK_LOG_ERROR,
}SDK_LOG_LEVEL;

//授权类型
typedef enum _SDK_ACC_AUTH_TYPE
{
    ACC_AUTH_TO_APPALL = 0,//0：向应用整体授权，所有该应用用户获得相同的权限和token（此时按token无法唯一识别用户身份）；
    ACC_AUTH_TO_APPUSER,//1：向应用内用户授权
}SDK_ACC_AUTH_TYPE;

//在线查询
typedef enum _SDK_ACC_SEARCH_FLAG
{
    ACC_SEARCH_ONLY_APP = 0,//0：表示只查询该应用内用户帐号ID在本应用内的在线状态
    ACC_SEARCH_ALL,//1：表示查询该应用内用户帐号ID在所有应用内的在线状态
}SDK_ACC_SEARCH_FLAG;

//呼叫回调状态
typedef enum _SDK_CALLBACK_TYPE
{
    SDK_CALLBACK_CLOSED = 0,//通话中被对方挂断
    SDK_CALLBACK_FAILED,//呼叫中被对方挂断
    SDK_CALLBACK_CANCELED,//多终端登录，一端取消接听
    SDK_CALLBACK_ACCEPTED,//呼叫被接听
    SDK_CALLBACK_RING,//正在发起呼叫
}SDK_CALLBACK_TYPE;

/***********************************多人****************************************/
#if (SDK_HAS_GROUP>0)
//多人会话参数
#define KEY_GVC_CREATER                   @"gvccreator" //多人会话发起方
#define KEY_GVC_CREATERTYPE               @"gvccreatorTerminalType" //发起方终端类型
#define KEY_GVC_TYPE                      @"gvctype" //多人会话请求类型
#define KEY_GVC_NAME                      @"gvcname" //群组名
#define KEY_GVC_MAXMEMBER                 @"gvcmaxmember" //最大成员数
#define KEY_GVC_INVITEELIST               @"gvcinviteeList" //成员列表
#define KEY_GVC_ATTENDINGPOLICY           @"gvcattendingPolicy" //加入方式
#define KEY_GVC_PASSWORD                  @"gvcpassword" //加入密码
#define KEY_GVC_CREATERCALBACKURL         @"gvccreatorCalbackURL" //回调地址
#define KEY_GVC_CREATERCALBACKMETHOD      @"gvccreatorCalbackMethod" //回调方法
#define KEY_GVC_SWITCHPICTURE             @"autoSwitchPicture" //多人视频递补画面
#define KEY_GVC_CODEC                     @"codec" //微直播编码格式
#define KEY_GVC_JOINONLY                  @"gvcjoinonly" //是否允许多终端主动加入
#define KEY_GRP_ACCID                     @"appAccountID" //账户
#define KEY_GRP_CALLID                    @"callId" //会议ID
#define KEY_GRP_INVITEDMBLIST             @"invitedmemberlist"  //邀请成员列表
#define KEY_GRP_MODE                      @"mode" //会话收发方式
#define KEY_GRP_KICKEDMBLIST              @"kickedMemberList" //踢出成员列表
#define KEY_GRP_REPLACERMEMBER            @"replacerMember" //替代者
#define KEY_GRP_MBOPERATIONLIST           @"memberOperationList" //麦克管理
#define KEY_GRP_MEMBER                    @"member" //账户列表
#define KEY_GRP_UPOPERATIONTYPE           @"upStreamOperationType" //上行媒体流
#define KEY_GRP_DWOPERATIONTYPE           @"downStreamOperationType" //下行媒体流
#define KEY_GRP_DISPLAYMODE               @"displayMode" //分屏方式
#define KEY_GRP_MEMBERLIST                @"memberList" //账户列表
#define KEY_GRP_ISCREATOR                 @"isgrpcreator"//是否为创建者
#define KEY_GRP_MBSTATUS                  @"memberStatus"//成员状态


//多人请求类型
typedef enum _SDK_GROUP_OPT
{
    SDK_GROUP_CREATE = 101,//发起多人会话
    SDK_GROUP_GETMEMLIST = 102,//获取成员列表
    SDK_GROUP_INVITEMEMLIST = 103, //邀请成员加入
    SDK_GROUP_KICKMEMLIST = 104, //退出群组语音/踢出某群组成员
    SDK_GROUP_MUTE = 105, //禁止群组成员发言/给麦
    SDK_GROUP_UNMUTE = 106, //解禁/收麦
    SDK_GROUP_CLOSEVOICE = 107, //关闭群组语音
    SDK_GROUP_VIDEO = 108, //管理视频分屏
    SDK_GROUP_JOIN = 109,//主动参会
    //SDK_GROUP_GRPLIST = 110,//获取会议列表
}SDK_GROUP_OPT;

//多人会话类型
typedef enum _SDK_GROUP_TYPE
{
    SDK_GROUP_CHAT_AUDIO = 0,//0:多人会话群聊
    SDK_GROUP_SPEAK_AUDIO = 1,//1:多人会话对讲
    SDK_GROUP_TWOVOICE_AUDIO = 2, //2:多人两方语音
    SDK_GROUP_MICROLIVE_AUDIO = 9, //9:多人语音微直播
    SDK_GROUP_CHAT_VIDEO = 20,//20:多人视频群聊（语音＋视频）
    SDK_GROUP_SPEAK_VIDEO = 21,//21:多人视频会话对讲（语音＋视频）
    SDK_GROUP_TWOVOICE_VIDEO = 22, //22:多人两方视频（语音＋视频）
    SDK_GROUP_MICROLIVE_VIDEO = 29, //29:多人视频微直播（语音＋视频）
}SDK_GROUP_TYPE;

//加入方式
typedef enum _SDK_GROUP_ATTENDPOLICY
{
    SDK_GROUP_NO_PASSWORD = 0,//0：不需要输入密码
    SDK_GROUP_NEED_PASSWORD,//1：需要密码验证，并且是明文传送密码
}SDK_GROUP_ATTENDPOLICY;

//收发方式
typedef enum _SDK_GROUP_MODE
{
    SDK_GROUP_AUDIO_SENDRECV = 0,//0 语音方式 可以听 可以说
    SDK_GROUP_AUDIO_RECVONLY = 1,//1 语音方式，可以听，不可以说
    SDK_GROUP_VIDEO_SENDRECV = 2,//2 视频方式，可以收，可以发自身视频
    SDK_GROUP_VIDEO_RECVONLY = 3,//3 视频方式，可以收，不上传自身视频
    SDK_GROUP_AUDIO_SENDRECV_VIDEO_RECVONLY = 4,//4 语音+视频方式，可以收语音和视频，不上传自身视频，可以上传声音
    SDK_GROUP_AUDIO_RECVONLY_VIDEO_RECVONLY = 5,//5  语音+视频方式，可以收语音和视频，不上传自身视频和语音
    SDK_GROUP_AUDIO_SENDONLY_VIDEO_SENDONLY = 6,//6  语音+视频方式，不收看语音和视频，上传自身视频和语音
    SDK_GROUP_MODE_CUSTOM = 10,//10 终端选择（根据应用层选择设定上述方式）
}SDK_GROUP_MODE;

//麦克管理
typedef enum _SDK_GROUP_MIC
{
    SDK_GROUP_MUTE_AUDIO = 0,//0：禁止发送语音，收回麦克
    SDK_GROUP_UNMUTE_AUDIO = 1,//1：解除禁止发送语音，给麦
    SDK_GROUP_MUTE_VIDEO = 2,//2：禁止发送视频
    SDK_GROUP_UNMUTE_VIDEO = 3,//3：解除禁止发送视频
    SDK_GROUP_MUTE_AUDIO_VIDEO = 4,//4：禁止发送语音+视频
    SDK_GROUP_UNMUTE_AUDIO_VIDEO = 5,//5：解除禁止发送语音+视频
}SDK_GROUP_MIC;

//分屏模式
typedef enum _SDK_GROUP_DISPLAYMODE
{
    SDK_GROUP_EQUALDIS = 0,//0：对等分屏
    SDK_GROUP_UNEQUALDIS,//1：非对等分屏
}SDK_GROUP_DISPLAYMODE;

//成员状态
typedef enum _SDK_GROUP_STATUS
{
    SDK_GROUP_PREPARE = 1,//1:代表准备状态（主席正在振铃）
    SDK_GROUP_JOINED = 2,//2:代表已加入
    SDK_GROUP_UNJOIN = 3, //3代表未加入
    SDK_GROUP_DELETE = 4, //4:代表被删除出（被删除出的成员不能再加入此会议）
    SDK_GROUP_RINGING = 5, //5:代表振铃状态（成员振铃）
}SDK_GROUP_STATUS;

#endif //#if (SDK_HAS_GROUP>0)
#endif //__sdk_key_h

#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
#define SCREEN_WIDTH                        320.0f
#define SCREEN_HEIGHT                       (460.0f+(iPhone5?88:0))
//系统是否为ios5以上
#define ISIOS5 !([[[UIDevice currentDevice] systemVersion] floatValue] <=4.9f)
//系统是否为ios6以上
#define ISIOS6 !([[[UIDevice currentDevice] systemVersion] floatValue] <=5.9f)
//系统是否为ios7以上
#define ISIOS7 !([[[UIDevice currentDevice] systemVersion] floatValue] <=6.9f)
//状态栏高度
#define  CW_STATUSBAR_HEIGHT  20.0f
#define  IOS7_STATUSBAR_DELTA   (ISIOS7?(CW_STATUSBAR_HEIGHT):0)