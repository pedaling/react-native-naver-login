
#import "IosNaverLogin.h"

#import <React/RCTLog.h>
#import <React/RCTConvert.h>

#import "NaverThirdPartyConstantsForApp.h"
#import "NaverThirdPartyLoginConnection.h"
#import "NLoginThirdPartyOAuth20InAppBrowserViewController.h"

@interface IosNaverLogin() {
  NaverThirdPartyLoginConnection *naverConn;
  RCTResponseSenderBlock naverTokenSend;
}
@end

@implementation IosNaverLogin

-(void)oauth20ConnectionDidFailWithError:(THIRDPARTYLOGIN_RECEIVE_TYPE)error {
    if (naverTokenSend != nil) {
        if (error == CANCELBYUSER) {
            naverTokenSend(@[@"CANCELBYUSER", [NSNull null]]);
        }
        naverTokenSend = nil;
    }
}

-(void)oauth20ConnectionDidFinishRequestACTokenWithAuthCode {
  NSString *token = [naverConn accessToken];
  if (naverTokenSend != nil) {
    naverTokenSend(@[[NSNull null], token]);
    naverTokenSend = nil;
  }
}
-(void)oauth20ConnectionDidFinishRequestACTokenWithRefreshToken {
  NSString *token = [naverConn accessToken];
  if (naverTokenSend != nil) {
    naverTokenSend(@[[NSNull null], token]);
  }
}

-(void)oauth20ConnectionDidOpenInAppBrowserForOAuth:(NSURLRequest *)request {
  dispatch_async(dispatch_get_main_queue(), ^{
    NLoginThirdPartyOAuth20InAppBrowserViewController *inappAuthBrowser =
    [[NLoginThirdPartyOAuth20InAppBrowserViewController alloc] initWithRequest:request];
    UIViewController *vc = UIApplication.sharedApplication.delegate.window.rootViewController;
    [vc presentViewController:inappAuthBrowser animated:YES completion:nil];
  });
}

-(void)oauth20ConnectionDidFinishDeleteToken {

}

RCT_EXPORT_MODULE();

RCT_EXPORT_METHOD(login:(NSString *)keyJson callback:(RCTResponseSenderBlock)callback) {
  naverTokenSend = callback;

  naverConn = [NaverThirdPartyLoginConnection getSharedInstance];
  naverConn.delegate = self;

  NSData *jsonData = [keyJson dataUsingEncoding:NSUTF8StringEncoding];
  NSError *e;
  NSDictionary *keyObj = [NSJSONSerialization JSONObjectWithData:jsonData options:nil error:&e];

  [naverConn setConsumerKey:[keyObj objectForKey:@"kConsumerKey"]];
  [naverConn setConsumerSecret:[keyObj objectForKey:@"kConsumerSecret"]];
  [naverConn setAppName:[keyObj objectForKey:@"kServiceAppName"]];
  [naverConn setServiceUrlScheme:[keyObj objectForKey:@"kServiceAppUrlScheme"]];

  [naverConn setIsNaverAppOauthEnable:YES]; // 네이버 앱 사용 안할 때는 NO
  [naverConn setIsInAppOauthEnable:YES]; // 내장 웹뷰 사용 안할 때는 NO

  [naverConn setOnlyPortraitSupportInIphone:YES]; // 포트레이트 레이아웃만 사용하는 경우.

  NSString *token = [naverConn accessToken];

  if ([naverConn isValidAccessTokenExpireTimeNow]) {
    naverTokenSend(@[[NSNull null], token]);
  } else {
    [naverConn requestThirdPartyLogin];
  }
}

RCT_EXPORT_METHOD(logout) {
  [naverConn resetToken];
  naverTokenSend = nil;
}


@end
