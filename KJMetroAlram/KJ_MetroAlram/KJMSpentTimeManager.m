//
//  KJMSpentTimeManager.m
//  KJ_MetroAlram
//
//  Created by NoodleKim on 2014. 11. 8..
//  Copyright (c) 2014년 KimGiBong. All rights reserved.
//

#import "KJMSpentTimeManager.h"
#import "Station.h"
#import "Via.h"

@interface KJMSpentTimeManager ()

@property (strong, nonatomic) NSMutableDictionary *lineInfo;
@property (strong, nonatomic) NSMutableDictionary *spentTimeLine;
@property (strong, nonatomic) NSMutableArray *stationTitleAndCodes;
@end

@implementation KJMSpentTimeManager

#pragma mark - Singleton
+ (KJMSpentTimeManager*)shareInstance {
    
    static dispatch_once_t pred = 0;
    __strong static KJMSpentTimeManager *_instance = nil;
    
    dispatch_once(&pred, ^{
        _instance = [KJMSpentTimeManager new];
        [_instance _init];
    });
    return _instance;
}

#pragma mark - Private
- (void)_init {
    
    [self _initSpentTimeData];
    [self _initLineInfoData];
    [self _initStationTitleAndCode];
    
}

- (NSDictionary*)_jsonDataWithFileName:(NSString*)fileName {
    
    NSString *lineInfoPath = [[NSBundle mainBundle] pathForResource:fileName ofType:@"json"];
    
    NSError *error;
    NSData *stationData = [NSData dataWithContentsOfFile:lineInfoPath];
    return  [NSJSONSerialization JSONObjectWithData:stationData options:NSJSONReadingMutableLeaves error:&error];
 
}

- (NSDictionary*)_dictionaryPlistDataWithFileName:(NSString*)fileName {
    
    NSString *staDetailPath = [[NSBundle mainBundle] pathForResource:fileName ofType:@"plist"];
    return [NSDictionary dictionaryWithContentsOfFile:staDetailPath];
    
}

- (NSArray*)_arrayPlistDataWithFileName:(NSString*)fileName {
    
    NSString *staDetailPath = [[NSBundle mainBundle] pathForResource:fileName ofType:@"plist"];
    return [NSArray arrayWithContentsOfFile:staDetailPath];
    
}


- (void)_initSpentTimeData {
    
    self.spentTimeLine = [NSMutableDictionary new];
    
    NSString *linePath = [[NSBundle mainBundle] pathForResource:@"MetoroSpentTime" ofType:@"json"];
    
    NSError *error;
    NSData *stationData = [NSData dataWithContentsOfFile:linePath];
    NSDictionary *spentTimeDic = [NSJSONSerialization JSONObjectWithData:stationData options:NSJSONReadingMutableLeaves error:&error];
    
    if (error) {
        return;
    }
    
    self.spentTimeLine = [NSMutableDictionary dictionaryWithDictionary:spentTimeDic];
    
    return;
}

- (void)_initLineInfoData {
    
    NSString *lineInfoPath = [[NSBundle mainBundle] pathForResource:@"MetoroLine" ofType:@"json"];
    
    NSError *error;
    NSData *stationData = [NSData dataWithContentsOfFile:lineInfoPath];
    NSDictionary *lineInfoDic = [NSJSONSerialization JSONObjectWithData:stationData options:NSJSONReadingMutableLeaves error:&error];
    
    if (error) {
        return;
    }
    
    self.lineInfo = [NSMutableDictionary dictionaryWithDictionary:lineInfoDic];
    
}

- (void)_initStationTitleAndCode {
    
    NSString *staDetailPath = [[NSBundle mainBundle] pathForResource:@"KJMetroStationDetail" ofType:@"plist"];
    NSArray *staDetailArr = [NSArray arrayWithContentsOfFile:staDetailPath];
    self.stationTitleAndCodes = [NSMutableArray arrayWithArray:staDetailArr];
}

- (NSString*)_getStationCode:(NSString*)stationName {
    
    stationName = [stationName stringByReplacingOccurrencesOfString:@"駅" withString:@""];
    NSDictionary *metroEkiDic = [self _dictionaryPlistDataWithFileName:@"lineEkiKeyValue"];

    NSLog(@"code >> %@", [metroEkiDic objectForKey:stationName]);
    return [metroEkiDic objectForKey:stationName];
}


