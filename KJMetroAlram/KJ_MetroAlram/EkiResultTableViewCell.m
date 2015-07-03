//
//  EkiResultTableViewCell.m
//  KJ_MetroAlram
//
//  Created by KimGiBong on 2014. 11. 3..
//  Copyright (c) 2014년 KimGiBong. All rights reserved.
//

#import "EkiResultTableViewCell.h"

@implementation EkiResultTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - Custom Accessors
- (void)setEkiName:(NSString *)ekiName {
    
    _ekiLbl.text = _ekiName = ekiName;
    
    UIFont *font = [UIFont fontWithName:@"mplus-1p-regular" size:self.ekiLbl.font.pointSize];
    CGSize size = [_ekiName sizeWithFont:font constrainedToSize:CGSizeMake(260.f, 39.f) lineBreakMode:self.ekiLbl.lineBreakMode];
    
    CGRect f = self.ekiLbl.frame;
    f.size.width = size.width + 27.f;
    f.origin.x = (260.f - f.size.width)/2;
    self.ekiLbl.frame = f;
    
    f = self.ekiNameWakuImage.frame;
    f.origin.x = CGRectGetMinX(self.ekiLbl.frame) - 1.f;
    f.size.width = CGRectGetWidth(self.ekiLbl.frame);
    self.ekiNameWakuImage.frame = f;
    
    
}
@end
