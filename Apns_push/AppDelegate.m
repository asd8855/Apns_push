//
//  AppDelegate.m
//  Apns_push
//
//  Created by libo on 2017/1/20.
//  Copyright © 2017年 蝉鸣. All rights reserved.
//

/*
 * 环信推送 http://docs.easemob.com/start/300iosclientintegration/85apnscontent
 */

#import "AppDelegate.h"
#import "NSString+JSON.h"
#import <UserNotifications/UserNotifications.h>

@interface AppDelegate ()<UNUserNotificationCenterDelegate>

@end

#define ZLScreenWidth     ([UIScreen mainScreen].bounds.size.width)  //屏幕宽
#define ZLScreenHeight    ([UIScreen mainScreen].bounds.size.height) //屏幕高
#define IS_IOS10_And_Over ([[[UIDevice currentDevice] systemVersion] floatValue] >= 10.0?YES:NO)

#define IS_IOS8_And_Over ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0?YES:NO)

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

    return YES;
}

/*
 * 注册通知
 */
- (void)registerRemoteNotification {

    UIApplication *application = [UIApplication sharedApplication];
    
    if (IS_IOS10_And_Over) {
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        center.delegate = self; //必须写代理,不然无法监听通知的接受与点击事件
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionBadge | UNAuthorizationOptionAlert | UNAuthorizationOptionBadge) completionHandler:^(BOOL granted, NSError * _Nullable error) {
            
            if (granted) { // 允许
                //可以通过getNotificationSettingsWithCompletionHandler获取权限设置
                //之前注册推送服务,用户点击了同意还是不同意,以及用户之后又做了怎样的更改我们都无从得知,现在 apple 开发了这个 API,我们可以直接获取到用户的设定信息了
                [center getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
                    NSLog(@"===%@===",settings);
                }];
                [application registerForRemoteNotifications];
            }
            
        }];
    }else if ([application respondsToSelector:@selector(registerForRemoteNotifications)]) {
        //iOS 8以上 iOS10一下的系统
        [application registerForRemoteNotifications];
        UIUserNotificationType notificationTypes = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:notificationTypes categories:nil];
        [application registerUserNotificationSettings:settings];
    }
}

/*
 *  本地推送 走该方法
 */
- (void)application:(UIApplication *)application didReceiveLocalNotification:(nonnull UILocalNotification *)notification {
    if (application.applicationState == UIApplicationStateInactive) {
        /*
         当应用程序进入前台的时候执行,如果需要判断跳到哪个页面,可以根据notification的userInfo传递过来的值判断
         调试小技巧:如果想看应用程序退出后再进入前台是否执行了该方法。由于,退出应用程序后Xcode就不再处于调试状态,所以不能通过打印来判断是否执行了该方法。但是可以通过给一个View添加label来把userInfo的信息显示出来
         */
        NSDictionary *userInfo = notification.userInfo;
        [self createLabelShowPushInfo:userInfo Tag:@"1111"];
    }
}

//正常收到远程通知后调用该监听方法 iOS 10离线推送 最新的iOS 10.2 Xcode 8.2.1 并不会走该方法 以前测试的时候会
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(nonnull NSDictionary *)userInfo {
    
    [self createLabelShowPushInfo:userInfo Tag:@"2222"];
}

//最新测试证明 iOS 10.2 Xcode8.2.1 本地推送 离线推送 均走该方法
- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    
    NSDictionary *userInfo = response.notification.request.content.userInfo;
    [self createLabelShowPushInfo:userInfo Tag:@"3333"];
}

//最新测试 没有走入该方法
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler {
    
    NSDictionary *userInfo = notification.request.content.userInfo;
    [self createLabelShowPushInfo:userInfo Tag:@"4444"];
}

//iOS7及以上系统,离线推送走该方法 如果没有写最新的didReceiveNotificationResponse or willPresentNotification iOS 10也会走该方法
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(nonnull NSDictionary *)userInfo fetchCompletionHandler:(nonnull void (^)(UIBackgroundFetchResult))completionHandler {
    
    NSLog(@"5555");
    [self createLabelShowPushInfo:userInfo Tag:@"5555"];
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}

- (void)createLabelShowPushInfo:(NSDictionary *)userInfo Tag:(NSString *)tag{

    NSString *string = [NSString jsonStringWithNSDictionary:userInfo];
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ZLScreenWidth, ZLScreenHeight)];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, ZLScreenWidth, ZLScreenHeight)];
    label.backgroundColor = [UIColor cyanColor];
    label.text = [NSString stringWithFormat:@"%@--%@",string,tag];
    label.numberOfLines = 0;
    [view addSubview:label];
    self.window.backgroundColor = [UIColor redColor];
    [self.window addSubview:view];
    [self.window makeKeyAndVisible];

}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