// 역명을 넣으면 겹치는 노선을 검색해주 매소드
// 검색결과가 나온다면 같은 라인에 있다는 증거
// 라인별로 소요시간을 검색해서 반환하면 됨.
- (NSArray*)_searchEndStationWithStation:(NSString*)standardStaName endSta:(NSString*)endStaName {
    
    
    NSString *startStaEng = [self _getStationCode:standardStaName];
    NSString *endStaEng = [self _getStationCode:endStaName];

    
    NSMutableArray *startStaLineArr = [NSMutableArray new];
    NSMutableArray *endStaLineArr = [NSMutableArray new];
    
    // 1. 기존역의 전 노선을 가져옴
    // 2. 도착역의 전 노선을 가져옴

    NSDictionary *metroEkiDic = [self _jsonDataWithFileName:@"MetoroLine"];
    
    for (NSString *key in metroEkiDic){
        
        NSArray *lineArr = metroEkiDic[key];
        for (NSString *ekiCode in lineArr){

            NSString *temp = ((NSArray*)[ekiCode componentsSeparatedByString:@"."])[2];
            
            if ([temp isEqualToString:startStaEng]) {
                [startStaLineArr addObject:key];
            }
            
            if ([temp isEqualToString:endStaEng]) {
                [endStaLineArr addObject:key];
            }
            
        }
    }
    
    NSLog(@"============= startStaLineArr >> %@", startStaLineArr);
    NSLog(@"============= endStaLineArr >> %@", endStaLineArr);
    
    NSMutableArray *resultArr = [ NSMutableArray new];
    
    for (NSString *lineCode1 in startStaLineArr){
        
        for (NSString *lineCode2 in endStaLineArr){
            
            if ([lineCode1 isEqualToString:lineCode2]) {
                
                [resultArr addObject:lineCode1];
            }
        }
    }
    
    NSLog(@"============= resultArr >> %@", resultArr);
    return resultArr;
    
}

- (NSString*)_getStationEngName:(NSString*)stationFullCode {
    
    return ((NSArray*)[stationFullCode componentsSeparatedByString:@"."])[2];
}

- (NSArray*)_getLineInfoWithLine:(NSString*)lineCode station:(NSString*)stationEng {
    
    if ([stationEng isEqualToString:@""] || [lineCode isEqualToString:@""]) {
        return nil;
    }
    
    NSMutableArray *lines = [NSMutableArray new];
    
    NSDictionary *metroEkiDic = [self _jsonDataWithFileName:@"MetoroLine"];
    
    for (NSString *key in metroEkiDic){
        
        NSArray *lineArr = metroEkiDic[key]; // 노선을 하나씩 돌려봄.
        for (NSString *ekiCode in lineArr){
            
            NSString *temp = ((NSArray*)[ekiCode componentsSeparatedByString:@"."])[2];
            
            // 자신의 노선일 경우에는 넣지 않는다.
            if ([temp isEqualToString:stationEng] && [lineCode isEqualToString:lineCode]) {
                [lines addObject:key];
            }
        }
    }
    return lines;
    
}

- (NSArray*)_getLineInfo:(NSString*)stationEng {
    
    if ([stationEng isEqualToString:@""]) {
        return nil;
    }
    
    NSMutableArray *lines = [NSMutableArray new];
    
    NSDictionary *metroEkiDic = [self _jsonDataWithFileName:@"MetoroLine"];
    
    for (NSString *key in metroEkiDic){
        
        NSArray *lineArr = metroEkiDic[key]; // 노선을 하나씩 돌려봄.
        for (NSString *ekiCode in lineArr){
            
            NSString *temp = [self _getStationEngName:ekiCode];
            
            if ([stationEng isEqualToString:temp]) {
                // 해당 라인자체를 넣음.
                [lines addObject:@{key:metroEkiDic[key]}];
                break;
            }
        }
    }
    return lines;
}

- (NSArray*)_searchAllLineWithStation:(NSString*)startStaEng endStaName:(NSString*)endStaEng {
    
    NSMutableArray *resultArr = [NSMutableArray new];
    
    NSArray *stationArr = [self _getLineInfo:startStaEng];
    NSArray *endStaArr = [self _getLineInfo:endStaEng];

    for (NSDictionary *lineDic in stationArr){
        
        for(NSString *key in lineDic.allKeys){ // key : 라인이름 values : 라인별 역들..
            
            NSArray *stationArrInLine = lineDic[key];

            for (NSString *station in stationArrInLine){
                NSArray *tempStaLineArr = [self _getLineInfo:[self _getStationEngName:station]];
                
                for (NSString *lineCode in tempStaLineArr) {

                    if (![endStaArr containsObject:lineCode]) {

                        NSLog(@"================");
                        NSLog(@"Line : %@ || ==== Station : %@", lineCode, station);
                        [resultArr addObject:@[@{lineCode:station}]];
                         return resultArr;
                    }
                }
            }
            
        }
    }
    
    return resultArr;
}



