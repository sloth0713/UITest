//
//  SceneDelegate.m
//  UITest
//
//  Created by ByteDance on 2024/10/25.
//

#import "SceneDelegate.h"
#import "ViewController.h"
#import "TabBar.h"
#import "Fluency/RunLoopFluencyMonitor.h"
#import "Fluency/DisplayLinkFluencyMonitor.h"
#import "Thread/ThreadTest.h"
#import "Method/MethodTest.h"
#import "Method/AppOrderFiles.h"
#import <mach/mach.h>
#import <sys/sysctl.h>
#import "DonateIntent.h"
#import <CoreSpotlight/CoreSpotlight.h>

@interface SceneDelegate ()

@end

@implementation SceneDelegate


- (void)scene:(UIScene *)scene willConnectToSession:(UISceneSession *)session options:(UISceneConnectionOptions *)connectionOptions {
    // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
    // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
    // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
    
    UIWindowScene *windowScene = (UIWindowScene *)scene;
    self.window = [[UIWindow alloc] initWithWindowScene:windowScene];
    self.window.frame = windowScene.coordinateSpace.bounds;
    
    TabBar *tabBarController = [[TabBar alloc] init];
    
    
    self.window.rootViewController = tabBarController;
    [self.window makeKeyAndVisible];
    
    [self methodForwardTest];
    [self threadTest];
    [self orderfileTest];
    [self pageInCollection];
    [self startMonitor];
    int loop = 10;
    for (int i = 0; i<loop; i++) {
        [self DonateIntet];
//        [self deleteSiriDonate];
        
        NSLog(@"DonateIntet");
    }
    
    
    NSLog(@"willConnectToSession");
}

- (void)deleteSiriDonate
{
    [NSUserActivity deleteAllSavedUserActivitiesWithCompletionHandler:^(){
        NSLog(@"All siri suggestion cache has been cleaned");
    }];

    [INInteraction deleteAllInteractionsWithCompletion:^(NSError *error){
        if (!error){
            NSLog(@"All siri suggestion cache has been cleaned");
        }
    }];
}

- (void)DonateIntet
{
    DonateIntent *intent = [[DonateIntent alloc] init];
    intent.title = @"DonateIntent title";
    intent.content = @"DonateIntent content";
    if (intent != nil) {

        NSString *type = @"intent donate useractivity";
        NSUserActivity *intentUserActivity = [[NSUserActivity alloc] initWithActivityType:type];
        intentUserActivity.eligibleForSearch = YES;
        intentUserActivity.eligibleForPrediction = YES;
        intentUserActivity.eligibleForHandoff = NO;
        intentUserActivity.persistentIdentifier = type;
        CSSearchableItemAttributeSet *attributes = [[CSSearchableItemAttributeSet alloc] init];
        attributes.contentDescription = @"DonateIntent content useractivity";
        intentUserActivity.contentAttributeSet = attributes;
        intentUserActivity.title = @"DonateIntent title useractivity";
        intentUserActivity.userInfo = @{@"a":@(1)};
        NSDate *expirationDate = [[NSDate date] initWithTimeIntervalSinceNow: 24*60*60 * 7];
        intentUserActivity.expirationDate = expirationDate;
        [intentUserActivity becomeCurrent];
        
        
        INIntentResponse *response = [[INIntentResponse alloc] init];
        response.userActivity = intentUserActivity;
        INInteraction *action = [[INInteraction alloc] initWithIntent:intent response:response];
        action.identifier = @"intent donate";
        [action donateInteractionWithCompletion:^(NSError * _Nullable error) {
            if (error) {
                NSLog(@"error");
            }else{
                NSLog(@"success");
            }
        }];
        
    }
    
//    NSUserActivity *userActivity = [[NSUserActivity alloc] initWithActivityType:@"userActivity donate"];
//    userActivity.eligibleForSearch = YES;
//    userActivity.eligibleForHandoff = NO;
//
//
//    userActivity.eligibleForPrediction = YES;
//    userActivity.persistentIdentifier = @"userActivity donate";
//    CSSearchableItemAttributeSet *attributes = [[CSSearchableItemAttributeSet alloc] init];
//    attributes.contentDescription = @"useractivity content";
//    userActivity.contentAttributeSet = attributes;
//    userActivity.title = @"useractivity title";
//    [userActivity becomeCurrent];
//    
}

- (void)pageInCollection
{
    task_events_info_data_t eventsInfo;
    NSDictionary *taskFaults = @{};
    kern_return_t kr = task_info(mach_task_self(), TASK_EVENTS_INFO, (task_info_t)&eventsInfo, &(mach_msg_type_number_t){ TASK_EVENTS_INFO_COUNT });
    int pageInCount = eventsInfo.pageins;
    NSLog(@"pageInCollection");
}

- (void)threadTest
{
    [[ThreadTest alloc] init];
}

- (void)orderfileTest
{
    AppOrderFiles(^(NSString *orderFilePath) {
        NSLog(@"fdsa");
    });
}

- (void)methodForwardTest
{
    MethodTest *test = [[MethodTest alloc] init];
    id testid = (id)test;
    SEL selector = @selector(runMethod:);
    NSString *myParameter = @"myParameter!";
    [testid performSelector:selector withObject:myParameter];
}

- (void)startMonitor
{
    
//    [RunLoopFluencyMonitor shareMonitor];
    [DisplayLinkFluencyMonitor shareMonitor];
}


- (void)sceneDidDisconnect:(UIScene *)scene {
    // Called as the scene is being released by the system.
    // This occurs shortly after the scene enters the background, or when its session is discarded.
    // Release any resources associated with this scene that can be re-created the next time the scene connects.
    // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
}


- (void)sceneDidBecomeActive:(UIScene *)scene {
    // Called when the scene has moved from an inactive state to an active state.
    // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
}


- (void)sceneWillResignActive:(UIScene *)scene {
    // Called when the scene will move from an active state to an inactive state.
    // This may occur due to temporary interruptions (ex. an incoming phone call).
}


- (void)sceneWillEnterForeground:(UIScene *)scene {
    // Called as the scene transitions from the background to the foreground.
    // Use this method to undo the changes made on entering the background.
}


- (void)sceneDidEnterBackground:(UIScene *)scene {
    // Called as the scene transitions from the foreground to the background.
    // Use this method to save data, release shared resources, and store enough scene-specific state information
    // to restore the scene back to its current state.
}


@end
