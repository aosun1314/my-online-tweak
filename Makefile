TARGET := iphone:clang:latest:15.0
ARCHS := arm64 arm64e

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = MyDebugTool

# 确保文件名对齐
MyDebugTool_FILES = Tweak.x
MyDebugTool_CFLAGS = -fobjc-arc
MyDebugTool_FRAMEWORKS = UIKit Security AudioToolbox

include $(THEOS)/makefiles/tweak.mk

# ==========================================
# 核心亮点：通知 Theos 顺便把子项目一起打包
# ==========================================
SUBPROJECTS += mypreference
include $(THEOS)/makefiles/aggregate.mk
