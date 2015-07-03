//
//  AlramSelectionTableViewCell.m
//  KJ_MetroAlram
//
//  Created by KimGiBong on 2014. 10. 26..
//  Copyright (c) 2014년 KimGiBong. All rights reserved.
//

#import "AlramSelectionTableViewCell.h"
#import "SEManager.h"

@implementation AlramSelectionTableViewCell

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

#pragma mark - Custom Accessors
- (void)setMp3Filename:(NSString *)mp3Filename {
    
    _mp3Filename = mp3Filename;
    
    self.titleLbl.text = [mp3Filename stringByReplacingOccurrencesOfString:@".mp3" withString:@""];
    
    NSString *selectedFileName = [[NSUserDefaults standardUserDefaults] objectForKey:@"ALRAM"];
    if ([mp3Filename isEqualToString:selectedFileName]) {
        
        self.selectionButton.selected = !self.selectionButton.selected;
    }
    
    self.bellButton.hidden = [_mp3Filename isEqualToString:@"音なし.mp3"];
}

#pragma mark - Action
- (IBAction)tappedBellButton:(id)sender {
    
    self.bellButton.selected = YES;
    [[SEManager sharedManager] playSound:_mp3Filename];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1.0f * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        self.bellButton.selected = NO;
    });
    
}
- (IBAction)tappedSelectionButton:(id)sender {
    
    UIButton *button = (UIButton*)sender;
    if (button.selected == NO || self.bellButton.selected == NO) {
        button.selected = YES;
        self.bellButton.selected = YES;
        [[SEManager sharedManager] playSound:_mp3Filename];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1.0f * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            self.bellButton.selected = NO;
        });
        [[NSNotificationCenter defaultCenter] postNotificationName:@"SELECTEC_BELL" object:self.titleLbl.text];
    }
}

@end
