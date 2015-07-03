//
//  KJMTextField.m
//  KJ_MetroAlram
//
//  Created by NoodleKim on 2014. 11. 8..
//  Copyright (c) 2014년 KimGiBong. All rights reserved.
//

#import "KJMTextField.h"

@implementation KJMTextField

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

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
