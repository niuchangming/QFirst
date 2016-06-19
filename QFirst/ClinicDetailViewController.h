//
//  ClinicDetailViewController.h
//  FirstQ
//
//  Created by ChangmingNiu on 4/5/16.
//  Copyright © 2016 EKOO LAB PTE. LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <MapKit/MKAnnotation.h>
#import "DBClinic.h"
#import "DBUser.h"
#import "LoginViewController.h"
#import "MozTopAlertView.h"

@interface ClinicDetailViewController : UIViewController<MKMapViewDelegate,  CLLocationManagerDelegate, UIAlertViewDelegate, LoginViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *clincInfoCell;
@property (weak, nonatomic) IBOutlet MKMapView *clinicMapView;
@property (weak, nonatomic) IBOutlet UILabel *addressLbl;
@property(nonatomic, strong) CLLocationManager *locationManager;
@property (weak, nonatomic) IBOutlet UIImageView *clinicLogo;
@property (weak, nonatomic) IBOutlet UILabel *clinicName;
@property (weak, nonatomic) IBOutlet UIButton *expandArrow;
@property (weak, nonatomic) IBOutlet UILabel *descLbl;
@property (weak, nonatomic) IBOutlet UIView *doctorContainer;
@property (strong, nonatomic) UIButton *queueBtn;
@property (weak, nonatomic) IBOutlet UIButton *bookmarkBtn;
@property (strong, nonatomic) DBClinic *clinic;
@property (strong, nonatomic) NSArray<DBUser *> *doctorArray;

- (IBAction)expandArrowBtnClicked:(id)sender;
- (IBAction)quickBtnClicked:(id)sender;
- (IBAction)bookmarkBtnClicked:(id)sender;

@end
