#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

//设备信息
@interface OpenUDID : NSObject {
}
+ (NSString*) value;
+ (NSString*) valueWithError:(NSError**)error;
+ (void) setOptOut:(BOOL)optOutValue;
@end

