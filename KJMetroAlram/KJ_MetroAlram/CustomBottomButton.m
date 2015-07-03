//
//  CustomBottomButton.m
//  KJ_MetroAlram
//
//  Created by NoodleKim on 2014. 11. 2..
//  Copyright (c) 2014년 KimGiBong. All rights reserved.
//

#import "CustomBottomButton.h"

@interface CustomBottomButton ()

@end
@implementation CustomBottomButton

- (void)_init {
    
    [[UINib nibWithNibName:@"CustomBottomButton" bundle:nil] instantiateWithOwner:self options:nil];
    [self addSubview:_contentView];
 
    _buttonMode = ButtonModeNormal;
    
    {
        [self _setLongPressGesture];
    }
}

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        [self _init];
    }
    return self;
    
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        
        [self _init];
    }
    return self;
}

#pragma mark - Custom Accessors
- (void)setButtonMode:(ButtonMode)buttonMode {

    
    _buttonMode = buttonMode;
    
    [UIView animateWithDuration:0.25f animations:^{
        
        if (_buttonMode == ButtonModeDelete) {
            CGRect f = self.scrollActionView.frame;
            f.origin.y -= CGRectGetHeight(f)/2;
            self.scrollActionView.frame = f;
            
            self.titleLbl.alpha = 0.f;
            self.trashImageView.alpha = 1.f;
        }
        else {
            CGRect f = self.scrollActionView.frame;
            f.origin.y += CGRectGetHeight(f)/2;
            self.scrollActionView.frame = f;
            
            self.titleLbl.alpha = 1.f;
            self.trashImageView.alpha = 0.f;
        }
        
    } completion:^(BOOL finished) {
        [self.timer invalidate];
        self.timer = nil;
    }];

}

#pragma mark - Private

- (void)_setButtonFromTimer:(NSTimer*)timer {
    
    NSDictionary *mode = timer.userInfo;
    _buttonMode = ((NSString*)mode[@"buttonMode"]).intValue;
    
    [UIView animateWithDuration:0.25f animations:^{
        
        if (_buttonMode == ButtonModeDelete) {
            CGRect f = self.scrollActionView.frame;
            f.origin.y -= CGRectGetHeight(f)/2;
            self.scrollActionView.frame = f;
            
            self.titleLbl.alpha = 0.f;
            self.trashImageView.alpha = 1.f;
        }
        else {
            CGRect f = self.scrollActionView.frame;
            f.origin.y += CGRectGetHeight(f)/2;
            self.scrollActionView.frame = f;
            
            self.titleLbl.alpha = 1.f;
            self.trashImageView.alpha = 0.f;
        }
        
    } completion:^(BOOL finished) {
        [self.timer invalidate];
        self.timer = nil;
    }];
}

- (void)_setLongPressGesture {
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressdBottomButton:)];
    longPress.minimumPressDuration = 1.2f;
    [self.actionButton addGestureRecognizer:longPress];

}
- (void)longPressdBottomButton:(UIGestureRecognizer*)gesture {
    
    if ([self.titleLbl.text isEqualToString:@"未設定"]) {
        
        return;
    }
    
    [self.actionButton removeGestureRecognizer:gesture];
    
    [UIView animateWithDuration:0.25f animations:^{
        
        if (_buttonMode == ButtonModeNormal) {
            CGRect f = self.scrollActionView.frame;
            f.origin.y -= CGRectGetHeight(f)/2;
            self.scrollActionView.frame = f;
            
            self.titleLbl.alpha = 0.f;
            self.trashImageView.alpha = 1.f;
        }
        else {
            CGRect f = self.scrollActionView.frame;
            f.origin.y += CGRectGetHeight(f)/2;
            self.scrollActionView.frame = f;
            
            self.titleLbl.alpha = 1.f;
            self.trashImageView.alpha = 0.f;
        }
        
    } completion:^(BOOL finished) {
        
        if (_buttonMode == ButtonModeNormal) {
            _buttonMode = ButtonModeDelete;
            
            self.timer = [NSTimer scheduledTimerWithTimeInterval:3.f target:self selector:@selector(_setButtonFromTimer:) userInfo:@{@"buttonMode":[NSNumber numberWithInt:ButtonModeNormal]} repeats:NO];
        }
        else {
            _buttonMode = ButtonModeNormal;
        }
        [self _setLongPressGesture];
    }];
}

#pragma mark - Action
- (IBAction)tappedNormalAction:(id)sender {
    
//    NSLog(@"tappedNormalAction");
    if ([self.titleLbl.text isEqualToString:@"未設定"]) {
        
        return;
    }
    [self.delegate tappedBottomButton:self buttonMode:_buttonMode];
}

@end
