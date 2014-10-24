//
//  Headers.h
//  Plugin
//
//  Created by Javi Waitzel on 10/20/14.
//  Copyright (c) 2014 Monsters Inc. All rights reserved.
//
#import <AppKit/AppKit.h>
#import <Cocoa/Cocoa.h>

@class DVTMapTable, DVTMutableOrderedSet;

@interface DVTMutableOrderedDictionary : NSMutableDictionary
{
    DVTMutableOrderedSet *set;
    DVTMapTable *backingMapTable;
}

- (id)mutableCopyWithZone:(struct _NSZone *)arg1;
- (id)copyWithZone:(struct _NSZone *)arg1;
- (id)allKeys;
- (id)lastValue;
- (id)lastKey;
- (id)firstValue;
- (id)firstKey;
- (void)removeObjectForKey:(id)arg1;
- (void)setObject:(id)arg1 forKey:(id)arg2;
- (id)keyEnumerator;
- (id)objectForKey:(id)arg1;
- (unsigned long long)count;
- (Class)classForCoder;
- (void)encodeWithCoder:(id)arg1;
- (id)initWithCoder:(id)arg1;
- (id)initWithObjects:(id)arg1 forKeys:(id)arg2;
- (id)initWithCapacity:(unsigned long long)arg1;

@end


@class DVTMutableOrderedDictionary, DVTObservingToken, NSColor, NSMenu, NSString;

@interface DVTAbstractColorPicker : NSView <NSMenuDelegate>
{
    NSMenu *_colorsMenu;
    id _colorValueBindingController;
    NSString *_colorValueBindingKeyPath;
    DVTObservingToken *_colorListBindingObservation;
    DVTObservingToken *_colorValueBindingObservation;
    DVTObservingToken *_supportsNilColorBindingObservation;
//    id <DVTCancellable> _windowActivationObservation;
    BOOL _supportsNilColor;
    BOOL _showingMultipleValues;
    BOOL _enabled;
    BOOL _active;
    BOOL _highlighted;
    int _defaultColorMode;
    NSColor *_color;
    DVTMutableOrderedDictionary *_suggestedColors;
    NSColor *_defaultColor;
    id _target;
    SEL _action;
    unsigned long long _controlSize;
}

@property(nonatomic, getter=isHighlighted) BOOL highlighted; // @synthesize highlighted=_highlighted;
@property(nonatomic, getter=isActive) BOOL active; // @synthesize active=_active;
@property(nonatomic, getter=isEnabled) BOOL enabled; // @synthesize enabled=_enabled;
@property(nonatomic) unsigned long long controlSize; // @synthesize controlSize=_controlSize;
@property SEL action; // @synthesize action=_action;
@property __weak id target; // @synthesize target=_target;
@property(getter=isShowingMultipleValues) BOOL showingMultipleValues; // @synthesize showingMultipleValues=_showingMultipleValues;
@property BOOL supportsNilColor; // @synthesize supportsNilColor=_supportsNilColor;
@property(nonatomic) int defaultColorMode; // @synthesize defaultColorMode=_defaultColorMode;
@property(retain, nonatomic) NSColor *defaultColor; // @synthesize defaultColor=_defaultColor;
@property(retain) DVTMutableOrderedDictionary *suggestedColors; // @synthesize suggestedColors=_suggestedColors;
@property(retain, nonatomic) NSColor *color; // @synthesize color=_color;

