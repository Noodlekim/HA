//
//  GLLabel.m
//  GoodLuck
//
//  Created by NoodleKim on 2014/02/11.
//  Copyright (c) 2014年 NoodleKim. All rights reserved.
//

#import "KJMLabel.h"

@implementation KJMLabel

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        self.font = [UIFont fontWithName:@"mplus-1p-regular"
                                    size:self.font.pointSize];


    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.font = [UIFont fontWithName:@"mplus-1p-regular"
                                size:self.font.pointSize];

}
@end
