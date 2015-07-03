//
//  AlramSelectionLastTableViewCell.m
//  KJ_MetroAlram
//
//  Created by KimGiBong on 2014. 10. 26..
//  Copyright (c) 2014년 KimGiBong. All rights reserved.
//

#import "AlramSelectionLastTableViewCell.h"

@implementation AlramSelectionLastTableViewCell

- (void)awakeFromNib {
    // Initialization code
    
    CGRect f = self.frame;
    f.size.width = [UIScreen mainScreen].bounds.size.width;
    self.frame = f;

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark Action
- (IBAction)tappedCloseButton:(id)sender {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"CLOSE_BELLVIEW" object:nil];
}

- (IBAction)tappedOKButton:(id)sender {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SELECTED_BELL" object:nil];
}

@end
