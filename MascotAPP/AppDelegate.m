//
//  AppDelegate.m
//  MascotAPP
//
//  Created by Samuel on 29/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

@synthesize window = _window;
@synthesize managedObjectContext = __managedObjectContext;
@synthesize managedObjectModel = __managedObjectModel;
@synthesize persistentStoreCoordinator = __persistentStoreCoordinator;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
   
    [self customizeGlobalTheme];
    tabbarController = (UITabBarController *)self.window.rootViewController;
    
    [self actualizarBadgeEventos];
        
    UINavigationController *agendaNavigationController = (UINavigationController *)[tabbarController.viewControllers objectAtIndex:0];
    UINavigationController *gastosNavigationController = (UINavigationController *)[tabbarController.viewControllers objectAtIndex:1];
    UINavigationController *mascotasNavigationController = (UINavigationController *)[tabbarController.viewControllers objectAtIndex:2];
    
    MascotasTableViewController *controller = (MascotasTableViewController *)mascotasNavigationController.topViewController;
    AgendaEventosViewController *controller1 = (AgendaEventosViewController *)agendaNavigationController.topViewController;
    GastosTableViewController *controller2 = (GastosTableViewController *)gastosNavigationController.topViewController;
      
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque animated:YES];
    
    controller2.managedObjectContext = self.managedObjectContext;
    controller1.managedObjectContext = self.managedObjectContext;
    controller.managedObjectContext = self.managedObjectContext;
        
    return YES;
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    
    [[UIApplication sharedApplication] cancelLocalNotification:notification];   
}
- (void)customizeGlobalTheme
{
    UIImage *navBarImage = [UIImage imageNamed:@"menubar"];
    [[UINavigationBar appearance] setBackgroundImage:navBarImage forBarMetrics:UIBarMetricsDefault];
    
    
    UIImage *barButton = [[UIImage imageNamed:@"bar-button"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 5, 0, 5)];
    
    [[UIBarButtonItem appearance] setBackgroundImage:barButton forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
   
    UIImage *backButton = [[UIImage imageNamed:@"back"] resizableImageWithCapInsets:UIEdgeInsetsMake(0,15,0,8)];
    
    [[UIBarButtonItem appearance] setBackButtonBackgroundImage:backButton forState:UIControlStateNormal
                                                    barMetrics:UIBarMetricsDefault];
      
    UIImage* tabBarBackground = [UIImage imageNamed:@"tabbar"];
    [[UITabBar appearance] setBackgroundImage:tabBarBackground];
    [[UITabBar appearance] setSelectionIndicatorImage:[UIImage imageNamed:@"tabbar-item"]];
    [[UITabBar appearance] setSelectedImageTintColor:[UIColor whiteColor]];
        
    [[UITabBar appearance] setTintColor:[UIColor whiteColor]];
    
    [[UITabBarItem appearance] setTitleTextAttributes:@{ UITextAttributeTextColor : [UIColor whiteColor] }
                                             forState:UIControlStateNormal];
    
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIDeviceOrientation)orientation{

    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
    
    [self guardarBadgeEventos];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */

    [self actualizarBadgeEventos];
}

-(void) actualizarBadgeEventos {
    
    UITabBar *tb = [UITabBar new];
    tb = tabbarController.tabBar;
    
    UITabBarItem *tbi = [UITabBarItem new];
    
    tbi = [tb.items objectAtIndex:0];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Evento" inManagedObjectContext:self.managedObjectContext];
    
    [fetchRequest setEntity:entity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"hecho == NO and fecha<=%@",[NSDate date]];
    
    [fetchRequest setPredicate:predicate];
    
    NSError *error = nil;
    NSInteger countGastos = [self.managedObjectContext countForFetchRequest:fetchRequest error:&error];
    if (error) {
        NSLog(@"ERROR: %@", error);
    }
    
    if (countGastos > 0)
        [tbi setBadgeValue:[NSString stringWithFormat:@"%i",countGastos]];
    else [tbi setBadgeValue:nil];
    
}

- (void) guardarBadgeEventos{
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Evento" inManagedObjectContext:self.managedObjectContext];
    
    [fetchRequest setEntity:entity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"hecho == NO and fecha<=%@",[NSDate date]];
    
    [fetchRequest setPredicate:predicate];
    
    NSError *error = nil;
    NSInteger countGastos = [self.managedObjectContext countForFetchRequest:fetchRequest error:&error];
    if (error) {
        NSLog(@"ERROR: %@", error);
    }
    
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:countGastos];
}


- (void)applicationWillTerminate:(UIApplication *)application
{

    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil)
    {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error])
        {
            /*
             Replace this implementation with code to handle the error appropriately.
             
             abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
             */
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        } 
    }
}

#pragma mark - Core Data stack

/**
 Returns the managed object context for the application.
 If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
 */
- (NSManagedObjectContext *)managedObjectContext
{
    if (__managedObjectContext != nil)
    {
        return __managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil)
    {
        __managedObjectContext = [[NSManagedObjectContext alloc] init];
        [__managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return __managedObjectContext;
}

/**
 Returns the managed object model for the application.
 If the model doesn't already exist, it is created from the application's model.
 */

- (NSManagedObjectModel *)managedObjectModel
{
    if (__managedObjectModel != nil)
    {
        return __managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"MascotAPP" withExtension:@"momd"];
    __managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return __managedObjectModel;
}

/**
 Returns the persistent store coordinator for the application.
 If the coordinator doesn't already exist, it is created and the application's store added to it.
 */

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (__persistentStoreCoordinator != nil) {
        return __persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"MascotAPP.sqlite"];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:[storeURL path]]) {
        NSURL *preloadURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"MascotAPP" ofType:@"sqlite"]];
        NSError* err = nil;
        
        if (![[NSFileManager defaultManager] copyItemAtURL:preloadURL toURL:storeURL error:&err]) {
            NSLog(@"Oops, could copy preloaded data");
        }
    }
    
    NSError *error = nil;
    __persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![__persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }    
    
    return __persistentStoreCoordinator;}

#pragma mark - Application's Documents directory

/**
 Returns the URL to the application's Documents directory.
 */
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end
