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

- (void)scene:(UIScene *)scene continueUserActivity:(NSUserActivity *)userActivity
{
    INIntent *intent = userActivity.interaction.intent;
    if (intent) {
        if ([intent isKindOfClass:[DonateIntent class]]) {
            DonateIntent *donateIntent = (DonateIntent *)intent;
            NSLog(@"title %@",donateIntent.title);
            NSLog(@"donateIntent");
        }else if ([intent isKindOfClass:[INPlayMediaIntent class]]){
            INPlayMediaIntent *playMediaIntent = (INPlayMediaIntent *)intent;
            NSLog(@"media:%@",playMediaIntent.mediaContainer.title);
            NSLog(@"playMediaIntent");
        }else if ([intent isKindOfClass:[INSendMessageIntent class]]){
            INSendMessageIntent *sendMessageIntent = (INSendMessageIntent *)intent;
            NSLog(@"sender:%@",sendMessageIntent.sender.displayName);
            NSLog(@"sendMessageIntent");
        }else{
            NSLog(@"can't handle intent");
        }
    }else {
        NSLog(@"Don't have intent");
    }
}

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
    
//    [self methodForwardTest];
//    [self threadTest];
//    [self orderfileTest];
//    [self pageInCollection];
//    [self startMonitor];
    [self donateTset];
    
    
    NSLog(@"willConnectToSession");
}

- (void)donateTset
{
    //delete
//    [self deleteSiriDonate];
    
    //donate
//    [self customIntentTest];
//    [self playMediaIntentTest];
    [self upcomeMediaIntentTest];
//    [self searchMediaIntentTest];
//    [self sendMessageIntentTest];
}

- (void)sendMessageIntentTest
{
    // josh 给amy 发送了"nice to see you"

    UIImage *image = [UIImage imageNamed:@"josh"];
    NSData *imageData = UIImageJPEGRepresentation(image, 1.0);

    if (imageData) {
        NSLog(@"在这里可以继续使用 imageData，例如将其保存到文件中或进行其他操作");
    } else {
        // 获取图片数据失败
        NSLog(@"获取图片数据失败");
        return;
    }
    
    INImage *icon = [INImage imageWithImageData:imageData];
    INPersonHandle *senderHandle = [[INPersonHandle alloc] initWithValue:@"josh.@gemail.com" type:INPersonHandleTypeEmailAddress];
    
    INPerson *senderPerson = [[INPerson alloc] initWithPersonHandle:senderHandle nameComponents:nil displayName:@"josh" image:icon contactIdentifier:nil customIdentifier:@"sender josh"];
    
    
    INPersonHandle *recipientHandle = [[INPersonHandle alloc] initWithValue:@"amy.@gemail.com" type:INPersonHandleTypeEmailAddress];
    INPerson *recipient = [[INPerson alloc] initWithPersonHandle:recipientHandle nameComponents:nil displayName:@"amy" image:icon contactIdentifier:nil customIdentifier:@"recipient amy"];
    
    
    INSpeakableString *name = [[INSpeakableString alloc] initWithSpokenPhrase:@"yyy"];
    
    //如何修改icon
    INSendMessageIntent *intent = [[INSendMessageIntent alloc] initWithRecipients:@[recipient] outgoingMessageType:INOutgoingMessageTypeOutgoingMessageText content:@"nice to see you" speakableGroupName:name conversationIdentifier:nil serviceName:@"send message" sender:senderPerson attachments:nil];

    INInteraction *interaction = [[INInteraction alloc] initWithIntent:intent response:nil];
    [interaction donateInteractionWithCompletion:^(NSError *error){
        if (error) {
            NSLog(@"donate error:%@", error.description);
        }else {
            NSLog(@"donate success");
        }
    }];
}

