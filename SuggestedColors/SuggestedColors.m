//
// Plugin.m
// Plugin
//
// Created by Javi Waitzel on 10/16/14.
// Copyright (c) 2014 Monsters Inc. All rights reserved.
//

#import <objc/runtime.h>

#import "SuggestedColors.h"
#import "Aspects.h"
#import <AppKit/AppKit.h>
#import "Headers.h"
#import "ColorsViewController.h"
#import "XcodeEditor.h"

static NSString*const IDEEditorDocumentDidChangeNotification = @"IDEEditorDocumentDidChangeNotification";

static NSString*const SuggestedColorsPlistName               = @"SuggestedColors.plist";



#define NSColorFromRGBA(rgbValue, alpha_) [NSColor colorWithCalibratedRed: ( (float) ( (rgbValue & 0xFF0000) >> 16 ) ) / 255.0 green: ( (float) ( (rgbValue & 0xFF00) >> 8 ) ) / 255.0 blue: ( (float) (rgbValue & 0xFF) ) / 255.0 alpha: alpha_]

#define NSColorFromRGB(rgbValue) NSColorFromRGBA(rgbValue, 1.0)

static SuggestedColors *sharedPlugin;
NSMutableDictionary    *suggestedColorsDic;

@interface SuggestedColors ()

@property (nonatomic, strong, readwrite) NSBundle *bundle;
@property (nonatomic, strong) NSString            *projectBundlePath;
@property (nonatomic, strong) NSString            *projectWorkspacePath;
@property (nonatomic, assign) BOOL                 menuItemAlreadyCreated;
@property (nonatomic, strong) NSMenuItem          *createFileMenuItem;
@property (nonatomic, strong) NSMenuItem          *separatorItem;
@end

@implementation SuggestedColors

+ (void)pluginDidLoad:(NSBundle*)plugin
{
    static dispatch_once_t onceToken;
    NSString              *currentApplicationName = [[NSBundle mainBundle] infoDictionary][@"CFBundleName"];

    if ([currentApplicationName isEqual:@"Xcode"])
    {
        dispatch_once(&onceToken, ^{
            sharedPlugin = [[self alloc] initWithBundle:plugin];
        });
    }
} /* pluginDidLoad */

+ (instancetype)sharedPlugin
{
    return sharedPlugin;
}

- (id)initWithBundle:(NSBundle*)plugin
{
    if (self = [super init])
    {
        // reference to plugin's bundle, for resource access
        self.bundle = plugin;

        // Register to notification center
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(workspaceWindowDidBecomeMain:)
                                                     name:NSWindowDidBecomeMainNotification
                                                   object:nil];

// [[NSNotificationCenter defaultCenter] addObserver:self
// selector:@selector(notificationListener:)
// name:nil
// object:nil];


        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(documentDidChange:)
                                                     name:IDEEditorDocumentDidChangeNotification
                                                   object:nil];

        NSError *error;
        [objc_getClass("DVTAbstractColorPicker") aspect_hookSelector:@selector(setSuggestedColors:) withOptions:AspectPositionAfter usingBlock: ^(id < AspectInfo > par){
            if (suggestedColorsDic)
            {
                if( ( [suggestedColorsDic objectForKey:@"useMyColors"] == nil) || [[suggestedColorsDic objectForKey:@"useMyColors"] boolValue] )
                {
                    DVTAbstractColorPicker *colorPicker = (DVTAbstractColorPicker*) par.instance;
                    DVTMutableOrderedDictionary *dic = [[objc_getClass("DVTMutableOrderedDictionary") alloc]
                                                        initWithObjects:[[suggestedColorsDic objectForKey:@"colors"] allObjects]
                                                                forKeys:[[suggestedColorsDic objectForKey:@"colors"] allKeys]];

                    [colorPicker setValue:dic forKey:@"_suggestedColors"];
                }
            }
        } error:&error];
    }
    return self;
} /* initWithBundle */

