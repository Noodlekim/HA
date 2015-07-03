//
//  EkiResultTableViewCell.h
//  KJ_MetroAlram
//
//  Created by KimGiBong on 2014. 11. 3..
//  Copyright (c) 2014년 KimGiBong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EkiResultTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *mainContentView;
@property (weak, nonatomic) IBOutlet UILabel *ekiLbl;
@property (weak, nonatomic) IBOutlet UIImageView *ekiNameWakuImage;
@property (weak, nonatomic) IBOutlet UIImageView *bottomVerticalLIne;
@property (nonatomic) NSString *ekiName;
@end
