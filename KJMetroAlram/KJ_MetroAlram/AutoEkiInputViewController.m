//
//  AutoEkiInputViewController.m
//  KJ_MetroAlram
//
//  Created by NoodleKim on 2014. 11. 3..
//  Copyright (c) 2014년 KimGiBong. All rights reserved.
//

#import "AutoEkiInputViewController.h"


@interface AutoEkiInputViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic) NSMutableDictionary *hiraDic;
@property (nonatomic) NSMutableDictionary *engDic;
@property (nonatomic) NSMutableDictionary *kanjiDic;

@property (nonatomic) NSArray *ekiArr;
@property (nonatomic) NSArray *hiraArr;
@property (nonatomic) NSArray *engArr;

@property (nonatomic) NSMutableArray *searchResult;

@end

@implementation AutoEkiInputViewController
- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

+ (AutoEkiInputViewController*)shareInstance {
    
    static dispatch_once_t pred = 0;
    __strong static AutoEkiInputViewController *_instance = nil;
    
    dispatch_once(&pred, ^{
        _instance = [[AutoEkiInputViewController alloc] init];
        //        _instance.searchResult = @[];
    });
    return _instance;
}

#pragma mark - Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_checkAutoEkiName) name:UITextFieldTextDidChangeNotification object:nil];
    }
    
    {
        NSString *ekiNameSource = [[NSBundle mainBundle] pathForResource:@"EkiName" ofType:@"txt"];
        NSString *ekiNameString = [NSString stringWithContentsOfFile:ekiNameSource encoding:NSUTF8StringEncoding error:nil];
        
        NSString *hiraNameSource = [[NSBundle mainBundle] pathForResource:@"HiraName" ofType:@"txt"];
        NSString *hiraNameString = [NSString stringWithContentsOfFile:hiraNameSource encoding:NSUTF8StringEncoding error:nil];
        
        NSString *engNameSource = [[NSBundle mainBundle] pathForResource:@"EngName" ofType:@"txt"];
        NSString *engNameString = [NSString stringWithContentsOfFile:engNameSource encoding:NSUTF8StringEncoding error:nil];
        
        self.ekiArr = [ekiNameString componentsSeparatedByString:@"\n"];
        self.hiraArr = [hiraNameString componentsSeparatedByString:@"\n"];
        self.engArr = [engNameString componentsSeparatedByString:@"\n"];
        
        
        
        self.hiraDic = [NSMutableDictionary new];
        self.engDic = [NSMutableDictionary new];
        self.kanjiDic = [NSMutableDictionary new];
        
        for (int i = 0; i <= (_ekiArr.count - 1); i++) {
            [_hiraDic setObject:[_ekiArr objectAtIndex:i] forKey:[_hiraArr objectAtIndex:i]];
            [_engDic setObject:[_ekiArr objectAtIndex:i] forKey:[_engArr objectAtIndex:i]];
            [_kanjiDic setObject:[_ekiArr objectAtIndex:i] forKey:[_ekiArr objectAtIndex:i]];
            
        }
        
        /*
         Create a mutable array to contain products for the search results table.
         */
        self.searchResult = [NSMutableArray arrayWithCapacity:([_ekiArr count]-1)];
    }
    
    {
        UINib *nib = [UINib nibWithNibName:@"EkiResultTableViewCell" bundle:nil];
        [self.tableView registerNib:nib forCellReuseIdentifier:@"EkiresultCell"];
        
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    [self.searchField setText:@""];
    [self.searchField becomeFirstResponder];
    
    [self.searchResult removeAllObjects];
    [self.tableView reloadData];
    
    self.titleLbl.textAlignment = NSTextAlignmentCenter;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)_checkAutoEkiName {
    if( [self.searchField.text length] != 0 )
    {        // インクリメンタル検索
        [self.searchResult removeAllObjects]; // First clear the filtered array.
        //반복(자료 카운트수만큼)
        //검색옵션 지정
        //검색범위 지정(각 자료 글자수부터)
        //검색범위 지정(입력값 걸릴때까지)
        //만약 걸리는 값이 있으면 searchResult에 넣고 리로드
        for (int i = 0; i <= (_ekiArr.count - 1); i++) {
            NSUInteger searchOptions = NSCaseInsensitiveSearch | NSDiacriticInsensitiveSearch;
            NSString *hiraMaxRangeString = (NSString*)[_hiraArr objectAtIndex:i];
            NSString *engMaxRangeString = (NSString*)[_engArr objectAtIndex:i];
            NSString *ekiMaxRangeString = (NSString*)[_ekiArr objectAtIndex:i];
            
            NSRange hiraNameRange = NSMakeRange(0, hiraMaxRangeString.length);
            NSRange engNameRange = NSMakeRange(0, engMaxRangeString.length);
            NSRange kanjiNameRange = NSMakeRange(0, ekiMaxRangeString.length);
            
            NSRange foundHiraRange = [hiraMaxRangeString rangeOfString:self.searchField.text options:searchOptions range:hiraNameRange];
            NSRange foundEngRange = [engMaxRangeString rangeOfString:self.searchField.text options:searchOptions range:engNameRange];
            NSRange foundKanjiRange = [ekiMaxRangeString rangeOfString:self.searchField.text options:searchOptions range:kanjiNameRange];
            
            
            if (foundHiraRange.length > 0)
            {
                if (foundHiraRange.location == 0) {
                    [self.searchResult addObject:[_hiraDic objectForKey:hiraMaxRangeString]];
                }
            }
            else if (foundEngRange.length > 0)
            {
                if (foundEngRange.location == 0) {
                    [self.searchResult addObject:[_engDic objectForKey:engMaxRangeString]];
                }
            }
            else if (foundKanjiRange.length > 0)
            {
                if (foundKanjiRange.location == 0) {
                    [self.searchResult addObject:[_kanjiDic objectForKey:ekiMaxRangeString]];
                }
            }
            
        }
        [self.tableView reloadData];
    }
    
}

#pragma mark - Action
- (IBAction)tappedCloseButton:(id)sender {
    
    if (self.completeEkiName) {
        self.completeEkiName(@"");
    }
    
    
    [UIView animateWithDuration:0.25f animations:^{
        [self.searchField resignFirstResponder];
        self.view.alpha = 0.f;
    } completion:^(BOOL finished) {
        [self.view removeFromSuperview];
        [self removeFromParentViewController];
    }];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.searchField resignFirstResponder];
    return YES;
}

#pragma mark - UISearchBarDelegate
- (BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    return YES;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    
    //    NSLog(@"searchBar 2: %@", searchText);
}

#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return self.searchResult.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == self.searchResult.count -1) {
        return 39.f;
    }
    else {
        return 52.f;
    }
    
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"EkiresultCell";
    EkiResultTableViewCell *cell = (EkiResultTableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[EkiResultTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.ekiName = [NSString stringWithFormat:@"%@駅", self.searchResult[indexPath.row]];
    cell.bottomVerticalLIne.hidden = (indexPath.row == self.searchResult.count -1);
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
    
    if (self.completeEkiName) {
        NSString *ekiName = [NSString stringWithFormat:@"%@駅", self.searchResult[indexPath.row]];
        self.completeEkiName(ekiName);
        
        [UIView animateWithDuration:0.25f animations:^{
            [self.searchField resignFirstResponder];
            self.view.alpha = 0.f;
        } completion:^(BOOL finished) {
            [self.view removeFromSuperview];
            [self removeFromParentViewController];
        }];
    }
}

@end
