//
//  BaseViewController.m
//  Test
//
//  Created by 周周旗 on 2017/10/17.
//  Copyright © 2017年 ZQ. All rights reserved.
//

#define SCREEN_WIDTH ((([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortrait) || ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortraitUpsideDown)) ? [[UIScreen mainScreen] bounds].size.width : [[UIScreen mainScreen] bounds].size.height)
#define SCREEN_HEIGHT ((([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortrait) || ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortraitUpsideDown)) ? [[UIScreen mainScreen] bounds].size.height : [[UIScreen mainScreen] bounds].size.width)

#import "BaseViewController.h"

@interface BaseViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    int  currentIndex;
    int  lastIndex;
    int  pageNo;
    int  topBtnTag;
    
}
@property (nonatomic, strong)UITableView *tableView_Top;
@property (nonatomic, strong)UITableView *mTableView;
@property (nonatomic, strong)NSMutableArray *left_DataArr;
@property (nonatomic, strong)NSMutableArray *right_DataArr;
@property (nonatomic, strong)NSMutableArray *tableData;
@property (nonatomic, strong) UIView *mTableBaseView;
@property (nonatomic, assign) BOOL isShow;

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initSubViews];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initSubViews{
    _mTableView = [[UITableView alloc]initWithFrame:CGRectMake(0,  64 + _btn_One.bounds.size.height +15, SCREEN_WIDTH, SCREEN_HEIGHT - 79)];
    _mTableView.delegate = self;
    _mTableView.dataSource = self;
    _mTableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_mTableView];
    [self initWithData];
    [self initTapClick];
}

- (void)initWithData{
    _left_DataArr = [[NSMutableArray alloc]init];
    _right_DataArr = [[NSMutableArray alloc]init];
    _left_DataArr = [NSMutableArray arrayWithObjects:@"1",@"2",@"3",@"4",nil];
    _right_DataArr = [NSMutableArray arrayWithObjects:@"a",@"b",@"c",@"d",nil];
    _tableData = [NSMutableArray arrayWithObjects:@"a",@"b",@"c",@"d",nil];
}

- (void)initTapClick{
    [_btn_One addTarget:self action:@selector(ActionTapClick:) forControlEvents:UIControlEventTouchUpInside];
    [_btn_Two addTarget:self action:@selector(ActionTapClick:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}

/**
 *  TopBtn的点击事件
 */

- (void)ActionTapClick:(UIButton *)tapBtn{
    if (tapBtn.tag == 2000) {
        topBtnTag = 100;
        if (_isShow) {
            [self hideExtendedChooseView];
        }else{
            //            [self.left_DataArr removeAllObjects];
            //            [self.mTableArray addObjectsFromArray:self.hourceArray];
            [self.tableView_Top reloadData];
            [self showChooseListViewInSection:0 choosedIndex:0];
        }
        [self changeArrowStatus:0 button:self.btn_One image:self.arrow_L];
    }else{
        topBtnTag = 101;
        if (_isShow) {
            [self hideExtendedChooseView];
        }else{
            //            [self.mTableArray removeAllObjects];
            //            [self.mTableArray addObjectsFromArray:self.peopleArray];
            [self.tableView_Top reloadData];
            [self showChooseListViewInSection:0 choosedIndex:0];
        }
        [self changeArrowStatus:1 button:self.btn_Two image:self.arrow_R];
    }
}
//阴影背景点击
-(void)bgTappedAction:(UITapGestureRecognizer *)tap
{
    [self hideExtendedChooseView];
    if (topBtnTag == 100) {
        [self changeArrowStatus:0 button:self.btn_One image:self.arrow_L];
    }else if (topBtnTag == 101) {
        [self changeArrowStatus:1 button:self.btn_Two image:self.arrow_R];
    }
}
//展示下拉框（懒加载）
-(void)showChooseListViewInSection:(NSInteger)section choosedIndex:(NSInteger)index
{
    if(self.left_DataArr.count == 0 || self.left_DataArr == nil) return;
    if (!self.tableView_Top) {
        self.mTableBaseView = [[UIView alloc] initWithFrame:CGRectMake(0, 64+_btn_One.bounds.size.height, self.mTableView.bounds.size.width, self.mTableView.bounds.size.height+21+60)];
        self.mTableBaseView.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.5];
        UITapGestureRecognizer *bgTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bgTappedAction:)];
        [self.mTableBaseView addGestureRecognizer:bgTap];
        UILabel *lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.tableView_Top.bounds.size.width, 0.3)];
        [lineLabel setBackgroundColor:[UIColor blackColor]];
        self.tableView_Top = [[UITableView alloc] initWithFrame:CGRectMake(0, 64+self.btn_One.bounds.size.height, self.mTableView.bounds.size.width,self.left_DataArr.count*40) style:UITableViewStylePlain];  //240
        self.tableView_Top.tag = 200;
        self.tableView_Top.delegate = self;
        self.tableView_Top.dataSource = self;
        self.tableView_Top.backgroundColor = [UIColor clearColor];
        [self.tableView_Top addSubview:lineLabel];
        [self setExtraCellLineHidden:self.tableView_Top];
    }
    _isShow = YES;
    //修改tableview的frame
    int sectionWidth = self.mTableView.bounds.size.width;
    CGRect rect = self.tableView_Top.frame;
    rect.origin.x = sectionWidth *section;
    rect.size.width = sectionWidth;
    rect.size.height = 0;
    self.tableView_Top.frame = rect;
    [self.view addSubview:self.mTableBaseView];
    [self.view addSubview:self.tableView_Top];
    
    //动画设置位置
    rect .size.height = self.left_DataArr.count*40;    //240
    [UIView animateWithDuration:0.3 animations:^{
        self.mTableBaseView.alpha = 0.2;
        self.tableView_Top.alpha = 0.2;
        
        self.mTableBaseView.alpha = 1.0;
        self.tableView_Top.alpha = 1.0;
        self.tableView_Top.frame =  rect;
    }];
    [self.tableView_Top reloadData];
    
}
//隐藏下拉框
-  (void)hideExtendedChooseView{
    if (_isShow) {
        _isShow = NO;
        CGRect rect = self.tableView_Top.frame;
        rect.size.height = 0;
        [UIView animateWithDuration:0.3 animations:^{
            self.mTableBaseView.alpha = 1.0f;
            self.tableView_Top.alpha = 1.0f;
            
            self.mTableBaseView.alpha = 0.2f;
            self.tableView_Top.alpha = 0.2;
            
            self.tableView_Top.frame = rect;
        }completion:^(BOOL finished) {
            [self.tableView_Top removeFromSuperview];
            [self.mTableBaseView removeFromSuperview];
        }];
    }
}

