//
//  CalendarView.h
//  BoxOfficeStatistics
//
//  Created by LNN on 14-9-25.
//  Copyright (c) 2014年 com.Alice. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CalendarDelegate <NSObject>

@optional

-(void)chooseDate:(NSDate *)selectedDate;

@end
@interface CalendarView : UIView
{
    NSInteger _selectedDate;
    NSArray *_weekNames;
    NSCalendar *gregorian;
    NSInteger _selectedMonth;
    NSInteger _selectedYear;
}

@property (strong,nonatomic) UILabel *timeShowL;
@property (nonatomic,strong) NSDate *calendarDate;
@property (nonatomic,weak) id<CalendarDelegate> delegate;

@end
