//
//  ViewController.m
//  MyDateApp
//
//  Created by Sabarish Sekar on 17/10/13.
//  Copyright (c) 2013 Sabarish Sekar. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (nonatomic,strong) UILabel *hourTimer;
@property (nonatomic,strong) UILabel *minutesTimer;
@property (nonatomic,strong) UILabel *secondsTimer;

@property (assign) int currentHour;
@property (assign) int currentMinute;
@property (assign) int currentSecond;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self drawControls];
	// Do any additional setup after loading the view, typically from a nib.
}


- (void)drawControls{

    // To get no of hours, minutes, seconds between 2 dates
    NSString *startDateValue = @"2013-10-19";
    NSString *endDateValue = @"2013-10-18";

    [self calculateTimeBetween2Dates:startDateValue endDateValue:endDateValue];

    
    /* To display current date and time */
    [self displayCurrentDateWithCurrentTime];

    
    /* To get number of dates between 2 dates */
    NSString *startDateVal = @"2013-10-18";
    NSString *endDateVal = @"2013-11-18";
    [self getNoOfDates:startDateVal endDateVal:endDateVal];
    
    
    /* To display timer (OR) countdown timer */
    [self displayCountDownTimerInAsc:NO]; //Pass YES to display regular timer as in MAC status bar. Pass NO to display count down timer.

}

- (void)calculateTimeBetween2Dates:(NSString *)startDateValue endDateValue:(NSString *)endDateValue{
    NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc] init];
    [dateFormatter1 setDateFormat:@"yyyy-MM-dd"];
    
    NSDate *startDate = [dateFormatter1 dateFromString:startDateValue];
    NSDate *endDate = [dateFormatter1 dateFromString:endDateValue];
    
    NSTimeInterval distanceBetweenDates = [startDate timeIntervalSinceDate:endDate];
    double secondsInAnHour = 3600;
    int hoursBetweenDates = distanceBetweenDates / secondsInAnHour;
    
    NSLog(@"Hours Between 2 Dates:%d",   hoursBetweenDates);
    NSLog(@"Minutes Between 2 Dates:%d", hoursBetweenDates*60);
    NSLog(@"Seconds Between 2 Dates:%d", hoursBetweenDates*60*60);
}

- (void)displayCurrentDateWithCurrentTime{
    
    /* To get current date */
    NSDate *todayDate = [NSDate date];
    
    UILabel *currentDate = [[UILabel alloc] initWithFrame:CGRectMake(20.0,40.0, 320.0, 30.0)];
    currentDate.textColor = [UIColor blackColor];
    currentDate.font = [UIFont fontWithName:@"Helvetica" size:13.0];
    [self.view addSubview:currentDate];
    
    /* To display current date in particular format */
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateStyle:NSDateFormatterShortStyle];
    dateFormatter.dateFormat = @"dd-MM-yyyy HH:mm:ss";
    
    NSString *dateString = [dateFormatter stringFromDate:todayDate];
    currentDate.text = [NSString stringWithFormat:@"%@%@",@"Today Date is: ",dateString];
}


- (void)getNoOfDates:(NSString*)startDateVal endDateVal:(NSString*)endDateVal{
    
    NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc] init];
    [dateFormatter1 setDateFormat:@"yyyy-MM-dd"];
    
    NSDate *startDate = [dateFormatter1 dateFromString:startDateVal];
    NSDate *endDate = [dateFormatter1 dateFromString:endDateVal];
    
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [gregorianCalendar components:NSDayCalendarUnit
                                                        fromDate:startDate
                                                          toDate:endDate
                                                         options:0];
    
    NSLog(@"%ld days between start and end date",[components day]);
}


