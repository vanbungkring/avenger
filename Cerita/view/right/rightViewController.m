//
//  rightViewController.m
//  Cerita
//
//  Created by Yazid Bustomi on 10/27/13.
//  Copyright (c) 2013 netra. All rights reserved.
//

#import "rightViewController.h"

@interface rightViewController ()

@end

@implementation rightViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
//        self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"slide-background"]];
        self.view.backgroundColor = [UIColor colorWithRed:0.188 green:0.188 blue:0.188 alpha:1];
        table = [[UITableView alloc]initWithFrame:CGRectMake(0, 40,270,self.view.frame.size.height)];
        table.bounces = NO;
        
        table.backgroundColor =[UIColor clearColor];
        table.separatorColor = [UIColor clearColor];
        table.delegate=self;
        table.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        table.dataSource = self;
        [self.view addSubview:table];
        // Custom initialization
    }
    return self;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UILabel *sectionHeader = [[UILabel alloc] initWithFrame:CGRectMake(22.5, 0, 300, 20)];
    sectionHeader.backgroundColor = [UIColor clearColor];
    sectionHeader.textAlignment = NSTextAlignmentLeft;
    sectionHeader.font = [UIFont boldSystemFontOfSize:18];
    sectionHeader.textColor = [UIColor whiteColor];
    sectionHeader.text = @"Categories";
    UIView *section_ = [[UIView alloc]initWithFrame:CGRectMake(0, 10, 300, 30)];
    section_.backgroundColor = [UIColor clearColor];
    [section_ addSubview:sectionHeader];
    return section_;
}



////tableview


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 25;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 57.5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 7;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    cell.backgroundColor = [UIColor clearColor];
}
// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    UILabel *text_title= [[UILabel alloc]initWithFrame:CGRectMake(95, 15, 300, 18)];
    text_title.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:16];
    text_title.textColor = [UIColor whiteColor];
    [cell.contentView addSubview:text_title];
    
    UIImageView *icon = [[UIImageView alloc]initWithFrame:CGRectMake(47.5, 7, 32, 32)];
    [cell.contentView addSubview:icon];
    switch (indexPath.row) {
        case 0:
            text_title.text = @"Home";
            icon.image= [UIImage imageNamed:@"home"];
            break;
            
        case 1:
            text_title.text = @"Puisi";
            icon.image= [UIImage imageNamed:@"music"];
            break;
            
        case 2:
            text_title.text = @"Cerpen";
            icon.image= [UIImage imageNamed:@"movie"];
            break;
            
        case 3:
            text_title.text = @"Sajak";
            icon.image= [UIImage imageNamed:@"fashion"];
            break;
            
        case 4:
            text_title.text = @"Novel";
            icon.image= [UIImage imageNamed:@"event"];
            break;
            
        case 5:
            text_title.text = @"Dongeng";
            icon.image= [UIImage imageNamed:@"place"];
            break;
        case 6:
            text_title.text = @"Pantun";
            icon.image= [UIImage imageNamed:@"place"];
            break;
            
    }
    UIView *customColorView = [[UIView alloc] init];
    customColorView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"cell"]];
    cell.selectedBackgroundView =  customColorView;
    // Configure the cell...
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%d",indexPath.row] forKey:@"selected"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    switch (indexPath.row) {
        case 0:
            [beetlebox setCenter:@"ceritaViewController" title:@"Cerita" cat:@""];
            break;
        case 1:
            [beetlebox setCenter:@"cerita_CategoryViewController" title:@"Music" cat:@"27"];
            
            break;
        case 2:
            [beetlebox setCenter:@"cerita_CategoryViewController" title:@"Movie" cat:@"28"];
            break;
            
        case 3:
            [beetlebox setCenter:@"cerita_CategoryViewController" title:@"Fashion" cat:@"34"];
            break;
        case 4:
            [beetlebox setCenter:@"cerita_CategoryViewController" title:@"Event" cat:@"89"];
            break;
        case 5:
            [beetlebox setCenter:@"cerita_CategoryViewController" title:@"Tech" cat:@"109"];
            break;
        case 6:
            [beetlebox setCenter:@"cerita_CategoryViewController" title:@"Tech" cat:@"128"];
            break;
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"selected"] != nil) {
        NSIndexPath *indexPath=[NSIndexPath indexPathForRow:[[[NSUserDefaults standardUserDefaults] stringForKey:@"selected"]intValue] inSection:0];
        [table selectRowAtIndexPath:indexPath animated:YES  scrollPosition:UITableViewScrollPositionBottom];
        
        
    }
    else{
        
        NSIndexPath *indexPath=[NSIndexPath indexPathForRow:0 inSection:0];
        [table selectRowAtIndexPath:indexPath animated:YES  scrollPosition:UITableViewScrollPositionBottom];
        [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"selected"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
