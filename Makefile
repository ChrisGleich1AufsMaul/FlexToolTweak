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

FLEX_DIR := vendor/FLEX/Classes

FLEX_INCLUDES := \
	-I$(FLEX_DIR) \
	-I$(FLEX_DIR)/Manager \
	-I$(FLEX_DIR)/Toolbar \
	-I$(FLEX_DIR)/Utility \
	-I$(FLEX_DIR)/Network \
	-I$(FLEX_DIR)/ObjectExplorers \
	-I$(FLEX_DIR)/GlobalStateExplorers \
	-I$(FLEX_DIR)/ExplorerInterface \
	-I$(FLEX_DIR)/Editing \
	-I$(FLEX_DIR)/ViewHierarchy


# ─────────────────────────────────────────────
# MARK: - Rootless Tweak Target
# ─────────────────────────────────────────────

TWEAK_NAME := FlexTool

FlexTool_FILES := \
	Sources/Tweak.xm \
	Sources/FTCore.m \
	Sources/FTPreferences.m \
	Sources/FLEXBridge.m

# FLEX-Quellen automatisch einsammeln
FlexTool_FILES += $(shell find vendor/FLEX/Classes -name "*.m" 2>/dev/null)

FlexTool_CFLAGS := \
	-fobjc-arc \
	-Wall \
	-Wextra \
	-Wno-unused-parameter \
	-Wno-deprecated-declarations \
	$(FLEX_INCLUDES)

FlexTool_FRAMEWORKS := \
	UIKit \
	Foundation \
	QuartzCore \
	CoreGraphics \
	ImageIO

FlexTool_LDFLAGS := \
	-ObjC \
	-lz \
	-lsqlite3

FlexTool_LIBRARIES := substrate


# ─────────────────────────────────────────────
# MARK: - LiveContainer Dylib Target
# ─────────────────────────────────────────────

LIBRARY_NAME := FlexToolLC

FlexToolLC_FILES := \
	Sources/LiveContainerEntry.m \
	Sources/FTCore.m \
	Sources/FTPreferences.m \
	Sources/FLEXBridge.m

# FLEX-Quellen – dieselben wie beim Tweak
FlexToolLC_FILES += $(shell find vendor/FLEX/Classes -name "*.m" 2>/dev/null)

FlexToolLC_CFLAGS := \
	-fobjc-arc \
	-Wall \
	-Wextra \
	-Wno-unused-parameter \
	-Wno-deprecated-declarations \
	$(FLEX_INCLUDES)

FlexToolLC_FRAMEWORKS := \
	UIKit \
	Foundation \
	QuartzCore \
	CoreGraphics \
	ImageIO

FlexToolLC_LDFLAGS := \
	-ObjC \
	-lz \
	-lsqlite3

# Kein Substrate – LiveContainer braucht keinen Jailbreak-Loader
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