- (void)displayCountDownTimerInAsc:(BOOL)displayTimerInAsc{
 
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:(NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit) fromDate:[NSDate date]];
    
    self.currentSecond = [components second];
    self.currentMinute = [components minute];
    self.currentHour = [components hour];
    
    self.currentMinute = 00;
    self.currentSecond = 10;
    

    UIFont *timerFont = [UIFont fontWithName:@"Helvetica" size:42.0];
    self.hourTimer = [[UILabel alloc] initWithFrame:CGRectMake(30.0, 100.0, 60.0, 30.0)];
    self.hourTimer.text  = [NSString stringWithFormat:@"%d:",self.currentHour];
    self.hourTimer.font = timerFont;
    [self.view addSubview:self.hourTimer];
    
    self.minutesTimer = [[UILabel alloc] initWithFrame:CGRectMake(90.0, 100.0, 60.0, 30.0)];
    self.minutesTimer.text  = (self.currentMinute > 9)?[NSString stringWithFormat:@"%d:",self.currentMinute]:[NSString stringWithFormat:@"0%d:",self.currentMinute];
    self.minutesTimer.font = timerFont;
    [self.view addSubview:self.minutesTimer];
    
    self.secondsTimer = [[UILabel alloc] initWithFrame:CGRectMake(150.0, 100.0, 60.0, 30.0)];
    self.secondsTimer.text  = (self.currentSecond > 9)?[NSString stringWithFormat:@"%d",self.currentSecond]:[NSString stringWithFormat:@"0%d",self.currentSecond];
    self.secondsTimer.font = timerFont;
    [self.view addSubview:self.secondsTimer];
    
    NSTimer *timerInterval;
    if(displayTimerInAsc){
        timerInterval = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(displayIncreasedTime) userInfo:nil repeats:YES];
    }else{
        timerInterval = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(displayDecreasedTime) userInfo:nil repeats:YES];
    }
}

- (void)displayIncreasedTime{
    
    if(self.currentSecond < 59){
        self.currentSecond = self.currentSecond + 1;
        self.secondsTimer.text = (self.currentSecond > 9)?[NSString stringWithFormat:@"%d",self.currentSecond]:[NSString stringWithFormat:@"0%d",self.currentSecond];
    }else if(self.currentSecond == 59 && self.currentMinute != 59){
        self.currentSecond = 00;
        self.secondsTimer.text = (self.currentSecond > 9)?[NSString stringWithFormat:@"%d",self.currentSecond]:[NSString stringWithFormat:@"0%d",self.currentSecond];
        if(self.currentSecond == 00 && self.currentMinute == 59)
            self.currentMinute = 00;
        else
            self.currentMinute = self.currentMinute + 1;
        self.minutesTimer.text = (self.currentMinute > 9)?[NSString stringWithFormat:@"%d:",self.currentMinute]:[NSString stringWithFormat:@"0%d:",self.currentMinute];
    }else if(self.currentMinute == 59 && self.currentSecond == 59){
        self.currentSecond = 00;
        self.currentMinute = 00;
    
        self.secondsTimer.text = (self.currentSecond > 9)?[NSString stringWithFormat:@"%d",self.currentSecond]:[NSString stringWithFormat:@"0%d",self.currentSecond];
        self.minutesTimer.text = (self.currentMinute > 9)?[NSString stringWithFormat:@"%d:",self.currentMinute]:[NSString stringWithFormat:@"0%d:",self.currentMinute];
        self.currentHour = self.currentHour + 1;
        self.hourTimer.text = (self.currentHour > 9)?[NSString stringWithFormat:@"%d:",self.currentHour]:[NSString stringWithFormat:@"0%d:",self.currentHour];
    }
}

- (void)displayDecreasedTime{
    
    if(self.currentSecond > 00){
        self.currentSecond = self.currentSecond - 1;
        self.secondsTimer.text = (self.currentSecond > 9)?[NSString stringWithFormat:@"%d",self.currentSecond]:[NSString stringWithFormat:@"0%d",self.currentSecond];
    }else if(self.currentSecond == 00 && self.currentMinute != 00){
        self.currentSecond = 59;
        self.secondsTimer.text = (self.currentSecond > 9)?[NSString stringWithFormat:@"%d",self.currentSecond]:[NSString stringWithFormat:@"0%d",self.currentSecond];
        self.currentMinute = self.currentMinute - 1;
        self.minutesTimer.text = (self.currentMinute > 9)?[NSString stringWithFormat:@"%d:",self.currentMinute]:[NSString stringWithFormat:@"0%d:",self.currentMinute];
    }else if(self.currentMinute == 00 && self.currentSecond == 00){
        self.currentSecond = 59;
        self.currentMinute = 59;
        self.secondsTimer.text = (self.currentSecond > 9)?[NSString stringWithFormat:@"%d",self.currentSecond]:[NSString stringWithFormat:@"0%d",self.currentSecond];
        self.minutesTimer.text = (self.currentMinute > 9)?[NSString stringWithFormat:@"%d:",self.currentMinute]:[NSString stringWithFormat:@"0%d:",self.currentMinute];
        self.currentHour = self.currentHour - 1;
        self.hourTimer.text = (self.currentHour > 9)?[NSString stringWithFormat:@"%d:",self.currentHour]:[NSString stringWithFormat:@"0%d:",self.currentHour];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
