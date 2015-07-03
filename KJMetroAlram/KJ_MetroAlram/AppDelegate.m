//
//  AppDelegate.m
//  KJ_MetroAlram
//
//  Created by KimGiBong on 2014. 10. 25..
//  Copyright (c) 2014년 KimGiBong. All rights reserved.
//

#import "AppDelegate.h"
#import "SEManager.h"
#import "KJMSpentTimeManager.h"
#import "StartTimerViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    if ([application respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeSound categories:nil];
        [application registerUserNotificationSettings:settings];
    }

    //음악 재생어플로 음악 재생중 & 어플 활성화상태에서 효과음 재생시 음악 끊기는 현상 대응(사운드 동시재생)
    //참조 : http://www.ecoop.net/memo/archives/ios_play_sounds_and_background_music_simultaneously.html
    
    //2차 참조 : https://developer.apple.com/jp/devcenter/ios/library/documentation/AudioSessionProgrammingGuide.pdf 의 [オーディオセッションのカテゴリとモード] 부분
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryAmbient error:nil];
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    
    return YES;
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    
    NSLog(@"didReceiveLocalNotification %@", notification.soundName);
    [[SEManager sharedManager] playSound:notification.soundName];

    for(UILocalNotification *notification in [[UIApplication sharedApplication] scheduledLocalNotifications]) {
        [[UIApplication sharedApplication] cancelLocalNotification:notification];
    }
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    [[StartTimerViewController shareInstance] dismissStartTimerView];
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    [[StartTimerViewController shareInstance] setStartTimer];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
