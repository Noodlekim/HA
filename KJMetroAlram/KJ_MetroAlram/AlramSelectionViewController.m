//
//  AlramSelectionViewController.m
//  KJ_MetroAlram
//
//  Created by KimGiBong on 2014. 10. 26..
//  Copyright (c) 2014년 KimGiBong. All rights reserved.
//

#import "AlramSelectionViewController.h"
#import "AlramSelectionTableViewCell.h"
#import "AlramSelectionLastTableViewCell.h"

#import "SEManager.h"

@interface AlramSelectionViewController ()

@property (nonatomic) NSString *selectedFileName;
@property (nonatomic) NSArray *alramData;
@property (nonatomic) IBOutlet UITableView *tableView;
@end

@implementation AlramSelectionViewController

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

+ (AlramSelectionViewController*)shareInstance {
    
    static dispatch_once_t pred = 0;
    __strong static AlramSelectionViewController *_instance = nil;
    
    dispatch_once(&pred, ^{
        _instance = [[AlramSelectionViewController alloc] init];
    });
    return _instance;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];

    if (self) {
        self.alramData = [SEManager sharedManager].alramFileArr;
        
        CGRect f = self.view.frame;
        f.size = [UIScreen mainScreen].bounds.size;
        self.view.frame = f;
    }
    return self;
}

#pragma mark - Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectedBell:) name:@"SELECTEC_BELL" object:nil];

        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tappedCloseAlramSelectionView:) name:@"CLOSE_BELLVIEW" object:nil];

        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tappedOKAlramSelectionView:) name:@"SELECTED_BELL" object:nil];
        
    }
    
    {
        UINib *nibOne = [UINib nibWithNibName:@"AlramSelectionTableViewCell" bundle:nil];
        [_tableView registerNib:nibOne forCellReuseIdentifier:@"NormalCell"];
        
        UINib *nibTwo = [UINib nibWithNibName:@"AlramSelectionLastTableViewCell" bundle:nil];
        [_tableView registerNib:nibTwo forCellReuseIdentifier:@"LastCell"];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
    self.currentBellName = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return self.alramData.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
 
    if (indexPath.row != self.alramData.count -1) {
        
        return 58.f;
    }
    else {
        
        return 80.f;
    }
    
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row != self.alramData.count -1) {
        
        static NSString *CellIdentifier = @"NormalCell";
        AlramSelectionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[AlramSelectionTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        // Configure the cell...

        cell.mp3Filename = self.alramData[indexPath.row];
        
        if ([cell.mp3Filename isEqualToString:self.currentBellName]) {
            cell.selectionButton.selected = YES;
            self.selectedFileName = [self.currentBellName stringByReplacingOccurrencesOfString:@".mp3" withString:@""];
        }
        else {
            cell.selectionButton.selected = NO;
        }

        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;

    }
    else {
        
        static NSString *CellIdentifier = @"LastCell";
        AlramSelectionLastTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[AlramSelectionLastTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        // Configure the cell...

        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
    
    AlramSelectionTableViewCell *cell = (AlramSelectionTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
    if ([cell isKindOfClass:[AlramSelectionTableViewCell class]]) {
        [cell tappedSelectionButton:cell.selectionButton];
    }
}

#pragma mark - Action
- (IBAction)tappedCloseAlramSelectionView:(id)sender {
    
    [UIView animateWithDuration:0.25f animations:^{
        
        self.view.alpha = 0.f;
        
    } completion:^(BOOL finished) {
        
        [self.view removeFromSuperview];
        [self removeFromParentViewController];
    }];
}

- (void)selectedBell:(NSNotification*)notification {
    
    NSString *mp3FileName = notification.object;
    [self resetButton:mp3FileName];
}

- (void)resetButton:(NSString*)mp3Filename {
    
    if (![mp3Filename isEqualToString:@""]) {
        self.selectedFileName = mp3Filename;
        
    }
    NSArray* cells = [self.tableView visibleCells];
    
    for (UITableViewCell *cell in cells){
        
        if ([cell isKindOfClass:[AlramSelectionTableViewCell class]]) {
            
            if (![((AlramSelectionTableViewCell*)cell).titleLbl.text isEqualToString:mp3Filename]) {
                ((AlramSelectionTableViewCell*)cell).selectionButton.selected = NO;
            }
        }
    }
}

- (void)tappedOKAlramSelectionView:(NSNotification*)notification {
    
    if (![self.selectedFileName isEqualToString:@""]) {
        [[NSUserDefaults standardUserDefaults] setObject:self.selectedFileName forKey:@"ALRAM"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SET_OVER_BELL" object:self.selectedFileName];
    
    [self tappedCloseAlramSelectionView:nil];
}
@end
