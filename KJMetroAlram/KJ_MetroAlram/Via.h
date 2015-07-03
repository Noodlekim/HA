//
//  Via.h
//  KJ_MetroAlram
//
//  Created by NoodleKim on 2014. 11. 7..
//  Copyright (c) 2014년 KimGiBong. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef enum {
    subwayTypeLocal = 20
    , subwayTypeExpress
    , subwayTypeRapid
    
} subwayType;

@interface Via : NSObject

@property (nonatomic) NSString *code;
@property (nonatomic) NSString *title;
@property (nonatomic) NSString *spentTime;
@property (nonatomic) NSString *startSta;
@property (nonatomic) NSString *endSta;
@property (nonatomic) subwayType subwayType;

@end
