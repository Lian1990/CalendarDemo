//
//  CalendarView.m
//  BoxOfficeStatistics
//
//  Created by LNN on 14-9-25.
//  Copyright (c) 2014年 com.Alice. All rights reserved.
//

#import "CalendarView.h"

@implementation CalendarView
@synthesize timeShowL = _timeShowL;

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor whiteColor];
        gregorian = [NSCalendar currentCalendar];
        
        NSDateComponents *components = [gregorian components:(NSCalendarUnitEra | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:[NSDate date]];
        _selectedMonth = components.month;
        _selectedYear = components.year;
         _selectedDate  =components.day;
    }
    return self;
}
- (void)buildTitleView
{
    // === 表头按钮
    UIButton *lefty = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    lefty.frame = CGRectMake(20, 5, 30, 40);
    [lefty setTitle:@"-年" forState:UIControlStateNormal];
    [lefty addTarget:self action:@selector(goLefty) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:lefty];
    
    UIButton *left = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    left.frame = CGRectMake(60, 5, 30, 40);
    [left setTitle:@"-月" forState:UIControlStateNormal];
    [left addTarget:self action:@selector(goLeft) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:left];
    
    UIButton *right = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    right.frame = CGRectMake(self.bounds.size.width-80, 5, 30, 40);
    [right setTitle:@"+月" forState:UIControlStateNormal];
    [right addTarget:self action:@selector(goRight) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:right];
    
    UIButton *righty = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    righty.frame = CGRectMake(self.bounds.size.width-40, 5, 30, 40);
    [righty setTitle:@"+年" forState:UIControlStateNormal];
    [righty addTarget:self action:@selector(goRighty) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:righty];
    
    // === 表头
    _timeShowL = [[UILabel alloc]initWithFrame:CGRectMake(100,5, 100, 40)];
    _timeShowL.textAlignment = NSTextAlignmentCenter;
    _timeShowL.center = CGPointMake(self.bounds.size.width/2, 5);
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"MM yyyy dd"];
    NSString *dateString = [format stringFromDate:self.calendarDate];
    [_timeShowL setText:dateString];
    [_timeShowL setFont:[UIFont fontWithName:@"Helvetica-Bold" size:15.0f]];
    [_timeShowL setTextColor:[UIColor blueColor]];
    [self addSubview:_timeShowL];
}
- (void)drawRect:(CGRect)rect
{
    // === 排列日期
    [self setCalendarParameters];
    [self buildTitleView];
    _weekNames = @[@"日",@"一",@"二",@"三",@"四",@"五",@"六"];
    NSDateComponents *components = [gregorian components:(NSCalendarUnitEra | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:self.calendarDate];
   
    components.day = 2;
    NSDate *firstDayOfMonth = [gregorian dateFromComponents:components];
    NSDateComponents *comps = [gregorian components:NSCalendarUnitWeekday fromDate:firstDayOfMonth];
    NSInteger weekday = [comps weekday];
//          NSLog(@"components   %d %d %d",_selectedDate,_selectedMonth,_selectedYear);
    weekday  = weekday - 2;
    
    if(weekday < 0)
        weekday += 7;
    
    NSCalendar *c = [NSCalendar currentCalendar];
    NSRange days = [c rangeOfUnit:NSCalendarUnitDay
                           inUnit:NSCalendarUnitMonth
                          forDate:self.calendarDate];
    
    NSInteger columns = 7;
    NSInteger width = self.bounds.size.width /7;
    NSInteger originX = 5;
    NSInteger originY = 40;
    NSInteger monthLength = days.length;
  
    // === 周几
    for (int i =0; i<_weekNames.count; i++) {
        UIButton *weekNameLabel = [UIButton buttonWithType:UIButtonTypeCustom];
        weekNameLabel.titleLabel.text = [_weekNames objectAtIndex:i];
        [weekNameLabel setTitle:[_weekNames objectAtIndex:i] forState:UIControlStateNormal];
        [weekNameLabel setFrame:CGRectMake(originX+(width*(i%columns)), originY, width, width)];
        [weekNameLabel setTitleColor:[UIColor brownColor] forState:UIControlStateNormal];
        [weekNameLabel.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:18.0f]];
        weekNameLabel.userInteractionEnabled = NO;
        [self addSubview:weekNameLabel];
    }
    
    // === 日期按钮
    for (NSInteger i= 0; i<monthLength; i++)
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = i+1;
        [button setTitle:[NSString stringWithFormat:@"%ld",i+1] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor brownColor] forState:UIControlStateNormal];
        [button.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:16.0f]];
        [button addTarget:self action:@selector(tappedDate:) forControlEvents:UIControlEventTouchUpInside];
        NSInteger offsetX = (width*((i+weekday)%columns));
        NSInteger offsetY = (width *((i+weekday)/columns));
        [button setFrame:CGRectMake(originX+offsetX, originY+40+offsetY, width, width)];
        [button.layer setBorderColor:[[UIColor blueColor] CGColor]];
        [button.layer setBorderWidth:2.0];
        
        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = [UIColor blackColor];
        if(((i+weekday)/columns)==0)
        {
            [lineView setFrame:CGRectMake(0, 0, button.frame.size.width, 2)];
            [button addSubview:lineView];
        }
        
        if(((i+weekday)/columns)==((monthLength+weekday-1)/columns))
        {
            [lineView setFrame:CGRectMake(0, button.frame.size.width-4, button.frame.size.width, 2)];
            [button addSubview:lineView];
        }
        
        UIView *columnView = [[UIView alloc]init];
        [columnView setBackgroundColor:[UIColor blueColor]];
        // === 边框的颜色
        
        if((i+weekday)%7==0)
        {
            [columnView setFrame:CGRectMake(0, 0, 4, button.frame.size.width)];
            [button addSubview:columnView];
        }
        else if((i+weekday)%7==6)
        {
            [columnView setFrame:CGRectMake(button.frame.size.width-4, 0, 4, button.frame.size.width)];
            [button addSubview:columnView];
        }
        // === 当前日期的颜色
        if(i+1 ==_selectedDate && components.month == _selectedMonth && components.year == _selectedYear)
        {
            [button setBackgroundColor:[UIColor lightGrayColor]];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            
        }
        
        [self addSubview:button];
    }
    
    // === 上一个月
    NSDateComponents *previousMonthComponents = [gregorian components:(NSCalendarUnitEra | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:self.calendarDate];
    previousMonthComponents.month -=1;
    NSDate *previousMonthDate = [gregorian dateFromComponents:previousMonthComponents];
    NSRange previousMonthDays = [c rangeOfUnit:NSCalendarUnitDay
                                        inUnit:NSCalendarUnitMonth
                                       forDate:previousMonthDate];
    NSInteger maxDate = previousMonthDays.length - weekday;
    
    // === 每个月最多的天数
    for (int i=0; i<weekday; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.titleLabel.text = [NSString stringWithFormat:@"%ld",maxDate+i+1];
        [button setTitle:[NSString stringWithFormat:@"%ld",maxDate+i+1] forState:UIControlStateNormal];
        NSInteger offsetX = (width*(i%columns));
        NSInteger offsetY = (width*(i/columns));
        [button setFrame:CGRectMake(originX+offsetX, originY+40+offsetY, width, width)];
        [button.layer setBorderWidth:2.0];
        [button.layer setBorderColor:[[UIColor blueColor] CGColor]];
        UIView *columnView = [[UIView alloc]init];
        [columnView setBackgroundColor:[UIColor blueColor]];
        if(i==0)
        {
            [columnView setFrame:CGRectMake(0, 0, 4, button.frame.size.width)];
            [button addSubview:columnView];
        }
        
        UIView *lineView = [[UIView alloc]init];
        [lineView setBackgroundColor:[UIColor blueColor]];
        [lineView setFrame:CGRectMake(0, 0, button.frame.size.width, 4)];
        [button addSubview:lineView];
        [button setTitleColor:[UIColor colorWithRed:229.0/255.0 green:231.0/255.0 blue:233.0/255.0 alpha:1.0] forState:UIControlStateNormal];
        [button.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:15.0f]];
        [button setEnabled:NO];
        [self addSubview:button];
    }
    
    NSInteger remainingDays = (monthLength + weekday) % columns;
    if(remainingDays >0){
        for (NSInteger i=remainingDays; i<columns; i++) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setTitle:[NSString stringWithFormat:@"%ld",(i+1)-remainingDays] forState:UIControlStateNormal];
            NSInteger offsetX = (width*((i) %columns));
            NSInteger offsetY = (width *((monthLength+weekday)/columns));
            [button setFrame:CGRectMake(originX+offsetX, originY+40+offsetY, width, width)];
            [button.layer setBorderWidth:2.0];
            [button.layer setBorderColor:[[UIColor blueColor] CGColor]];
           // === 按钮边框的设置
            UIView *columnView = [[UIView alloc]init];
            [columnView setBackgroundColor:[UIColor blueColor]];
            if(i==columns - 1)
            {
                [columnView setFrame:CGRectMake(button.frame.size.width-4, 0, 4, button.frame.size.width)];
                [button addSubview:columnView];
            }
            
            UIView *lineView = [[UIView alloc]init];
            [lineView setBackgroundColor:[UIColor blueColor]];
            [lineView setFrame:CGRectMake(0, button.frame.size.width-4, button.frame.size.width, 4)];
            [button addSubview:lineView];
            // ----------------------
            
            // === 显示其他月份的日期
            [button setTitleColor:[UIColor colorWithRed:200.0/255.0 green:188.0/255.0 blue:188.0/255.0 alpha:1.0] forState:UIControlStateNormal];
            [button.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:15.0f]];
            [button setEnabled:NO];
            [self addSubview:button];
            
        }
    }
    
}
-(void)tappedDate:(UIButton *)sender
{
    NSDateComponents *components = [gregorian components:(NSCalendarUnitEra | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:self.calendarDate];
    if(!(_selectedDate == sender.tag && _selectedMonth == [components month] && _selectedYear == [components year]))
    {
        if(_selectedDate != -1)
        {
            UIButton *previousSelected =(UIButton *) [self viewWithTag:_selectedDate];
            [previousSelected setBackgroundColor:[UIColor clearColor]];
            [previousSelected setTitleColor:[UIColor brownColor] forState:UIControlStateNormal];
            
        }
        
        [sender setBackgroundColor:[UIColor blueColor]];
        [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _selectedDate = sender.tag;
        NSDateComponents *components = [gregorian components:(NSCalendarUnitEra | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:self.calendarDate];
        components.day = _selectedDate;
        _selectedMonth = components.month;
        _selectedYear = components.year;
        
        NSDate *clickedDate = [gregorian dateFromComponents:components];
        NSDateFormatter *format = [[NSDateFormatter alloc] init];
        [format setDateFormat:@"MM yyyy dd"];
        NSString *dateString = [[format stringFromDate:clickedDate] uppercaseString];
        [_timeShowL setText:dateString];
        
        components.day = _selectedDate+1;
        NSDate *choseDate = [gregorian dateFromComponents:components];
        [self.delegate chooseDate:choseDate];
    }

}
// === 左减 右加
// === 月份增加
-(void)goRight
{
    
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    NSDateComponents *components = [gregorian components:(NSCalendarUnitEra | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:self.calendarDate];
    components.day = 1;
    components.month += 1;
    self.calendarDate = [gregorian dateFromComponents:components];
    [UIView transitionWithView:self
                      duration:0.5f
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^ { [self setNeedsDisplay]; }
                    completion:nil];
    
}
// === 年份增加
-(void)goRighty
{
    
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    NSDateComponents *components = [gregorian components:(NSCalendarUnitEra | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:self.calendarDate];
    components.day = 1;
    components.year += 1;
    self.calendarDate = [gregorian dateFromComponents:components];
    [UIView transitionWithView:self
                      duration:0.5f
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^ { [self setNeedsDisplay]; }
                    completion:nil];
    
}
// === 月份减少
-(void)goLeft
{
    
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    NSDateComponents *components = [gregorian components:(NSCalendarUnitEra | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:self.calendarDate];
    components.day = 1;
    components.month -= 1;
    self.calendarDate = [gregorian dateFromComponents:components];
    [UIView transitionWithView:self
                      duration:0.5f
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^ { [self setNeedsDisplay]; }
                    completion:nil];
}
// === 年份减少
-(void)goLefty
{
    
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    NSDateComponents *components = [gregorian components:(NSCalendarUnitEra | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:self.calendarDate];
    components.day = 1;
    components.year -= 1;
    self.calendarDate = [gregorian dateFromComponents:components];
    [UIView transitionWithView:self
                      duration:0.5f
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^ { [self setNeedsDisplay]; }
                    completion:nil];
}

// === 排列日期
-(void)setCalendarParameters
{
//    if(gregorian == nil)
//    {
//        gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
//        // gregorian = [NSCalendar currentCalendar];
//        NSDateComponents *components = [gregorian components:(NSCalendarUnitEra | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:self.calendarDate];
//        _selectedDate  = components.day;
//        _selectedMonth = components.month;
//        _selectedYear = components.year;
//    }
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
