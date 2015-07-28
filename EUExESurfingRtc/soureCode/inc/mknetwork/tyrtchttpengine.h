#import "MKNetworkEngine.h"

@interface tyrtchttpengine : MKNetworkEngine

typedef void (^GetTokenOkBlock)(BOOL ok,NSDictionary* dic);
typedef void (^GetAddressesOkBlock)(BOOL ok,NSDictionary* dic);
typedef void (^RespOkBlock)(BOOL ok,NSDictionary* dic);

-(MKNetworkOperation*) getServerAddresses:(NSString*)httpMethod
                                   useSSL:(BOOL)useSSL
                                    appId:(NSString*)appId
                                   appKey:(NSString*)appKey
                        completionHandler:(RespOkBlock) completionBlock
                             errorHandler:(MKNKErrorBlock) errorBlock;

-(MKNetworkOperation*) getAccountToken:(NSString*)httpMethod
                                useSSL:(BOOL)useSSL
                                 appId:(NSString*)appId
                                appKey:(NSString*)appKey
                                 accId:(NSString*)accId
                              authType:(int)authType
                          terminalType:(NSString*)terminalType
                            terminalSN:(NSString*)terminalSN
                              grantStr:(NSString*)grantStr
                           callbackURL:(NSString*)callbackURL
                     completionHandler:(RespOkBlock) completionBlock
                          errorHandler:(MKNKErrorBlock) errorBlockr;

-(MKNetworkOperation*) getUserStatus:(NSString*)httpMethod
                              useSSL:(BOOL)useSSL
                               appId:(NSString*)appId
                              appKey:(NSString*)appKey
                              accIds:(NSString*)accIds
                        authTypeFlag:(int)authTypeFlag
                               token:(NSString*)token
                   completionHandler:(RespOkBlock) completionBlock
                        errorHandler:(MKNKErrorBlock) errorBlock;

-(MKNetworkOperation*) GroupCall:(NSString*)httpMethod
                          useSSL:(BOOL)useSSL
                           appId:(NSString*)appId
                          appKey:(NSString*)appKey
                         creater:(NSString*)gvcCreater
                     createrType:(NSString*)gvcCreaterType
                            type:(int)gvcType
                            name:(NSString*)gvcName
                          maxMem:(int)gvcMaxmem
                     inviteeList:(NSMutableArray*)gvcinviteeList
                          attend:(int)gvcAttend
                        password:(NSString*)gvcPassword
                           cbUrl:(NSString*)gvcCBurl
                        cvMethod:(NSString*)gvcCBmethod
                       switchPic:(int)switchPicture
                           codec:(int)codec
                           token:(NSString*)token
               completionHandler:(RespOkBlock) completionBlock
                    errorHandler:(MKNKErrorBlock) errorBlock;

-(MKNetworkOperation*) getGroupMemeberList:(NSString*)httpMethod
                                    useSSL:(BOOL)useSSL
                                     appId:(NSString*)appId
                                    appKey:(NSString*)appKey
                                   creater:(NSString*)gvcCreater
                               createrType:(NSString*)gvcCreaterType
                                    callID:(NSString*)callID
                                     token:(NSString*)token
                         completionHandler:(RespOkBlock) completionBlock
                              errorHandler:(MKNKErrorBlock) errorBlock;

-(MKNetworkOperation*) InvitedMembermanagement:(NSString*)httpMethod
                                        useSSL:(BOOL)useSSL
                                         appId:(NSString*)appId
                                        appKey:(NSString*)appKey
                                       creater:(NSString*)gvcCreater
                                   createrType:(NSString*)gvcCreaterType
                                        callID:(NSString*)callID
                                   inviteeList:(NSMutableArray*)inviteeList
                                          mode:(int)mode
                                         token:(NSString*)token
                             completionHandler:(RespOkBlock) completionBlock
                                  errorHandler:(MKNKErrorBlock) errorBlock;

-(MKNetworkOperation*) JoinedMembermanagement:(NSString*)httpMethod
                                       useSSL:(BOOL)useSSL
                                        appId:(NSString*)appId
                                       appKey:(NSString*)appKey
                                      creater:(NSString*)gvcCreater
                                  createrType:(NSString*)gvcCreaterType
                                       callID:(NSString*)callID
                                  inviteeList:(NSMutableArray*)inviteeList
                                         mode:(int)mode
                                     password:(NSString*)gvcPassword
                                        token:(NSString*)token
                            completionHandler:(RespOkBlock) completionBlock
                                 errorHandler:(MKNKErrorBlock) errorBlock;

-(MKNetworkOperation*) KickedMemberList:(NSString*)httpMethod
                                 useSSL:(BOOL)useSSL
                                  appId:(NSString*)appId
                                 appKey:(NSString*)appKey
                                creater:(NSString*)gvcCreater
                            createrType:(NSString*)gvcCreaterType
                                 callID:(NSString*)callID
                             kickedList:(NSMutableArray*)kickedList
                         replacerMember:(NSString*)replacerMember
                                  token:(NSString*)token
                      completionHandler:(RespOkBlock) completionBlock
                           errorHandler:(MKNKErrorBlock) errorBlock;

-(MKNetworkOperation*) CloseGroupCall:(NSString*)httpMethod
                               useSSL:(BOOL)useSSL
                                appId:(NSString*)appId
                               appKey:(NSString*)appKey
                              creater:(NSString*)gvcCreater
                          createrType:(NSString*)gvcCreaterType
                               callID:(NSString*)callID
                                token:(NSString*)token
                    completionHandler:(RespOkBlock) completionBlock
                         errorHandler:(MKNKErrorBlock) errorBlock;

-(MKNetworkOperation*) GrpvMicManagement:(NSString*)httpMethod
                                  useSSL:(BOOL)useSSL
                                   appId:(NSString*)appId
                                  appKey:(NSString*)appKey
                                 creater:(NSString*)gvcCreater
                             createrType:(NSString*)gvcCreaterType
                                  callID:(NSString*)callID
                          openrationList:(NSMutableArray*)openrationList
                                   token:(NSString*)token
                       completionHandler:(RespOkBlock) completionBlock
                            errorHandler:(MKNKErrorBlock) errorBlock;

-(MKNetworkOperation*) GrpvVideoManagement:(NSString*)httpMethod
                                    useSSL:(BOOL)useSSL
                                     appId:(NSString*)appId
                                    appKey:(NSString*)appKey
                                   creater:(NSString*)gvcCreater
                               createrType:(NSString*)gvcCreaterType
                                    callID:(NSString*)callID
                               displayMode:(int)dismode
                            openrationList:(NSMutableArray*)openrationList
                                     token:(NSString*)token
                         completionHandler:(RespOkBlock) completionBlock
                              errorHandler:(MKNKErrorBlock) errorBlock;

-(MKNetworkOperation*) getGroupList:(NSString*)httpMethod
                             useSSL:(BOOL)useSSL
                              appId:(NSString*)appId
                             appKey:(NSString*)appKey
                            creater:(NSString*)gvcCreater
                        createrType:(NSString*)gvcCreaterType
                             callID:(NSString*)callID
                              token:(NSString*)token
                  completionHandler:(RespOkBlock) completionBlock
                       errorHandler:(MKNKErrorBlock) errorBlock;
@end
