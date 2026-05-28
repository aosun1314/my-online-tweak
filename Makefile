TARGET := iphone:clang:latest:15.0
ARCHS := arm64 arm64e

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = MyDebugTool
MyDebugTool_FILES = Tweak.x
MyDebugTool_CFLAGS = -fobjc-arc
MyDebugTool_FRAMEWORKS = UIKit Security AudioToolbox

before-install::
	-(RM) $(THEOS_OBJ_DIR)/MyDebugTool.dylib

include $(THEOS)/makefiles/tweak.mk

# 2026 修正：移除手机端绝对路径的 install_name_tool，转由标准签名链处理
after-install::
	$(STRIP) $(THEOS_OBJ_DIR)/MyDebugTool.dylib

SUBPROJECTS += mypreference
include $(THEOS)/makefiles/aggregate.mk
