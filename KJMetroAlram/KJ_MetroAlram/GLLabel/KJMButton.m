//
//  KJMButton.m
//  GoodLuck
//
//  Created by NoodleKim on 2014/02/11.
//  Copyright (c) 2014年 NoodleKim. All rights reserved.
//

#import "KJMButton.h"

@implementation KJMButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.titleLabel.font = [UIFont fontWithName:@"mplus-1p-regular"
                                               size:self.titleLabel.font.pointSize];
    }
    return self;
}

- (void)awakeFromNib {
    
    [super awakeFromNib];
    self.titleLabel.font = [UIFont fontWithName:@"mplus-1p-regular"
                                           size:self.titleLabel.font.pointSize];
}

@end
