TARGET := iphone:clang:latest:15.0
ARCHS := arm64 arm64e
INSTALL_TARGET_PROCESSES := SpringBoard
THEOS_PACKAGE_SCHEME := rootless

include $(THEOS)/makefiles/common.mk

# FLEX header search paths
FLEX_INCLUDES := \
  -Ivendor/FLEX/Classes \
  -Ivendor/FLEX/Classes/Core \
  -Ivendor/FLEX/Classes/Core/Controllers \
  -Ivendor/FLEX/Classes/Core/Views \
  -Ivendor/FLEX/Classes/Core/Views/Cells \
  -Ivendor/FLEX/Classes/Core/Views/Carousel \
  -Ivendor/FLEX/Classes/ObjectExplorers \
  -Ivendor/FLEX/Classes/ObjectExplorers/Sections \
  -Ivendor/FLEX/Classes/ObjectExplorers/Sections/Shortcuts \
  -Ivendor/FLEX/Classes/Toolbar \
  -Ivendor/FLEX/Classes/Manager \
  -Ivendor/FLEX/Classes/Utility \
  -Ivendor/FLEX/Classes/Utility/Categories \
  -Ivendor/FLEX/Classes/Utility/Categories/Private

FLEX_OBJC_SOURCES := \
  vendor/FLEX/Classes/Core/FLEXSingleRowSection.m \
  vendor/FLEX/Classes/Core/FLEXTableViewSection.m \
  vendor/FLEX/Classes/Core/Controllers/FLEXTableViewController.m \
  vendor/FLEX/Classes/Core/Controllers/FLEXNavigationController.m \
  vendor/FLEX/Classes/Core/Controllers/FLEXFilteringTableViewController.m \
  vendor/FLEX/Classes/Core/Views/Cells/FLEXKeyValueTableViewCell.m \
  vendor/FLEX/Classes/Core/Views/Cells/FLEXCodeFontCell.m \
  vendor/FLEX/Classes/Core/Views/Cells/FLEXSubtitleTableViewCell.m \
  vendor/FLEX/Classes/Core/Views/Cells/FLEXMultilineTableViewCell.m \
  vendor/FLEX/Classes/Core/Views/Cells/FLEXTableViewCell.m \
  vendor/FLEX/Classes/Core/Views/Carousel/FLEXScopeCarousel.m \
  vendor/FLEX/Classes/Core/Views/Carousel/FLEXCarouselCell.m \
  vendor/FLEX/Classes/Core/Views/FLEXTableView.m \
  vendor/FLEX/Classes/ObjectExplorers/FLEXObjectExplorerFactory.m \
  vendor/FLEX/Classes/ObjectExplorers/FLEXObjectExplorerViewController.m \
  vendor/FLEX/Classes/ObjectExplorers/FLEXObjectExplorer.m \
  vendor/FLEX/Classes/ObjectExplorers/Sections/FLEXMetadataSection.m \
  vendor/FLEX/Classes/ObjectExplorers/Sections/FLEXCollectionContentSection.m \
  vendor/FLEX/Classes/ObjectExplorers/Sections/FLEXMutableListSection.m \
  vendor/FLEX/Classes/ObjectExplorers/Sections/FLEXColorPreviewSection.m \
  vendor/FLEX/Classes/ObjectExplorers/Sections/FLEXDefaultsContentSection.m \
  vendor/FLEX/Classes/ObjectExplorers/Sections/Shortcuts/FLEXShortcutsSection.m \
  vendor/FLEX/Classes/ObjectExplorers/Sections/Shortcuts/FLEXShortcutsFactory+Defaults.m \
  vendor/FLEX/Classes/ObjectExplorers/Sections/Shortcuts/FLEXShortcut.m \
  vendor/FLEX/Classes/ObjectExplorers/Sections/Shortcuts/FLEXBlockShortcuts.m \
  vendor/FLEX/Classes/ObjectExplorers/Sections/Shortcuts/FLEXClassShortcuts.m \
  vendor/FLEX/Classes/ObjectExplorers/Sections/Shortcuts/FLEXImageShortcuts.m \
  vendor/FLEX/Classes/ObjectExplorers/Sections/Shortcuts/FLEXViewShortcuts.m \
  vendor/FLEX/Classes/ObjectExplorers/Sections/Shortcuts/FLEXBundleShortcuts.m \
  vendor/FLEX/Classes/ObjectExplorers/Sections/Shortcuts/FLEXWindowShortcuts.m \
  vendor/FLEX/Classes/ObjectExplorers/Sections/Shortcuts/FLEXNSStringShortcuts.m \
  vendor/FLEX/Classes/ObjectExplorers/Sections/Shortcuts/FLEXLayerShortcuts.m \
  vendor/FLEX/Classes/ObjectExplorers/Sections/Shortcuts/FLEXUIAppShortcuts.m \
  vendor/FLEX/Classes/ObjectExplorers/Sections/Shortcuts/FLEXViewControllerShortcuts.m \
  vendor/FLEX/Classes/ObjectExplorers/Sections/Shortcuts/FLEXNSDataShortcuts.m \
  vendor/FLEX/Classes/Toolbar/FLEXExplorerToolbarItem.m \
  vendor/FLEX/Classes/Toolbar/FLEXExplorerToolbar.m \
  vendor/FLEX/Classes/Manager/FLEXManager.m \
  vendor/FLEX/Classes/Manager/FLEXManager+Extensibility.m \
  vendor/FLEX/Classes/Utility/FLEXUtility.m \
  vendor/FLEX/Classes/Utility/FLEXResources.m \
  vendor/FLEX/Classes/Utility/FLEXColor.m \
  vendor/FLEX/Classes/Utility/Categories/NSArray+FLEX.m \
  vendor/FLEX/Classes/Utility/Categories/NSObject+FLEX_Reflection.m \
  vendor/FLEX/Classes/Utility/Categories/NSDateFormatter+FLEX.m \
  vendor/FLEX/Classes/Utility/Categories/NSTimer+FLEX.m \
  vendor/FLEX/Classes/Utility/Categories/UIGestureRecognizer+Blocks.m \
  vendor/FLEX/Classes/Utility/Categories/UIMenu+FLEX.m \
  vendor/FLEX/Classes/Utility/Categories/UIPasteboard+FLEX.m \
  vendor/FLEX/Classes/Utility/Categories/NSUserDefaults+FLEX.m \
  vendor/FLEX/Classes/Utility/Categories/UITextField+Range.m \
  vendor/FLEX/Classes/Utility/Categories/CALayer+FLEX.m \
  vendor/FLEX/Classes/Utility/Categories/UIFont+FLEX.m \
  vendor/FLEX/Classes/Utility/Categories/UIBarButtonItem+FLEX.m \
  vendor/FLEX/Classes/Utility/Categories/Private/UIView+FLEX_Layout.m \
  vendor/FLEX/Classes/Utility/Categories/Private/NSMapTable+FLEX_Subscripting.m \
  vendor/FLEX/Classes/Utility/Categories/Private/NSString+ObjcRuntime.m \
  vendor/FLEX/Classes/Utility/Categories/Private/NSString+FLEX.m \
  vendor/FLEX/Classes/Utility/Categories/Private/NSDictionary+ObjcRuntime.m

