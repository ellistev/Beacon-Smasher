
#import "ViewController.h"

#import <Gimbal/Gimbal.h>

@interface ViewController () <GMBLPlaceManagerDelegate, GMBLCommunicationManagerDelegate>

@property (nonatomic) GMBLPlaceManager *placeManager;
@property (nonatomic) GMBLCommunicationManager *communicationManager;

@property (nonatomic, readonly) NSArray *events;

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.placeManager = [GMBLPlaceManager new];
    self.placeManager.delegate = self;
    
    self.communicationManager = [GMBLCommunicationManager new];
    self.communicationManager.delegate = self;
}

# pragma mark - Gimbal PlaceManager delegate methods

- (void)placeManager:(GMBLPlaceManager *)manager didEnterPlace:(GMBLPlace *)place date:(NSDate *)date
{
    [self addEventWithMessage:place.name date:date icon:@"placeEnter.png"];
}

- (void)placeManager:(GMBLPlaceManager *)manager
        didExitPlace:(GMBLPlace *)place
           entryDate:(NSDate *)entryDate
            exitDate:(NSDate *)exitDate
{
    [self addEventWithMessage:place.name date:exitDate icon:@"placeExit.png"];
}

# pragma mark - Gimbal CommunicationManager delegate methods

- (void)communicationManager:(GMBLCommunicationManager *)manager
    didReceiveCommunications:(NSArray *)communications
             forEntryToPlace:(GMBLPlace *)place
                        date:(NSDate *)date
{
    for (GMBLCommunication *communication in communications)
    {
        [self addEventWithMessage:communication.title date:date icon:@"commEnter.png"];
    }
}

- (void)communicationManager:(GMBLCommunicationManager *)manager
    didReceiveCommunications:(NSArray *)communications
            forExitFromPlace:(GMBLPlace *)place
                   entryDate:(NSDate *)entryDate
                    exitDate:(NSDate *)exitDate
{
    for (GMBLCommunication *communication in communications)
    {
        [self addEventWithMessage:communication.title date:exitDate icon:@"commExit.png"];
    }
}

#pragma mark - TableView delegate methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.events count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
    }
    
    NSDictionary *item = self.events[indexPath.row];
    
    cell.textLabel.text = item[@"message"];
    cell.detailTextLabel.text = [NSDateFormatter localizedStringFromDate:item[@"date"]
                                                               dateStyle:NSDateFormatterMediumStyle
                                                               timeStyle:NSDateFormatterMediumStyle];
    cell.imageView.image = [UIImage imageNamed:item[@"icon"]];
    
    return cell;
}

#pragma mark - Utility methods

- (NSArray *)events
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"events"];
}

- (void)addEventWithMessage:(NSString *)message date:(NSDate *)date icon:(NSString *)icon
{
    NSDictionary *item = @{@"message":message, @"date":date, @"icon":icon};
    
    NSLog(@"Event %@",[item description]);
    
    NSMutableArray *events = [NSMutableArray arrayWithArray:self.events];
    [events insertObject:item atIndex:0];
    [[NSUserDefaults standardUserDefaults] setObject:events forKey:@"events"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]]
                          withRowAnimation:UITableViewRowAnimationAutomatic];
}

@end