- (void)changeArrowStatus:(int)index button:(UIButton *)button image:(UIImageView *)image {
    lastIndex = currentIndex;
    currentIndex = index;
    pageNo = 1;
    if(lastIndex != index) {
        button.selected = YES;
        switch (lastIndex) {
            case 0:
                self.btn_One.selected = NO;
                break;
                
            case 1:
                self.btn_Two.selected = NO;
                break;
            default:
                break;
        }
    }
    [self queryData];
}

- (void)queryData{
    
    void (^Block)(UIImageView *image, int angle) = ^(UIImageView *image, int angle){
        [UIView beginAnimations:@"ic_xiao xiangxia" context:nil];
        [UIView setAnimationDuration:0.3f];
        image.transform = CGAffineTransformMakeRotation(angle * (M_PI/-180.0));
        [UIView commitAnimations];
    };
    
    if(lastIndex != currentIndex) {
        
        switch (currentIndex) {
            case 0:
                if (!_isShow) {
                    Block(self.arrow_L, -360);
                    Block(self.arrow_R, -360);
                }else{
                    Block(self.arrow_L, 180);
                }
                break;
                
            case 1:{
                
                if (!_isShow) {
                    Block(self.arrow_R, -360);
                    Block(self.arrow_L, -360);
                }else{
                    Block(self.arrow_R, 180);
                }
            }
                break;
                
            default:
                break;
        }
    }else{
        switch (currentIndex) {
            case 0:
                if(!_isShow){
                    Block(self.arrow_L, -360);
                }else{
                    Block(self.arrow_L, 180);
                }
                break;
                
            case 1:{
                if(!_isShow) {
                    Block(self.arrow_R, -360);
                }else {
                    Block(self.arrow_R, (180));
                }
            }
                break;
                
            default:
                break;
        }
    }
}

#pragma - TableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView.tag == 200) {
        return self.left_DataArr.count;
    }
    return _tableData.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 200) {
        return 40;
    }
    return 70;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *imageName = nil;
    NSString *labelText = nil;
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"PERSONALCELL"];
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:15];
    }
    imageName = [_left_DataArr objectAtIndex:indexPath.row];
    labelText = [_left_DataArr objectAtIndex:indexPath.row];
    cell.textLabel.text = labelText;
    cell.imageView.image = [UIImage imageNamed:imageName];
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [_mTableView deselectRowAtIndexPath:indexPath animated:NO];
}


@end
