//
//  Plugin.m
//  Plugin
//
//  Created by Javi Waitzel on 10/16/14.
//    Copyright (c) 2014 Monsters Inc. All rights reserved.
//

#import <objc/runtime.h>

#import "SuggestedColors.h"
#import "Aspects.h"
#import <AppKit/AppKit.h>
#import "Headers.h"
#import "ColorsViewController.h"

#define NSColorFromRGB(rgbValue) [NSColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

static SuggestedColors *sharedPlugin;

@interface SuggestedColors ()

@property (nonatomic, strong, readwrite) NSBundle *bundle;
@property (nonatomic, strong) NSMutableDictionary *suggestedColorsDic;
@property (nonatomic, strong) NSString *projectFilePath;

@end

@implementation SuggestedColors

+ (void)pluginDidLoad:(NSBundle *)plugin {
	static dispatch_once_t onceToken;
	NSString *currentApplicationName = [[NSBundle mainBundle] infoDictionary][@"CFBundleName"];
	if ([currentApplicationName isEqual:@"Xcode"]) {
		dispatch_once(&onceToken, ^{
		    sharedPlugin = [[self alloc] initWithBundle:plugin];
		});
	}
}

+ (instancetype)sharedPlugin {
	return sharedPlugin;
}

- (id)initWithBundle:(NSBundle *)plugin {
	if (self = [super init]) {
		// reference to plugin's bundle, for resource access
		self.bundle = plugin;

      // Register to notification center

      
      [[NSNotificationCenter defaultCenter] addObserver:self
                                               selector:@selector(workspaceWindowDidBecomeMain:)
                                                   name:NSWindowDidBecomeMainNotification
                                                 object:nil];
      
      [[NSNotificationCenter defaultCenter] addObserver:self
                                               selector:@selector(notificationListener:)
                                                   name:nil
                                                 object:nil];
      
      NSError * error;
      [objc_getClass("DVTAbstractColorPicker") aspect_hookSelector:@selector(setSuggestedColorsUsingColorList:) withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo> par){
          
          if([self.suggestedColorsDic objectForKey:@"useMyColors"] == nil || [[self.suggestedColorsDic objectForKey:@"useMyColors"] boolValue])
          {
              DVTAbstractColorPicker * colorPicker = (DVTAbstractColorPicker *) par.instance;
              colorPicker.suggestedColors = [self.suggestedColorsDic objectForKey:@"colors"];
          }
      }error:&error];
      

      
		// Create menu items, initialize UI, etc.
		// Sample Menu Item:
      NSMenuItem *editMenuItem = [[NSApp mainMenu] itemWithTitle:@"Edit"];
      
      if(editMenuItem)
      {
          [editMenuItem.submenu addItem:[NSMenuItem separatorItem]];
          
          NSMenuItem *actionMenuItem = [[NSMenuItem alloc] initWithTitle:@"Reload colors" action:@selector(reloadColors:) keyEquivalent:@""];
          [actionMenuItem setTarget:self];
          [[editMenuItem submenu] addItem:actionMenuItem];
      }

	}
	return self;
}


// Get current Workspace
- (void)workspaceWindowDidBecomeMain:(NSNotification *)notification
{
    if ([[notification object] isKindOfClass:[IDEWorkspaceWindow class]]) {
        NSWindow *workspaceWindow = (NSWindow *)[notification object];
        NSWindowController *workspaceWindowController = (NSWindowController *)workspaceWindow.windowController;
        IDEWorkspace *workspace = (IDEWorkspace *)[workspaceWindowController valueForKey:@"_workspace"];
        DVTFilePath *representingFilePath = workspace.representingFilePath;
        
        self.projectFilePath = [representingFilePath.pathString stringByReplacingOccurrencesOfString:@".xcodeproj"
                                                                                        withString:@"/"];
        
        
        [self reloadColors:nil];

    }
}

-(void) reloadColors:(id) sender
{
    NSString * filePath = [self.projectFilePath stringByAppendingPathComponent:@"SuggestedColors.plist"];
    if([[NSFileManager defaultManager] fileExistsAtPath:filePath])
    {
        
        self.suggestedColorsDic = [NSMutableDictionary dictionaryWithDictionary:[NSDictionary dictionaryWithContentsOfFile:filePath]];
        
        NSMutableDictionary * newDic = [NSMutableDictionary dictionary];
        for (NSString * color in [self.suggestedColorsDic objectForKey:@"colors"]) {
            unsigned colorInt = 0;
            [[NSScanner scannerWithString:[[self.suggestedColorsDic objectForKey:@"colors"] objectForKey:color]] scanHexInt:&colorInt];
            NSColor * colorValue = NSColorFromRGB(colorInt);
            [newDic setObject:colorValue forKey:color];
        }
        
        [self.suggestedColorsDic setObject:newDic forKey:@"colors"];
    }
    else{
        NSLog(@"Suggested colors file not found...");
    }
}


- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)notificationListener:(NSNotification *)notification {
    // let's filter all the "normal" NSxxx events so that we only
    // really see the Xcode specific events.
    if ([[notification name] length] >= 2 && [[[notification name] substringWithRange:NSMakeRange(0, 2)] isEqualTo:@"NS"])
        return;
    else
        NSLog(@"  Notification: %@", [notification name]);
}

@end
