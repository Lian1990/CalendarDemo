//
//  ViewController.h
//  CalendarDemo
//
//  Created by LIAN on 16/3/2.
//  Copyright © 2016年 com.Alice. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CalendarView.h"

@interface ViewController : UIViewController <CalendarDelegate>

@property (strong,nonatomic) CalendarView *calendar;


@end

