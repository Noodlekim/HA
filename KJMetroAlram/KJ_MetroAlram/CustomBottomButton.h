//
//  CustomBottomButton.h
//  KJ_MetroAlram
//
//  Created by NoodleKim on 2014. 11. 2..
//  Copyright (c) 2014년 KimGiBong. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    ButtonModeNormal = 10,
    ButtonModeDelete = 11
} ButtonMode;


@protocol CustomBottomButtonDelegate;
@interface CustomBottomButton : UIView

@property (nonatomic) ButtonMode buttonMode;

@property (assign, nonatomic) IBOutlet id <CustomBottomButtonDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIView *scrollActionView;
@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@property (weak, nonatomic) IBOutlet UIImageView *trashImageView;
@property (weak, nonatomic) IBOutlet UIButton *actionButton;
@property (nonatomic) NSTimer *timer;
@end

@protocol CustomBottomButtonDelegate <NSObject>

- (void)tappedBottomButton:(CustomBottomButton*)button buttonMode:(ButtonMode)buttonMode;

@end