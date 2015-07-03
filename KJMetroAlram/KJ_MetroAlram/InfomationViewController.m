//
//  InfomationViewController.m
//  KJ_MetroAlram
//
//  Created by NoodleKim on 2014/10/28.
//  Copyright (c) 2014年 KimGiBong. All rights reserved.
//

#import "InfomationViewController.h"
#import "KJMLabel.h"

#define IS_4_INCH_LESS (CGRectGetHeight([[UIScreen mainScreen] bounds]) < 568)?YES:NO

@interface InfomationViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *turnAImage;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet KJMLabel *engineerLbl;
@property (weak, nonatomic) IBOutlet KJMLabel *kimgibonLbl;
@property (weak, nonatomic) IBOutlet KJMLabel *leejunhaLbl;
@property (weak, nonatomic) IBOutlet KJMLabel *designerLbl;
@property (weak, nonatomic) IBOutlet KJMLabel *yokoLbl;
@property (weak, nonatomic) IBOutlet KJMLabel *voiceLbl;
@property (weak, nonatomic) IBOutlet UIView *amitaroView;
@property (weak, nonatomic) IBOutlet UIImageView *background;
@property (weak, nonatomic) IBOutlet UIView *bottomView;

@end

@implementation InfomationViewController

#pragma mark - Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    {
     
        if (IS_4_INCH_LESS) {

            self.view.frame = [UIScreen mainScreen].bounds;
            
            CGRect f = self.turnAImage.frame;
            f.origin.y = 87.f;
            self.turnAImage.frame = f;
            
            f = self.contentView.frame;
            f.origin.y = 150.f;
            self.contentView.frame = f;
            
            f = self.designerLbl.frame;
            f.origin.y = 90.f;
            self.designerLbl.frame = f;
            
            f = self.yokoLbl.frame;
            f.origin.y = CGRectGetMinY(self.designerLbl.frame) + CGRectGetHeight(self.designerLbl.frame);
            self.yokoLbl.frame = f;
            
            f = self.voiceLbl.frame;
            f.origin.y = 160.f;
            self.voiceLbl.frame = f;
            
            f = self.amitaroView.frame;
            f.origin.y = CGRectGetMinY(self.voiceLbl.frame) + CGRectGetHeight(self.voiceLbl.frame);
            self.amitaroView.frame = f;
            
            f = self.background.frame;
            f.origin.y = -20;
            self.background.frame = f;
            
            f = self.turnAImage.frame;
            f.origin.y = 65.f;
            self.turnAImage.frame = f;
            
            f = self.bottomView.frame;
            f.origin.y = [[UIScreen mainScreen] bounds].size.height - CGRectGetHeight(f);
            self.bottomView.frame = f;
        }
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLayoutSubviews {
    
    [super viewDidLayoutSubviews];
    
    if (IS_4_INCH_LESS) {
        self.background.contentMode = UIViewContentModeTop;
    }
    else {
        self.background.contentMode = UIViewContentModeScaleToFill;
    }
}

- (void)turnAanimation {
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.35f * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        
        [self _turnAturnAnimation];
    });
}

- (void)viewDidAppear:(BOOL)animated {

    [self turnAanimation];
}

#pragma mark - Private
- (void)_turnAturnAnimation{
    
    self.turnAImage.transform = CGAffineTransformMakeRotation(0);
    
    [UIView animateWithDuration:0.65f animations:^{
        self.turnAImage.transform = CGAffineTransformMakeRotation(2*M_PI*180/360.0-0.000001);
    } completion:nil];
}

#pragma mark - Action
- (IBAction)tappedColoseButton:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)tappedVoicerURLButton:(id)sender {
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www14.big.or.jp/~amiami/happy/"]];
}

@end
