# ─────────────────────────────────────────────
# MARK: - Theos Konfiguration
# ─────────────────────────────────────────────

TARGET := iphone:clang:latest:15.0
ARCHS := arm64 arm64e
INSTALL_TARGET_PROCESSES := SpringBoard
THEOS_PACKAGE_SCHEME := rootless

include $(THEOS)/makefiles/common.mk


# ─────────────────────────────────────────────
# MARK: - FLEX Include-Pfade
# ─────────────────────────────────────────────

FLEX_INCLUDES := \
    -Ivendor/FLEX/Classes \
    -Ivendor/FLEX/Classes/Manager \
    -Ivendor/FLEX/Classes/Toolbar \
    -Ivendor/FLEX/Classes/Utility \
    -Ivendor/FLEX/Classes/Network \
    -Ivendor/FLEX/Classes/ObjectExplorers \
    -Ivendor/FLEX/Classes/GlobalStateExplorers \
    -Ivendor/FLEX/Classes/ExplorerInterface \
    -Ivendor/FLEX/Classes/Editing \
    -Ivendor/FLEX/Classes/ViewHierarchy

# FLEX-Quelldateien automatisch einsammeln
FLEX_SOURCES := $(shell find vendor/FLEX/Classes -name "*.m" 2>/dev/null)


# ─────────────────────────────────────────────
# MARK: - Rootless Tweak Target
# ─────────────────────────────────────────────

TWEAK_NAME := FlexTool

FlexTool_FILES := \
    Sources/Tweak.xm \
    Sources/FTCore.m \
    Sources/FTSceneMonitor.m \
    Sources/FTPreferences.m \
    Sources/FLEXBridge.m \
    $(FLEX_SOURCES)

FlexTool_CFLAGS := \
    -fobjc-arc \
    -Wall \
    -Wextra \
    -Wno-unused-parameter \
    -Wno-deprecated-declarations \
    $(FLEX_INCLUDES)

FlexTool_FRAMEWORKS := UIKit Foundation QuartzCore CoreGraphics ImageIO
FlexTool_PRIVATE_FRAMEWORKS := FrontBoardServices
FlexTool_LDFLAGS := -ObjC -lz -lsqlite3
FlexTool_LIBRARIES := substrate


# ─────────────────────────────────────────────
# MARK: - LiveContainer Dylib Target
# ─────────────────────────────────────────────

LIBRARY_NAME := FlexToolLC

FlexToolLC_FILES := \
    Sources/LiveContainerEntry.m \
    Sources/FTCore.m \
    Sources/FTSceneMonitor.m \
    Sources/FTPreferences.m \
    Sources/FLEXBridge.m \
    $(FLEX_SOURCES)

FlexToolLC_CFLAGS := \
    -fobjc-arc \
    -Wall \
    -Wextra \
    -Wno-unused-parameter \
    -Wno-deprecated-declarations \
    $(FLEX_INCLUDES)

FlexToolLC_FRAMEWORKS := UIKit Foundation QuartzCore CoreGraphics ImageIO
FlexToolLC_LDFLAGS := -ObjC -lz -lsqlite3
FlexToolLC_INSTALL_PATH := /usr/lib


# ─────────────────────────────────────────────
# MARK: - Build Rules
# ─────────────────────────────────────────────

include $(THEOS_MAKE_PATH)/tweak.mk
include $(THEOS_MAKE_PATH)/library.mk


# ─────────────────────────────────────────────
# MARK: - Post-Install
# ─────────────────────────────────────────────

after-install::
	install.exec "sbreload || killall -9 backboardd"