- (void)unbind:(id)arg1;
- (void)bind:(id)arg1 toObject:(id)arg2 withKeyPath:(id)arg3 options:(id)arg4;
- (void)observedColorValueDidChangeToValue:(id)arg1;
- (void)displayColorPanel:(id)arg1;
- (void)takeDrawnColorFrom:(id)arg1;
- (void)takeDrawnColorFromPopUpMenu:(id)arg1;
- (void)sendAction;
- (void)beginColorDragForEvent:(id)arg1;
- (id)imageForDraggedColor:(id)arg1;
- (BOOL)performDragOperation:(id)arg1;
- (unsigned long long)draggingEntered:(id)arg1;
- (void)colorPanelColorChanged:(id)arg1;
- (void)colorPanelWillClose:(id)arg1;
- (void)window:(id)arg1 didChangeActivationState:(long long)arg2;
- (void)colorPickerDidBecomeActive:(id)arg1;
- (void)colorChosenFromColorChooser:(id)arg1;
- (void)moveUp:(id)arg1;
- (void)moveDown:(id)arg1;
- (void)performClick:(id)arg1;
- (void)displayColorPanel;
- (BOOL)canBecomeKeyView;
- (BOOL)becomeFirstResponder;
- (BOOL)resignFirstResponder;
- (BOOL)acceptsFirstResponder;
- (BOOL)acceptsFirstMouse:(id)arg1;
- (void)viewWillMoveToWindow:(id)arg1;
- (void)showColorsMenu;
- (double)minimumPopUpMenuWidth;
- (struct CGPoint)popUpMenuLocation;
- (id)effectiveSwatchFillColor;
- (void)putIntoMultipleValuesState;
- (void)populateColorsMenu;
- (double)swatchHeight;
- (id)swatchImageForColor:(id)arg1 withSize:(struct CGSize)arg2;
- (id)effectiveSwatchBorderColor;
- (id)effectiveTextColor;
- (BOOL)isShowingTitle;
- (BOOL)isShowingDefaultColor;
- (BOOL)isShowingNamedColor;
- (BOOL)supportsDefaultColor;
- (double)noColorStrokeWidth;
- (id)titleFont;
- (void)setSuggestedColorsUsingColorList:(id)arg1;
- (BOOL)isOnActiveWindow;
- (id)nameForColor:(id)arg1;
- (BOOL)containsColor:(id)arg1;
- (void)encodeWithCoder:(id)arg1;
- (id)initWithCoder:(id)arg1;
- (id)initWithFrame:(struct CGRect)arg1 colorList:(id)arg2 defaultColor:(id)arg3 defaultColorMode:(int)arg4;
- (id)initWithFrame:(struct CGRect)arg1;
- (void)commonInit;

@end

@interface DVTColorPickerPopUpButton : DVTAbstractColorPicker

@end



@interface IDEInspectorColorProperty : NSObject
{
    DVTColorPickerPopUpButton *_popUpButton;
}

@end





//// IDE WORKSPACe
@class DVTFilePath;
@class DVTFilePath, DVTHashTable, DVTMapTable, DVTObservingToken, DVTStackBacktrace, IDEActivityLogSection, IDEBatchFindManager, IDEBreakpointManager, IDEConcreteClientTracker, IDEContainer, IDEContainer, IDEContainerQuery, IDEDeviceInstallWorkspaceMonitor, IDEExecutionEnvironment, IDEIndex, IDEIssueManager, IDELogManager, IDERefactoring, IDERunContextManager, IDESourceControlWorkspaceMonitor, IDETestManager, IDETextIndex, IDEWorkspaceArena, IDEWorkspaceBotMonitor, IDEWorkspaceSharedSettings, IDEWorkspaceSnapshotManager, IDEWorkspaceUserSettings, NSDictionary, NSHashTable, NSMapTable, NSMutableArray, NSMutableOrderedSet, NSMutableSet, NSSet, NSString;

