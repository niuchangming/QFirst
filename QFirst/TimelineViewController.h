//
//  TimelineViewController.h
//  FirstQ
//
//  Created by ChangmingNiu on 13/5/16.
//  Copyright © 2016 EKOO LAB PTE. LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <JTCalendar/JTCalendar.h>
#import "DBUser.h"
#import "DoctorDetailViewController.h"

@interface TimelineViewController : UIViewController<JTCalendarDelegate, UITabBarDelegate, UITableViewDataSource, ReserveDelegate>
@property (weak, nonatomic) IBOutlet JTCalendarMenuView *calendarMenu;
@property (weak, nonatomic) IBOutlet JTHorizontalCalendarView *calendarView;
@property (strong, nonatomic) JTCalendarManager *calendarManager;
@property (weak, nonatomic) IBOutlet UITableView *timetable;

@property (strong, nonatomic) DBUser *doctor;
@property (strong, nonatomic) NSString *clinicName;

@property (strong, nonatomic) NSIndexPath *expandedIndexPath;
@property (strong, nonatomic) NSMutableArray *timelines;
@property (strong, nonatomic) NSMutableDictionary *reservationMap;

@end