- (void)upcomeMediaIntentTest
{
    UIImage *image = [UIImage imageNamed:@"red"];
    NSData *imageData = UIImageJPEGRepresentation(image, 1.0);

    if (!imageData) return;
    
    //这个不仅是短视频，直播也能用
    INImage *artWork = [INImage imageWithImageData:imageData];
    INMediaItem *item = [[INMediaItem alloc] initWithIdentifier:@"taylor swift1"
                                                          title:@"你关注的taylor swift的最新视频"
                                                          type:INMediaItemTypeNews
                                                          artwork:artWork
                                                         artist:@"taylor swift"];
    INPlayMediaIntent *playIntent1 = [[INPlayMediaIntent alloc] initWithMediaItems:@[item]
                                                                   mediaContainer:item
                                                                     playShuffled:nil
                                                               playbackRepeatMode:INPlaybackRepeatModeNone
                                                                   resumePlayback:nil
                                                            playbackQueueLocation:INPlaybackQueueLocationUnknown
                                                                    playbackSpeed:nil
                                                                      mediaSearch:nil];
    
    INMediaItem *item2 = [[INMediaItem alloc] initWithIdentifier:@"taylor swift1"
                                                          title:@"tiktok热榜"
                                                          type:INMediaItemTypeNews
                                                          artwork:nil];
    INPlayMediaIntent *playIntent2 = [[INPlayMediaIntent alloc] initWithMediaItems:nil
                                                                   mediaContainer:item2
                                                                     playShuffled:nil
                                                               playbackRepeatMode:INPlaybackRepeatModeNone
                                                                   resumePlayback:nil
                                                            playbackQueueLocation:INPlaybackQueueLocationUnknown
                                                                    playbackSpeed:nil
                                                                      mediaSearch:nil];
    
    INMediaItem *item3 = [[INMediaItem alloc] initWithIdentifier:@"taylor swift1"
                                                          title:@"你喜欢的搞笑视频"
                                                            type:INMediaItemTypeMusic
                                                          artwork:artWork
                                                          artist:@"adele"];
    INMediaSearch *mediaSearch = [[INMediaSearch alloc] initWithMediaType:INMediaItemTypeMusic sortOrder:INMediaSortOrderBest mediaName:@"gaoxiao" artistName:@"deell" albumName:@"albumName" genreNames:@[@"genreNames"] moodNames:@[@"moodNames"] releaseDate:nil reference:INMediaReferenceMy mediaIdentifier:@"mediaIdentifier"];
    INPlayMediaIntent *playIntent3 = [[INPlayMediaIntent alloc] initWithMediaItems:@[item3]
                                                                   mediaContainer:item3
                                                                     playShuffled:nil
                                                               playbackRepeatMode:INPlaybackRepeatModeNone
                                                                   resumePlayback:nil
                                                            playbackQueueLocation:INPlaybackQueueLocationUnknown
                                                                    playbackSpeed:nil
                                                                      mediaSearch:mediaSearch];
    
    INMediaItem *item4 = [[INMediaItem alloc] initWithIdentifier:@"taylor swift"
                                                          title:@"你关注好友的直播"
                                                          type:INMediaItemTypeNews
                                                          artwork:nil];
    INPlayMediaIntent *playIntent4 = [[INPlayMediaIntent alloc] initWithMediaItems:nil
                                                                   mediaContainer:item4
                                                                     playShuffled:nil
                                                               playbackRepeatMode:INPlaybackRepeatModeNone
                                                                   resumePlayback:nil
                                                            playbackQueueLocation:INPlaybackQueueLocationUnknown
                                                                    playbackSpeed:nil
                                                                      mediaSearch:nil];
    
    NSOrderedSet *set = [NSOrderedSet orderedSetWithObjects:playIntent1,playIntent2,playIntent3,playIntent4,nil];
    
    //这里如何删除？目前好像只能通过set的内容为空来删除？
    [INUpcomingMediaManager.sharedManager setSuggestedMediaIntents:set];
}

- (void)playMediaIntentTest
{
    UIImage *image = [UIImage imageNamed:@"red"];
    NSData *imageData = UIImageJPEGRepresentation(image, 1.0);

    if (!imageData) return;
    
    INImage *artWork = [INImage imageWithImageData:imageData];
    INMediaItem *item = [[INMediaItem alloc] initWithIdentifier:@"red1"
                                                          title:@"red1"
                                                          type:INMediaItemTypeArtist
                                                          artwork:artWork];
    INPlayMediaIntent *playIntent = [[INPlayMediaIntent alloc] initWithMediaItems:nil
                                                                   mediaContainer:item
                                                                     playShuffled:nil
                                                               playbackRepeatMode:INPlaybackRepeatModeNone
                                                                   resumePlayback:nil
                                                            playbackQueueLocation:INPlaybackQueueLocationUnknown
                                                                    playbackSpeed:nil
                                                                      mediaSearch:nil];

    INInteraction *interaction = [[INInteraction alloc] initWithIntent:playIntent response:nil];
    [interaction donateInteractionWithCompletion:^(NSError *error){
        if (error) {
            NSLog(@"donate error:%@", error.description);
        }else {
            NSLog(@"donate success");
        }
    }];
}

- (void)searchMediaIntentTest
{

    //好像没啥用
    UIImage *image = [UIImage imageNamed:@"red"];
    NSData *imageData = UIImageJPEGRepresentation(image, 1.0);

    if (!imageData) return;
    
    INImage *artWork = [INImage imageWithImageData:imageData];
    INMediaItem *item = [[INMediaItem alloc] initWithIdentifier:@"music"
                                                          title:@"red"
                                                          type:INMediaItemTypeMusic
                                                          artwork:artWork];
    INMediaSearch *mediaSearch = [[INMediaSearch alloc] initWithMediaType:INMediaItemTypeNews sortOrder:INMediaSortOrderNewest mediaName:@"red" artistName:@"taylor swift" albumName:@"red" genreNames:@[@"red"] moodNames:@[@"red"] releaseDate:nil reference:INMediaReferenceCurrentlyPlaying mediaIdentifier:@"red"];
    
    INSearchForMediaIntent *searchIntent = [[INSearchForMediaIntent alloc] initWithMediaItems:@[item] mediaSearch:mediaSearch];
    
    INInteraction *interaction = [[INInteraction alloc] initWithIntent:searchIntent response:nil];
    [interaction donateInteractionWithCompletion:^(NSError *error){
        if (error) {
            NSLog(@"donate error:%@", error.description);
        }else {
            NSLog(@"donate success");
        }
    }];
}


- (void)customIntentTest
{
    int loop = 10;
    for (int i = 0; i<loop; i++) {
        [self DonateIntet];
        
        NSLog(@"DonateIntet");
    }
}

- (void)deleteSiriDonate
{
    
//    INUpcomingMediaManager.sharedManager
    
    [INUpcomingMediaManager.sharedManager setSuggestedMediaIntents:nil];
    
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
//        [intentUserActivity becomeCurrent];
        
//        
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
