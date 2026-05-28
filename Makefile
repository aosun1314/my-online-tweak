THEOS_PACKAGE_SCHEME = rootless
TARGET := iphone:clang:latest:15.0
ARCHS := arm64 arm64e

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = MyDebugTool
MyDebugTool_FILES = Tweak.x
MyDebugTool_CFLAGS = -fobjc-arc

include $(THEOS)/makefiles/tweak.mk
