
#import "AppDelegate.h"
#import <Gimbal/Gimbal.h>

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // To get started with an API key, go to https://manager.gimbal.com/
#warning Instert your Gimbal Application API key below in order to see this sample application work
    [Gimbal setAPIKey:@"PUT_YOUR_GIMBAL_API_KEY_HERE" options:nil];
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"HasBeenPresentedWithOptInScreen"] == NO)
    {
        self.window.rootViewController = [[UIStoryboard storyboardWithName:@"Opt-In" bundle:nil] instantiateInitialViewController];
    }
    
    return YES;
}

@end