// 같은 노선이 아닌 경우.
- (NSArray*)_searchEndStationWithStationinAllLine:(NSString*)standardStaName endSta:(NSString*)endStaName {
    
    
    NSString *startStaEng = [self _getStationCode:standardStaName];
    NSString *endStaEng = [self _getStationCode:endStaName];
    
    NSMutableArray *tempResult = [NSMutableArray new];
    NSArray *stationArr = [self _getLineInfo:startStaEng];
    
    for (NSDictionary *lineDic in stationArr){

     
        for(NSString *key in lineDic.allKeys){ // key : 라인이름 values : 라인별 역들..
            
            NSArray *stationArrInLine = lineDic[key];
            for (NSString *station in stationArrInLine){

//                NSLog(@"station: %@",station);
                NSArray *result = [self _searchAllLineWithStation:[self _getStationEngName:station] endStaName:endStaEng];

                if (result.count > 0) {

                    if (![tempResult containsObject:result]) {
                        [tempResult addObject:result];
                    }
                }
            }
        }
    }
    NSLog(@"========== result ==========: %@", tempResult);
    
    return tempResult;
}

- (float)_calculateTypeOne:(NSString*)lineCode startSta:(NSString*)startSta endSta:(NSString*)endSta type:(NSString*)type {
    

    if ([lineCode isEqualToString:@""] || [startSta isEqualToString:@""] || [endSta isEqualToString:@""]) {
        return 0.f;
    }
    
    NSString *startStaCode = [self _getStationCode:startSta];
    NSString *endStaCode = [self _getStationCode:endSta];

    NSArray *timeTable = self.spentTimeLine[lineCode];
    
    float totalSpentTime = 0.f;
    BOOL isReady = NO;
    for (NSDictionary *timeTableDic in timeTable){

        if ([timeTableDic[@"odpt:trainType"] isEqualToString:type]) {
            if (isReady) {
                totalSpentTime += ((NSString*)timeTableDic[@"odpt:necessaryTime"]).floatValue;
                NSLog(@"==========================================");
                NSLog(@"station name > %@",timeTableDic[@"odpt:fromStation"]);
                NSLog(@"spent time > %@",timeTableDic[@"odpt:necessaryTime"]);
                                                
            }
            
            NSString *tempStartEki = ((NSArray*)[timeTableDic[@"odpt:fromStation"] componentsSeparatedByString:@"."])[2];

            if ([startStaCode isEqualToString:tempStartEki]) {
                totalSpentTime += ((NSString*)timeTableDic[@"odpt:necessaryTime"]).floatValue;
                NSLog(@"startStaCode: %@",startStaCode);
                NSLog(@"==========================================");
                NSLog(@"station name > %@",timeTableDic[@"odpt:fromStation"]);
                NSLog(@"spent time > %@",timeTableDic[@"odpt:necessaryTime"]);

                isReady = YES;
            }
            
            NSString *tempEndEki = ((NSArray*)[timeTableDic[@"odpt:toStation"] componentsSeparatedByString:@"."])[2];
            
            if (isReady && [endStaCode isEqualToString:tempEndEki]) {
                NSLog(@"endStaCode: %@",endStaCode);
                NSLog(@"==========================================");
                NSLog(@"station name > %@",timeTableDic[@"odpt:toStation"]);
                NSLog(@"spent time > %@",timeTableDic[@"odpt:necessaryTime"]);

                isReady = NO;
                
                return totalSpentTime;
            }
            
        }
    }
    
    return 0.f;
}

#pragma mark - Public
- (NSArray*)calculateSpentTime:(NSString*)startSta endSta:(NSString*)endSta {

    NSMutableArray *resultArr = [NSMutableArray new];
    NSArray *sameLine = [self _searchEndStationWithStation:startSta endSta:endSta];

    if (sameLine.count > 0) {
        
        for (NSString *lineCode in sameLine){
            float spentTime = [self _calculateTypeOne:lineCode startSta:startSta endSta:endSta type:@"Local"];
            [resultArr addObject:@(spentTime)];
        }
        
        NSLog(@"resultArr > %@", resultArr);
        return resultArr;
    }
    
    return nil;
}


@end
