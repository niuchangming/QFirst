//
//  TimelineViewController.m
//  FirstQ
//
//  Created by ChangmingNiu on 13/5/16.
//  Copyright © 2016 EKOO LAB PTE. LTD. All rights reserved.
//

#import "TimelineViewController.h"
#import "Utils.h"
#import "TimeLine.h"
#import "TimeCell.h"
#import "ConstantValues.h"
#import "MozTopAlertView.h"
#import <AFNetworking/AFHTTPRequestOperationManager.h>
#import "Reservation.h"

@interface TimelineViewController (){
    NSMutableDictionary *eventsByDate;
    NSDate *todayDate;
    NSDate *dateSelected;

    NSIndexPath *previousIndexpath;
    NSMutableArray *expandedIndexPathArray;
}

@end

@implementation TimelineViewController

@synthesize calendarMenu;
@synthesize calendarView;
@synthesize calendarManager;
@synthesize timelines;
@synthesize timetable;
@synthesize expandedIndexPath;
@synthesize doctor;
@synthesize clinicName;
@synthesize reservationMap;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    
    self.title = [doctor name];
    dateSelected = [Utils getStartDate:[Utils getLocalDateFrom:[NSDate date]]];
    
    reservationMap = [[NSMutableDictionary alloc] init];
    
    calendarManager = [JTCalendarManager new];
    [calendarManager setDelegate:self];
    calendarManager.settings.weekModeEnabled = YES;
    [calendarManager setMenuView:calendarMenu];
    [calendarManager setContentView:calendarView];
    [calendarManager setDate:[NSDate date]];
    
    expandedIndexPathArray = [NSMutableArray array];
    
    self.timetable.rowHeight = UITableViewAutomaticDimension;
    self.timetable.estimatedRowHeight = 300;
    
    timetable.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [self initDummyData];
    
    [self getReservations];
}

-(void) getReservations{
    NSString *url = [NSString stringWithFormat:@"%@ClinicController/getDoctorAvailableTimesByDate", baseUrl];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject: [NSNumber numberWithInt:doctor.entityId] forKey: @"doctorId"];
    [params setObject: [Utils getDateTimeStringByDate:dateSelected] forKey: @"dateString"];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]] == YES){
            NSDictionary *obj = (NSDictionary *)responseObject;
            NSString *errMsg = [obj valueForKey:@"error"];
            [MozTopAlertView showWithType:MozAlertTypeError text:errMsg doText:nil doBlock:nil parentView:self.view];
        }else if ([responseObject isKindOfClass:[NSArray class]] == YES){
            [reservationMap removeAllObjects];
            NSArray *array = (NSArray*) responseObject;
            for(NSDictionary *data in array){
                Reservation *reservation = [[Reservation alloc]initWithJson:data];
                [reservationMap setObject:reservation forKey:[Utils getTimeString:reservation.reservationDatetime]];
            }
            
            [self.timetable reloadData];
        }else{
            [MozTopAlertView showWithType:MozAlertTypeError text:@"Unknown error." doText:nil doBlock:nil parentView:self.view];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MozTopAlertView showWithType:MozAlertTypeError text:[error localizedDescription] doText:nil doBlock:nil parentView:self.view];
    }];

}

- (void)calendar:(JTCalendarManager *)calendar prepareDayView:(JTCalendarDayView *)dayView{
    // Today
    if([calendarManager.dateHelper date:[NSDate date] isTheSameDayThan:dayView.date]){
        dayView.circleView.hidden = NO;
        dayView.circleView.backgroundColor = [Utils colorFromHexString:@"#FF3B30"];
        dayView.dotView.backgroundColor = [UIColor whiteColor];
        dayView.textLabel.textColor = [UIColor whiteColor];
    }
    // Selected date
    else if(dateSelected && [calendarManager.dateHelper date:dateSelected isTheSameDayThan:dayView.date]){
        dayView.circleView.hidden = NO;
        dayView.circleView.backgroundColor = [Utils colorFromHexString:@"#007AFF"];
        dayView.dotView.backgroundColor = [UIColor whiteColor];
        dayView.textLabel.textColor = [UIColor whiteColor];
    }
    // Other month
    else if(![calendarManager.dateHelper date:calendarView.date isTheSameMonthThan:dayView.date]){
        dayView.circleView.hidden = YES;
        dayView.dotView.backgroundColor = [UIColor redColor];
        dayView.textLabel.textColor = [UIColor lightGrayColor];
    }
    // Another day of the current month
    else{
        dayView.circleView.hidden = YES;
        dayView.dotView.backgroundColor = [UIColor redColor];
        dayView.textLabel.textColor = [UIColor blackColor];
    }
    
}

