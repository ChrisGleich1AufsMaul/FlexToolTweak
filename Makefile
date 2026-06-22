TARGET := iphone:clang:latest:15.0
ARCHS := arm64 arm64e
INSTALL_TARGET_PROCESSES := SpringBoard
THEOS_PACKAGE_SCHEME := rootless

include $(THEOS)/makefiles/common.mk

# FLEX header search paths
FLEX_INCLUDES := $(shell find vendor/FLEX/Classes -type d | sed 's/^/-I/')

# FLEX sources
FLEX_OBJC_SOURCES := $(shell find vendor/FLEX/Classes -type f \( -name "*.m" -o -name "*.mm" \) 2>/dev/null)

# Optional/problematic modules excluded for first stable build
FLEX_OBJC_SOURCES := $(filter-out %FLEXFirebaseTransaction.mm,$(FLEX_OBJC_SOURCES))
FLEX_OBJC_SOURCES := $(filter-out %Firebase%,$(FLEX_OBJC_SOURCES))
FLEX_OBJC_SOURCES := $(filter-out %FLEXSystemLogViewController.m,$(FLEX_OBJC_SOURCES))
FLEX_OBJC_SOURCES := $(filter-out %FLEXOSLogController.m,$(FLEX_OBJC_SOURCES))
FLEX_OBJC_SOURCES := $(filter-out %FLEXOSLogMessage.m,$(FLEX_OBJC_SOURCES))
FLEX_OBJC_SOURCES := $(filter-out %FLEXSwiftInternal.mm,$(FLEX_OBJC_SOURCES))

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
	$(FLEX_SOURCES)

FlexTool_CFLAGS := \
	-fobjc-arc \
	-Wall \
	-Wno-error \
	-Wno-unused-parameter \
	-Wno-deprecated-declarations \
	-Wno-sign-compare \
	-Wno-shorten-64-to-32 \
	-Wno-unsupported-availability-guard \
	$(FLEX_ALL_INCLUDES)

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
	$(FLEX_SOURCES)

FlexToolLC_CFLAGS := \
	-fobjc-arc \
	-Wall \
	-Wno-error \
	-Wno-unused-parameter \
	-Wno-deprecated-declarations \
	-Wno-sign-compare \
	-Wno-shorten-64-to-32 \
	-Wno-unsupported-availability-guard \
	$(FLEX_ALL_INCLUDES)

FlexToolLC_FRAMEWORKS := UIKit Foundation QuartzCore CoreGraphics ImageIO WebKit Security SceneKit AVFoundation UserNotifications
FlexToolLC_LDFLAGS := -ObjC -lz -lsqlite3
FlexToolLC_INSTALL_PATH := /usr/lib

include $(THEOS_MAKE_PATH)/library.mk