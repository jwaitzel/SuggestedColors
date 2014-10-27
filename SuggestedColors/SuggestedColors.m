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
#import "XcodeEditor.h"

static NSString * const IDEEditorDocumentDidChangeNotification = @"IDEEditorDocumentDidChangeNotification";

static NSString * const SuggestedColorsPlistName = @"SuggestedColors.plist";


#define NSColorFromRGB(rgbValue) [NSColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

static SuggestedColors *sharedPlugin;

@interface SuggestedColors ()

@property (nonatomic, strong, readwrite) NSBundle *bundle;
@property (nonatomic, strong) NSMutableDictionary *suggestedColorsDic;
@property (nonatomic, strong) NSString *projectBundlePath;
@property (nonatomic, strong) NSString *projectWorkspacePath;
@property (nonatomic, assign) BOOL menuItemAlreadyCreated;
@property (nonatomic, strong) NSMenuItem * createFileMenuItem;
@property (nonatomic, strong) NSMenuItem * separatorItem;
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
      
//      [[NSNotificationCenter defaultCenter] addObserver:self
//                                               selector:@selector(notificationListener:)
//                                                   name:nil
//                                                 object:nil];
      
      
      [[NSNotificationCenter defaultCenter] addObserver:self
                                               selector:@selector(documentDidChange:)
                                                   name:IDEEditorDocumentDidChangeNotification
                                                 object:nil];
      
      NSError * error;
      [objc_getClass("DVTAbstractColorPicker") aspect_hookSelector:@selector(setSuggestedColors:) withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo> par){
          
          if (self.suggestedColorsDic) {

              if([self.suggestedColorsDic objectForKey:@"useMyColors"] == nil || [[self.suggestedColorsDic objectForKey:@"useMyColors"] boolValue])
              {
                  DVTAbstractColorPicker * colorPicker = (DVTAbstractColorPicker *) par.instance;
                  DVTMutableOrderedDictionary * dic =  [[objc_getClass("DVTMutableOrderedDictionary") alloc] initWithObjects:[[self.suggestedColorsDic objectForKey:@"colors"] allObjects] forKeys:[[self.suggestedColorsDic objectForKey:@"colors"] allKeys]];
                  
                  [colorPicker setValue:dic forKey:@"_suggestedColors"];
              }
          }
          
      }error:&error];

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
        
        self.projectWorkspacePath = [representingFilePath.pathString stringByReplacingOccurrencesOfString:@".xcworkspace"
                                                                                               withString:@".xcodeproj"];
        
        self.projectBundlePath = [representingFilePath.pathString stringByReplacingOccurrencesOfString:@".xcodeproj"
                                                                                        withString:@"/"];
        [self reloadColors:nil];

    }
}

-(void) reloadColors:(id) sender
{
    
    if(self.projectBundlePath == nil)
        return;
    
    XCProject * proj = [[XCProject alloc] initWithFilePath:self.projectWorkspacePath];
    XCSourceFile * suggestedColorsFile = [proj fileWithName:SuggestedColorsPlistName];
    
    if(suggestedColorsFile)
    {
        NSString * pathFile = [[[proj filePath] stringByDeletingLastPathComponent] stringByAppendingPathComponent:[suggestedColorsFile pathRelativeToProjectRoot]];
        self.suggestedColorsDic = [NSMutableDictionary dictionaryWithDictionary:[NSDictionary dictionaryWithContentsOfFile:pathFile]];
        
        NSMutableDictionary * newDic = [NSMutableDictionary dictionary];
        for (NSString * color in [self.suggestedColorsDic objectForKey:@"colors"]) {
            unsigned colorInt = 0;
            [[NSScanner scannerWithString:[[self.suggestedColorsDic objectForKey:@"colors"] objectForKey:color]] scanHexInt:&colorInt];
            NSColor * colorValue = NSColorFromRGB(colorInt);
            [newDic setObject:colorValue forKey:color];
        }
        
        [newDic setObject:[NSColor whiteColor] forKey:@"White color"];
        [newDic setObject:[NSColor clearColor] forKey:@"Clear color"];
        
        [self.suggestedColorsDic setObject:newDic forKey:@"colors"];
    }
    else{
        
        // Create menu items, initialize UI, etc.
        // Sample Menu Item:
        if(!self.menuItemAlreadyCreated)
        {
            NSMenuItem *editMenuItem = [[NSApp mainMenu] itemWithTitle:@"Edit"];
            
            if(editMenuItem)
            {
                self.separatorItem = [NSMenuItem separatorItem];
                [editMenuItem.submenu addItem:self.separatorItem];
                
                self.createFileMenuItem = [[NSMenuItem alloc] initWithTitle:@"Create SuggestedColors file" action:@selector(createSuggestedColorsFile:) keyEquivalent:@""];
                [self.createFileMenuItem setTarget:self];
                [[editMenuItem submenu] addItem:self.createFileMenuItem];
                
                self.menuItemAlreadyCreated = YES;
            }
        }
        
        NSLog(@"Suggested colors file not found...");
    }
}

-(void) createSuggestedColorsFile:(id) sender
{
    NSDictionary * dictionary = @{@"colors" : @{@"My Custom Color" : @"ff7373"}, @"useMyColors" : @YES};
    NSError * error;
    NSData * dicDat = [NSPropertyListSerialization dataWithPropertyList:dictionary format:NSPropertyListXMLFormat_v1_0 options:0 error:&error];
    if (error) {
        return;
    }
    
    NSMenuItem *editMenuItem = [[NSApp mainMenu] itemWithTitle:@"Edit"];
    if(editMenuItem)
    {
        [editMenuItem.submenu removeItem:self.separatorItem];
        [editMenuItem.submenu removeItem:self.createFileMenuItem];
    }
    
    XCProject * proj = [[XCProject alloc] initWithFilePath:self.projectWorkspacePath];
    NSString * projName = [[[proj filePath] lastPathComponent] stringByDeletingPathExtension];
    XCGroup * topGroup = [[proj rootGroup] memberWithDisplayName:projName];
    if(!topGroup)
    {
        topGroup = [proj rootGroup];
    }
    
    XCSourceFileDefinition * sourceFileDef = [XCSourceFileDefinition sourceDefinitionWithName:SuggestedColorsPlistName data:dicDat type:PropertyList];
    [topGroup addSourceFile:sourceFileDef];
    [proj save];

}


- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void) documentDidChange:(NSNotification *) notification
{
    id doc = notification.object;
    if([doc isKindOfClass:objc_getClass("IDEPlistDocument")])
    {
        if ([[[doc filePath] fileName] isEqualToString:SuggestedColorsPlistName]) {
            [self reloadColors:nil];
        }
        
    }
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
