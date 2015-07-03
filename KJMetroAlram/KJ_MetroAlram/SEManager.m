//
//  SEManager.m
//  KJ_MetroAlram
//
//  Created by NoodleKim on 2014/10/29.
//  Copyright (c) 2014年 KimGiBong. All rights reserved.
//

#import "SEManager.h"

static SEManager *sharedData_ = nil;

@implementation SEManager

+ (SEManager *)sharedManager{
    @synchronized(self){
        if (!sharedData_) {
            sharedData_ = [[SEManager alloc]init];
            sharedData_.alramFileArr = @[@"電子音.mp3", @"猫の鳴き声.mp3", @"もうすぐだよ.mp3", @"いってらっしゃい.mp3", @"おかえりなさい.mp3", @"音なし.mp3", @"final"];
        }
    }
    return sharedData_;
}

- (id)init
{
    self = [super init];
    if (self) {
        soundArray = [[NSMutableArray alloc] init];
        _soundVolume = 1.0;
    }
    return self;
}

#pragma mark - Custom Accessors
- (NSString*)seletecAlramFileName {
    
    NSString* alramFileIndex = [[NSUserDefaults standardUserDefaults] objectForKey:@"ALRAM"];
    return self.alramFileArr[alramFileIndex.integerValue];
}

#pragma mark - Private
- (void)playSound:(NSString *)soundName{
    NSString *soundPath = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:soundName];
    NSURL *urlOfSound = [NSURL fileURLWithPath:soundPath];
    
    AVAudioPlayer* player = [[AVAudioPlayer alloc] initWithContentsOfURL:urlOfSound error:nil];
    [player setNumberOfLoops:0];
    player.volume = _soundVolume;
    player.delegate = (id)self;
    [soundArray insertObject:player atIndex:0];
    [player prepareToPlay];
    [player play];
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    [soundArray removeObject:player];
}

@end