// Get current Workspace
- (void)workspaceWindowDidBecomeMain:(NSNotification*)notification
{
    if ([[notification object] isKindOfClass:[IDEWorkspaceWindow class]])
    {
        NSWindow           *workspaceWindow           = (NSWindow*) [notification object];
        NSWindowController *workspaceWindowController = (NSWindowController*) workspaceWindow.windowController;
        IDEWorkspace       *workspace                 = (IDEWorkspace*) [workspaceWindowController valueForKey:@"_workspace"];
        DVTFilePath        *representingFilePath      = workspace.representingFilePath;

        self.projectWorkspacePath = [representingFilePath.pathString stringByReplacingOccurrencesOfString:@".xcworkspace"
                                                                                               withString:@".xcodeproj"];

        self.projectBundlePath    = [representingFilePath.pathString stringByReplacingOccurrencesOfString:@".xcodeproj"
                                                                                               withString:@"/"];
        [self reloadColors:nil];
    }
} /* workspaceWindowDidBecomeMain */

- (void)reloadColors:(id)sender
{
    if(self.projectBundlePath == nil)
    {
        return;
    }

    XCProject    *proj                = [[XCProject alloc] initWithFilePath:self.projectWorkspacePath];
    XCSourceFile *suggestedColorsFile = [proj fileWithName:SuggestedColorsPlistName];

    if(suggestedColorsFile)
    {
        NSString *pathFile          = [[[proj filePath] stringByDeletingLastPathComponent] stringByAppendingPathComponent:[suggestedColorsFile pathRelativeToProjectRoot]];
        suggestedColorsDic = [NSMutableDictionary dictionaryWithDictionary:[NSDictionary dictionaryWithContentsOfFile:pathFile]];

        NSMutableDictionary *newDic = [NSMutableDictionary dictionary];

        for (NSString *color in [suggestedColorsDic objectForKey:@"colors"])
        {
            NSString *colorString = [[suggestedColorsDic objectForKey:@"colors"] objectForKey:color];

            // [self parseColorString:@"rgb(121,122,123)"];
            // [self parseColorString:@"rgba(121,122,123, 0.5)"];
            // [self parseColorString:@"123456"];
            // [self parseColorString:@"123456,0.5"];

            NSColor *colorValue = [self parseColorString:colorString];
            [newDic setObject:colorValue forKey:color];
        }

        // [newDic setObject:[NSColor whiteColor] forKey:@"White color"];
        // [newDic setObject:[NSColor clearColor] forKey:@"Clear color"];

        [suggestedColorsDic setObject:newDic forKey:@"colors"];
    }
    else
    {
        // Create menu items, initialize UI, etc.
        // Sample Menu Item:
        if(!self.menuItemAlreadyCreated)
        {
            NSMenuItem *editMenuItem = [[NSApp mainMenu] itemWithTitle:@"Edit"];

            if(editMenuItem)
            {
                self.separatorItem          = [NSMenuItem separatorItem];
                [editMenuItem.submenu addItem:self.separatorItem];

                self.createFileMenuItem     = [[NSMenuItem alloc] initWithTitle:@"Create SuggestedColors file" action:@selector(createSuggestedColorsFile:) keyEquivalent:@""];
                [self.createFileMenuItem setTarget:self];
                [[editMenuItem submenu] addItem:self.createFileMenuItem];

                self.menuItemAlreadyCreated = YES;
            }
        }

        NSLog(@"Suggested colors file not found...");
    }
} /* reloadColors */

