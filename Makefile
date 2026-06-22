TARGET := iphone:clang:latest:15.0
ARCHS := arm64 arm64e
INSTALL_TARGET_PROCESSES := SpringBoard
THEOS_PACKAGE_SCHEME := rootless

include $(THEOS)/makefiles/common.mk

TWEAK_NAME := FlexTool

FlexTool_FILES := \
  Sources/Tweak.xm \
  Sources/FTCore.m \
  Sources/FTSceneMonitor.m \
  Sources/FTPreferences.m \
  Sources/FLEXBridge.m

FlexTool_CFLAGS := -fobjc-arc -Wall -Wextra -Werror -Ivendor/FLEX
FlexTool_FRAMEWORKS := UIKit Foundation QuartzCore CoreGraphics
FlexTool_PRIVATE_FRAMEWORKS := FrontBoardServices
FlexTool_LDFLAGS := -ObjC

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "sbreload"

LIBRARY_NAME := FlexToolLC

FlexToolLC_FILES := \
  Sources/LiveContainerEntry.m \
  Sources/FTCore.m \
  Sources/FTSceneMonitor.m \
  Sources/FTPreferences.m \
  Sources/FLEXBridge.m

FlexToolLC_CFLAGS := -fobjc-arc -Wall -Wextra -Ivendor/FLEX
FlexToolLC_FRAMEWORKS := UIKit Foundation QuartzCore CoreGraphics
FlexToolLC_INSTALL_PATH := /usr/lib

include $(THEOS_MAKE_PATH)/library.mk
