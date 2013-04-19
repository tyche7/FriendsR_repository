//
//  AgeListViewController.m
//  StreamTest
//
//  Created by Naehee Kim on 3/13/13.
//
//

#import "AgeListViewController.h"

@interface AgeListViewController ()

@end


@implementation AgeListViewController

@synthesize ageLabel, age, selectedRow, ageTableView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"Age Range";
    
    self.selectedRow = -1; //initialize as -1
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    NSLog(@"reload table");
    [self.ageTableView reloadData];
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    // Return the number of rows in the section.
    return 6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  
    
    if (cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
     NSLog(@"check if this cell is selected");
    // Configure the cell...
    
     NSLog(@"selected row:%d", selectedRow);
      NSLog(@"indexPath row:%d", indexPath.row);
    if (indexPath.row == selectedRow) {
       
      
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }else{
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    cell.textLabel.font = [UIFont systemFontOfSize:13];
    cell.textLabel.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
    cell.textLabel.lineBreakMode = UILineBreakModeTailTruncation;
    cell.textLabel.clipsToBounds = YES;
    
    cell.detailTextLabel.font = [UIFont systemFontOfSize:12];
    cell.detailTextLabel.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
    cell.detailTextLabel.textColor = [UIColor colorWithRed:0.4
                                                     green:0.6
                                                      blue:0.8
                                                     alpha:1];
    cell.detailTextLabel.lineBreakMode = UILineBreakModeTailTruncation;
    cell.detailTextLabel.clipsToBounds = YES;

    
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = @"Newborn";
            cell.detailTextLabel.text =@"0-3 months";
            
            break;
            
        case 1:
            cell.textLabel.text = @"Infant";
            cell.detailTextLabel.text = @"3 months - 1 year";
            break;
            
        case 2:
            cell.textLabel.text = @"Toddler";
            cell.detailTextLabel.text = @" 1 - 4 years";
            break;
            
        case 3:
            cell.textLabel.text = @"Kid";
            cell.detailTextLabel.text = @"4 years - ";
            break;
        case 4:
            cell.textLabel.text = @"All Ages";
            break;
        case 5:
            cell.textLabel.text = @"Maternity";
            cell.detailTextLabel.text = @"For Preparing Mothers";
            break;
            
        default:
            break;
    }
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  
    UITableViewCell* cell= [tableView cellForRowAtIndexPath:indexPath];
    
    selectedRow = indexPath.row;
    
    NSLog(@"selected row:%d",selectedRow);

    self.ageLabel = [NSString stringWithString:cell.textLabel.text];
    NSLog(@"in agelistview: agelabel  = %@", self.ageLabel);
    self.age = indexPath.row;

    
    [self.delegate setAge:age withLabel:ageLabel];
    
    
    
}

@end