- (NSColor*)parseColorString:(NSString*)colorString
{
    NSColor *colorValue = [NSColor whiteColor];

    colorString = [colorString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];

    // Color in rgb(x,x,x) format
    if ([colorString rangeOfString:@"rgb("].length > 0)
    {
        colorString = [colorString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        char *rgbChars = (char*) [[[colorString stringByReplacingOccurrencesOfString:@"rgb(" withString:@""] stringByReplacingOccurrencesOfString:@")" withString:@""] cStringUsingEncoding:NSUTF8StringEncoding];
        int   r        = atoi( strtok(rgbChars, ",") );
        int   g        = atoi( strtok(NULL, ",") );
        int   b        = atoi( strtok(NULL, ",") );

        // NSLog(@"r:%i, g:%i, b:%i", r,g,b);
        colorValue = [NSColor colorWithCalibratedRed:r / 255.0
                                               green:g / 255.0
                                                blue:b / 255.0
                                               alpha:1.0];
    }// Color in rgba(x,x,x,a) format
    else if ([colorString rangeOfString:@"rgba("].length > 0)
    {
        colorString = [colorString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        char   *rgbChars = (char*) [[[colorString stringByReplacingOccurrencesOfString:@"rgba(" withString:@""] stringByReplacingOccurrencesOfString:@")" withString:@""] cStringUsingEncoding:NSUTF8StringEncoding];
        int     r        = atoi( strtok(rgbChars, ",") );
        int     g        = atoi( strtok(NULL, ",") );
        int     b        = atoi( strtok(NULL, ",") );
        CGFloat a        = atof( strtok(NULL, ",") );
        a          = MAX( 0, MIN(a, 1.0) );
        NSLog(@"r:%i, g:%i, b:%i a:%.f", r, g, b, a);
        colorValue = [NSColor colorWithCalibratedRed:r / 255.0
                                               green:g / 255.0
                                                blue:b / 255.0
                                               alpha:a];
    }
    // Color in hex format
    else
    {
        unsigned colorInt     = 0;
        NSArray *components   = [colorString componentsSeparatedByString:@","];

        NSString *hexString   = colorString;
        NSString *alphaString = nil;

        if (components.count == 2)
        {
            hexString   = [components objectAtIndex:0];
            alphaString = [components objectAtIndex:1];
        }

        [[NSScanner scannerWithString:hexString] scanHexInt:&colorInt];

        if (alphaString.length > 0)
        {
            float alpha = 1.0;
            [[NSScanner scannerWithString:alphaString] scanFloat:&alpha];

            colorValue = NSColorFromRGBA(colorInt, alpha);
        }
        else
        {
            colorValue = NSColorFromRGB(colorInt);
        }
    }

    return colorValue;
} /* parseColorString */

- (void)createSuggestedColorsFile:(id)sender
{
    NSDictionary *dictionary = @{@"colors":@{ @"Hex Format":@"ff7373"
                                              , @"HEX alpha Format":@"ff7373,0.8"
                                              , @"RGB Format":@"rgb(128,128,128)"
                                              , @"RGBA Format":@"rgba(128,128,128,0.5"}
                                 , @"useMyColors":@YES};
    NSError *error;
    NSData  *dicDat = [NSPropertyListSerialization dataWithPropertyList:dictionary format:NSPropertyListXMLFormat_v1_0 options:0 error:&error];

    if (error)
    {
        return;
    }

    NSMenuItem *editMenuItem = [[NSApp mainMenu] itemWithTitle:@"Edit"];

    if(editMenuItem)
    {
        [editMenuItem.submenu removeItem:self.separatorItem];
        [editMenuItem.submenu removeItem:self.createFileMenuItem];
    }

    XCProject *proj     = [[XCProject alloc] initWithFilePath:self.projectWorkspacePath];
    NSString  *projName = [[[proj filePath] lastPathComponent] stringByDeletingPathExtension];
    XCGroup   *topGroup = [[proj rootGroup] memberWithDisplayName:projName];

    if(!topGroup)
    {
        topGroup = [proj rootGroup];
    }

    XCSourceFileDefinition *sourceFileDef = [XCSourceFileDefinition sourceDefinitionWithName:SuggestedColorsPlistName data:dicDat type:PropertyList];
    [topGroup addSourceFile:sourceFileDef];
    [proj save];
} /* createSuggestedColorsFile */

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)documentDidChange:(NSNotification*)notification
{
    id doc = notification.object;

    if([doc isKindOfClass:objc_getClass("IDEPlistDocument")])
    {
        if ([[[doc filePath] fileName] isEqualToString:SuggestedColorsPlistName])
        {
            [self reloadColors:nil];
        }
    }
} /* documentDidChange */

- (void)notificationListener:(NSNotification*)notification
{
    // let's filter all the "normal" NSxxx events so that we only
    // really see the Xcode specific events.
    if ( ([[notification name] length] >= 2) && [[[notification name] substringWithRange:NSMakeRange(0, 2)] isEqualTo:@"NS"] )
    {
        return;
    }
    else
    {
        NSLog(@"  Notification: %@", [notification name]);
    }
} /* notificationListener */

@end