# Optional fishhook support if present
FLEX_FISHHOOK_SOURCES := $(shell find vendor/fishhook -type f -name "fishhook.c" 2>/dev/null)
FLEX_FISHHOOK_INCLUDES := $(shell find vendor/fishhook -type d | sed 's/^/-I/' 2>/dev/null)

FLEX_SOURCES := $(FLEX_OBJC_SOURCES) $(FLEX_FISHHOOK_SOURCES)
FLEX_ALL_INCLUDES := $(FLEX_INCLUDES) $(FLEX_FISHHOOK_INCLUDES)

TWEAK_NAME := FlexTool

FlexTool_FILES := \
  Sources/Tweak.xm \
  Sources/FTCore.m \
  Sources/FTPreferences.m \
  Sources/FLEXBridge.m \
  $(FLEX_OBJC_SOURCES)

FlexTool_CFLAGS += $(FLEX_INCLUDES)

FlexTool_FRAMEWORKS := UIKit Foundation QuartzCore CoreGraphics ImageIO WebKit Security SceneKit AVFoundation UserNotifications
FlexTool_LDFLAGS := -ObjC -lz -lsqlite3
FlexTool_LIBRARIES := substrate

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "sbreload || true"

LIBRARY_NAME := FlexToolLC

FlexToolLC_FILES := \
  Sources/LiveContainerEntry.m \
  Sources/FTCore.m \
  Sources/FTPreferences.m \
  Sources/FLEXBridge.m \
  $(FLEX_OBJC_SOURCES)

FlexToolLC_CFLAGS += $(FLEX_INCLUDES)

FlexToolLC_FRAMEWORKS := UIKit Foundation QuartzCore CoreGraphics ImageIO WebKit Security SceneKit AVFoundation UserNotifications
FlexToolLC_LDFLAGS := -ObjC -lz -lsqlite3
FlexToolLC_INSTALL_PATH := /usr/lib

include $(THEOS_MAKE_PATH)/library.mk