- (void)calendar:(JTCalendarManager *)calendar didTouchDayView:(JTCalendarDayView *)dayView{
    dateSelected = [Utils getLocalDateFrom:dayView.date];
    
    [self getReservations];
    
    // Animation for the circleView
    dayView.circleView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.1, 0.1);
    [UIView transitionWithView:dayView
                      duration:.3
                       options:0
                    animations:^{
                        dayView.circleView.transform = CGAffineTransformIdentity;
                        [calendarManager reload];
                    } completion:nil];
    
    
    // Load the previous or next page if touch a day from another month
    
    if(![calendarManager.dateHelper date:calendarView.date isTheSameMonthThan:dayView.date]){
        if([calendarView.date compare:dayView.date] == NSOrderedAscending){
            [calendarView loadNextPageWithAnimation];
        }else{
            [calendarView loadPreviousPageWithAnimation];
        }
    }
}

- (UIView<JTCalendarDay> *)calendarBuildDayView:(JTCalendarManager *)calendar{
    JTCalendarDayView *view = [JTCalendarDayView new];
    view.circleRatio = .8;
    return view;
}

-(void) initDummyData{
    timelines = [[NSMutableArray alloc] init];
    
    TimeLine *morningTimeLine = [[TimeLine alloc] init];
    morningTimeLine.tagName = @"Morning";
    morningTimeLine.subTagName = @"before 12 pm";
    morningTimeLine.tagIvPath = @"morning.png";
    morningTimeLine.times = [[NSMutableArray alloc] init];
    [morningTimeLine.times addObject:@"08:00"];
    [morningTimeLine.times addObject:@"08:30"];
    [morningTimeLine.times addObject:@"09:00"];
    [morningTimeLine.times addObject:@"09:30"];
    [morningTimeLine.times addObject:@"10:00"];
    [morningTimeLine.times addObject:@"10:30"];
    [morningTimeLine.times addObject:@"11:00"];
    [morningTimeLine.times addObject:@"11:30"];
    
    
    TimeLine *afternoonTimeLine = [[TimeLine alloc] init];
    afternoonTimeLine.tagName = @"Afternoon";
    afternoonTimeLine.subTagName = @"12 - 16 pm";
    afternoonTimeLine.tagIvPath = @"sun.png";
    afternoonTimeLine.times = [[NSMutableArray alloc] init];
    [afternoonTimeLine.times addObject:@"12:00"];
    [afternoonTimeLine.times addObject:@"12:30"];
    [afternoonTimeLine.times addObject:@"13:00"];
    [afternoonTimeLine.times addObject:@"13:30"];
    [afternoonTimeLine.times addObject:@"14:00"];
    [afternoonTimeLine.times addObject:@"14:30"];
    [afternoonTimeLine.times addObject:@"15:00"];
    [afternoonTimeLine.times addObject:@"15:30"];
    
    TimeLine *eveningTimeLine = [[TimeLine alloc] init];
    eveningTimeLine.tagName = @"Evening";
    eveningTimeLine.subTagName = @"16 - 20 pm";
    eveningTimeLine.tagIvPath = @"evening.png";
    eveningTimeLine.times = [[NSMutableArray alloc] init];
    [eveningTimeLine.times addObject:@"16:00"];
    [eveningTimeLine.times addObject:@"16:30"];
    [eveningTimeLine.times addObject:@"17:00"];
    [eveningTimeLine.times addObject:@"17:30"];
    [eveningTimeLine.times addObject:@"18:00"];
    [eveningTimeLine.times addObject:@"18:30"];
    [eveningTimeLine.times addObject:@"19:00"];
    [eveningTimeLine.times addObject:@"19:30"];
    
    TimeLine *nightTimeLine = [[TimeLine alloc] init];
    nightTimeLine.tagName = @"Night";
    nightTimeLine.subTagName = @"after 20 pm";
    nightTimeLine.tagIvPath = @"night.png";
    nightTimeLine.times = [[NSMutableArray alloc] init];
    [nightTimeLine.times addObject:@"20:00"];
    [nightTimeLine.times addObject:@"20:30"];
    [nightTimeLine.times addObject:@"21:00"];
    [nightTimeLine.times addObject:@"21:30"];
    [nightTimeLine.times addObject:@"22:00"];
    [nightTimeLine.times addObject:@"22:30"];
    [nightTimeLine.times addObject:@"23:00"];
    [nightTimeLine.times addObject:@"23:30"];
    
    [timelines addObject:morningTimeLine];
    [timelines addObject:afternoonTimeLine];
    [timelines addObject:eveningTimeLine];
    [timelines addObject:nightTimeLine];
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return timelines.count;
}

