# ─────────────────────────────────────────────
# MARK: - Theos Konfiguration
# ─────────────────────────────────────────────

# Aktuelles SDK, Deployment-Target iOS 15 minimum
TARGET := iphone:clang:latest:15.0

# arm64 (A12+) und arm64e (A12+ mit PAC)
ARCHS := arm64 arm64e

# Rootless-Modus: Installation nach /var/jb statt /
THEOS_PACKAGE_SCHEME := rootless

# Nach Installation SpringBoard sanft neu laden
INSTALL_TARGET_PROCESSES := SpringBoard

include $(THEOS)/makefiles/common.mk


# ─────────────────────────────────────────────
# MARK: - FLEX Include-Pfade
# ─────────────────────────────────────────────

# Alle Header-Suchpfade unter FLEX
FLEX_INCLUDES := $(shell find vendor/FLEX -type d | sed 's/^/-I/')

FLEX_OBJC_SOURCES := $(shell find vendor/FLEX/Classes \( -name "*.m" -o -name "*.mm" \) 2>/dev/null)

# Firebase vorerst raus
FLEX_OBJC_SOURCES := $(filter-out %FLEXFirebaseTransaction.mm,$(FLEX_OBJC_SOURCES))
FLEX_OBJC_SOURCES := $(filter-out %Firebase%,$(FLEX_OBJC_SOURCES))

# System log / symbol rebinding vorerst raus
FLEX_OBJC_SOURCES := $(filter-out %FLEXSystemLogViewController.m,$(FLEX_OBJC_SOURCES))
FLEX_OBJC_SOURCES := $(filter-out %FLEXOSLogController.m,$(FLEX_OBJC_SOURCES))
FLEX_OBJC_SOURCES := $(filter-out %FLEXOSLogMessage.m,$(FLEX_OBJC_SOURCES))

FLEX_SOURCES := $(FLEX_OBJC_SOURCES)

FLEX_SOURCES += $(shell find vendor/fishhook -name "fishhook.c" 2>/dev/null)
FLEX_INCLUDES += $(shell find vendor/fishhook -type d | sed 's/^/-I/')

# ─────────────────────────────────────────────
# MARK: - Rootless Tweak Target
# ─────────────────────────────────────────────

TWEAK_NAME := FlexTool

# Nur eigene Quelldateien – ohne FLEX
FlexTool_FILES := \
    Sources/Tweak.xm \
    Sources/FTCore.m \
    Sources/FTPreferences.m \
    Sources/FLEXBridge.m \
    $(FLEX_SOURCES)

# FLEX separat mit lockeren Flags
FlexTool_FILES += $(FLEX_SOURCES)

# Strenge Flags nur für eigenen Code
FlexTool_CFLAGS := \
    -fobjc-arc \
    -Wall \
    -Wno-unused-parameter \
    -Wno-deprecated-declarations \
    -Wno-sign-compare \
    -Wno-shorten-64-to-32 \
    -Wno-unsupported-availability-guard \
    -Wno-error \
    $(FLEX_INCLUDES)

FlexTool_FRAMEWORKS := UIKit Foundation QuartzCore CoreGraphics ImageIO WebKit Security SceneKit AVFoundation UserNotifications
FlexTool_LDFLAGS := -ObjC -lz -lsqlite3
FlexTool_LIBRARIES := substrate

# ─────────────────────────────────────────────
# MARK: - LiveContainer Dylib Target
# ─────────────────────────────────────────────

LIBRARY_NAME := FlexToolLC

FlexToolLC_FILES := \
    Sources/LiveContainerEntry.m \
    Sources/FTCore.m \
    Sources/FTPreferences.m \
    Sources/FLEXBridge.m \
    $(FLEX_SOURCES)

FlexToolLC_FILES += $(FLEX_SOURCES)

FlexToolLC_CFLAGS := \
    -fobjc-arc \
    -Wall \
    -Wno-unused-parameter \
    -Wno-deprecated-declarations \
    -Wno-sign-compare \
    -Wno-shorten-64-to-32 \
    -Wno-unsupported-availability-guard \
    -Wno-error \
    $(FLEX_INCLUDES)

FlexToolLC_FRAMEWORKS := UIKit Foundation QuartzCore CoreGraphics ImageIO WebKit Security SceneKit AVFoundation UserNotifications
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


# ─────────────────────────────────────────────
# MARK: - Hilfe
# ─────────────────────────────────────────────

help:
	@echo ""
	@echo "Verfügbare Targets:"
	@echo "  make               – Rootless Tweak bauen"
	@echo "  make package       – .deb Paket erzeugen"
	@echo "  make FlexToolLC    – LiveContainer Dylib bauen"
	@echo "  make clean         – Build-Artefakte löschen"
	@echo ""