@interface IDEWorkspace : NSObject
{
    NSString *_untitledName;
    DVTFilePath *_headerMapFilePath;
    IDEExecutionEnvironment *_executionEnvironment;
    IDEContainerQuery *_containerQuery;
    DVTObservingToken *_containerQueryObservingToken;
    NSMutableSet *_referencedContainers;
    DVTHashTable *_fileRefsWithContainerLoadingIssues;
    IDEActivityLogSection *_containerLoadingIntegrityLog;
    NSMutableSet *_customDataStores;
    IDEWorkspaceUserSettings *_userSettings;
    IDEWorkspaceSharedSettings *_sharedSettings;
    DVTMapTable *_blueprintProviderObserverMap;
    NSMutableSet *_referencedBlueprints;
    DVTMapTable *_testableProviderObserverMap;
    NSMutableSet *_referencedTestables;
    BOOL _initialContainerScanComplete;
    NSMutableArray *_referencedRunnableBuildableProducts;
    IDERunContextManager *_runContextManager;
    IDELogManager *_logManager;
    IDEIssueManager *_issueManager;
    IDEBreakpointManager *_breakpointManager;
    IDEBatchFindManager *_batchFindManager;
    IDETestManager *_testManager;
    IDEContainerQuery *_indexableSourceQuery;
    DVTObservingToken *_indexableSourceQueryObservingToken;
    NSMutableArray *_observedIndexableSources;
    IDEContainerQuery *_indexableFileQuery;
    DVTObservingToken *_indexableFileQueryObservingToken;
    id _indexableFileUpdateNotificationToken;
    IDEIndex *_index;
    IDERefactoring *_refactoring;
    DVTMapTable *_fileRefsToResolvedFilePaths;
    NSMutableSet *_fileRefsToRegisterForIndexing;
    IDETextIndex *_textIndex;
    IDEDeviceInstallWorkspaceMonitor *_deviceInstallWorkspaceMonitor;
    IDESourceControlWorkspaceMonitor *_sourceControlWorkspaceMonitor;
    IDEWorkspaceSnapshotManager *_snapshotManager;
    DVTFilePath *_wrappedXcode3ProjectPath;
    DVTObservingToken *_wrappedXcode3ProjectValidObservingToken;
    DVTObservingToken *_newWrappedXcode3ProjectObservingToken;
    NSHashTable *_pendingReferencedFileReferences;
    NSHashTable *_pendingReferencedContainers;
    IDEConcreteClientTracker *_clientTracker;
    DVTHashTable *_fileReferencesForProblem8727051;
    DVTObservingToken *_finishedLoadingObservingToken;
    NSDictionary *_Problem9887530_preferredStructurePaths;
    BOOL _simpleFilesFocused;
    DVTHashTable *_sourceControlStatusUpdatePendingFileReferences;
    id _openingPerformanceMetricIdentifier;
    DVTStackBacktrace *_finishedLoadingBacktrace;
    NSMutableOrderedSet *_initialOrderedReferencedBlueprintProviders;
    BOOL _hasPostedIndexingRegistrationBatchNotification;
    BOOL _didFinishLoadingFirstStage;
    BOOL _finishedLoading;
    BOOL _postLoadingPerformanceMetricsAllowed;
    BOOL _willInvalidate;
    BOOL _pendingFileReferencesAndContainers;
    BOOL _didProcessFileReferencesForProblem8727051;
    BOOL _isCleaningBuildFolder;
    BOOL _indexingAndRefactoringRestartScheduled;
    BOOL _sourceControlStatusUpdatePending;
    BOOL _didFinishBuildingInitialBlueprintProviderOrderedSet;
    NSMapTable *_pendingExecutionNotificationTokens;
    IDEWorkspaceBotMonitor *_workspaceBotMonitor;
}
@property (readonly) DVTFilePath *representingFilePath;
@property(retain, nonatomic) IDEWorkspaceUserSettings *userSettings; // @synthesize userSettings=_userSettings;

- (id)_wrappingContainerPath;
+ (id)rootElementName;

@end

@interface DVTFilePath : NSObject
@property (readonly) NSString *fileName;
@property (readonly) NSURL *fileURL;
@property (readonly) NSArray *pathComponents;
@property (readonly) NSString *pathString;
@end


@interface DVTDualProxyWindow : NSWindow
@end

@interface IDEWorkspaceWindow : DVTDualProxyWindow
@end


@class DVTObservingToken, DVTStackBacktrace, DVTStateToken, DVTTabBarEnclosureView, DVTTabBarView, DVTTabSwitcher, IDEEditorArea, IDESourceControlWorkspaceUIHandler, IDEToolbarDelegate, IDEWorkspace, IDEWorkspaceTabController, IDEWorkspaceWindow, NSMapTable, NSMutableArray, NSString, NSTimer, _IDEWindowFullScreenSavedDebuggerTransitionValues;

@interface IDEWorkspaceWindowController : NSWindowController <NSWindowDelegate>
{

}


@end


@interface IDEEditorDocument : NSDocument
@property(retain) DVTFilePath *filePath; // @synthesize filePath=_filePath;
@end


@interface IDEPlistDocument : IDEEditorDocument

@end
