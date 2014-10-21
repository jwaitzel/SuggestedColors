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

@end


@class DVTMutableOrderedDictionary, DVTObservingToken, NSColor, NSMenu, NSString;

@interface DVTAbstractColorPicker : NSView <NSMenuDelegate>
{
    DVTMutableOrderedDictionary *_suggestedColors;
}

@property(retain) DVTMutableOrderedDictionary *suggestedColors; // @synthesize suggestedColors=_suggestedColors;

- (void)setSuggestedColorsUsingColorList:(id)arg1;

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