-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"TimeLineCell";
    
    TimeCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (self.expandedIndexPath == indexPath && [expandedIndexPathArray containsObject:indexPath]) {
        cell.showDetails = YES;
    }else{
        cell.showDetails = NO;
    }
    
    TimeLine *timeline = [timelines objectAtIndex:indexPath.row];
    [cell.tagIv setImage:[UIImage imageNamed:[timeline tagIvPath]]];
    
    
    NSString * htmlString = [NSString stringWithFormat:@"<span style='font-family:HelveticaNeue; font-size:14px'>%@</span> <span style='font-family:HelveticaNeue;color:#8E8E93;font-size:12px'>%@</span>", timeline.tagName, timeline.subTagName];
    NSAttributedString * attrStr = [[NSAttributedString alloc] initWithData:[htmlString dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
    cell.tagNameLbl.attributedText = attrStr;
    
    for(int i = 0; i < [timeline.times count]; i++){
        UIButton *timeBtn = (UIButton *)[cell viewWithTag:i + 1];
        
        if([reservationMap objectForKey:[[timeline times] objectAtIndex:i]]){
            [timeBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            [timeBtn setEnabled:NO];
        }else{
            [timeBtn setTitleColor:[Utils colorFromHexString:@"#19B0EC"] forState:UIControlStateNormal];
            [timeBtn setEnabled:YES];
        }
        [timeBtn setTitle:[[timeline times] objectAtIndex:i] forState:UIControlStateNormal];
        [timeBtn addTarget:self action:@selector(queueBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    self.expandedIndexPath = indexPath;
    
    if(![expandedIndexPathArray containsObject:indexPath]){
        [expandedIndexPathArray addObject:indexPath];
    }
    else{
        [expandedIndexPathArray removeObject:indexPath];
    }
    
    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)queueBtnClicked:(id) sender{
    [self performSegueWithIdentifier:@"segue_book_fm_timeline" sender:sender];
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    UIButton *timeBtn = (UIButton*) sender;
    
    if ([[segue identifier] isEqualToString:@"segue_book_fm_timeline"]){
        DoctorDetailViewController *doctorDetailVC = [segue destinationViewController];
        doctorDetailVC.doctor = doctor;
        doctorDetailVC.delegate = self;
        doctorDetailVC.clinicName = clinicName;
        doctorDetailVC.datetimeString = [NSString stringWithFormat:@"%@ %@", [Utils getDateStringByDate:dateSelected], timeBtn.currentTitle];
    }
}

-(void) reserveCompletedWithResponseData:(id)resp withError:(NSString *)err{
    if([Utils IsEmpty:err]){
        if ([resp isKindOfClass:[NSDictionary class]] == YES){
            NSDictionary *data = (NSDictionary *)resp;
            Reservation *reservation = [[Reservation alloc]initWithJson:data];
            [reservationMap setObject:reservation forKey:[Utils getTimeString:reservation.reservationDatetime]];
            
            NSLog(@"------> %@, %@", reservation.reservationDatetime, [Utils getTimeString:reservation.reservationDatetime]);
            
            [self.timetable reloadData];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
