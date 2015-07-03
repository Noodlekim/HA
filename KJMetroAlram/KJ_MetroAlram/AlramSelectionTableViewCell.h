//
//  AlramSelectionTableViewCell.h
//  KJ_MetroAlram
//
//  Created by KimGiBong on 2014. 10. 26..
//  Copyright (c) 2014년 KimGiBong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AlramSelectionTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@property (weak, nonatomic) IBOutlet UIButton *selectionButton;
@property (weak, nonatomic) IBOutlet UIButton *bellButton;

@property (strong, nonatomic) NSString *mp3Filename;

- (IBAction)tappedSelectionButton:(id)sender;
@end
