//
//  ViewController.m
//  CalendarDemo
//
//  Created by LIAN on 16/3/2.
//  Copyright © 2016年 com.Alice. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

@synthesize calendar = _calendar;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self buildCalendarStage];
}

-(void)buildCalendarStage
{
    NSDateFormatter *dateForm = [[NSDateFormatter alloc]init];
    dateForm.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSString *dateStr = [dateForm stringFromDate:[NSDate date]];
    NSLog(@"test datestr is  %@",dateStr);
    
    [dateForm setTimeZone:[NSTimeZone localTimeZone]];
    NSDate *date = [dateForm dateFromString:dateStr];
    
//    NSDate *date = [NSDate date];
     NSLog(@"chose the date is %@",date);
    
    _calendar = [[CalendarView alloc]initWithFrame:CGRectMake(20, 50, [UIScreen mainScreen].bounds.size.width-40, 400)];
    _calendar.delegate = self;
    _calendar.calendarDate = date;
    [self.view addSubview:_calendar];
    
}
-(void)chooseDate:(NSDate *)selectedDate
{
    NSLog(@"chose the date is %@",selectedDate);

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
