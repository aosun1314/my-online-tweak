TARGET := iphone:clang:latest:15.0
ARCHS := arm64 arm64e

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = MyDebugTool
MyDebugTool_FILES = Tweak.x
MyDebugTool_CFLAGS = -fobjc-arc
MyDebugTool_FRAMEWORKS = UIKit Security AudioToolbox

# 安装前清理缓存
before-install::
	-(RM) $(THEOS_OBJ_DIR)/MyDebugTool.dylib

include $(THEOS)/makefiles/tweak.mk

# 剥离指纹并修正动态库路径
after-install::
	$(STRIP) $(THEOS_OBJ_DIR)/MyDebugTool.dylib
	install_name_tool -id /var/jb/Library/MobileSubstrate/DynamicLibraries/com.apple.CoreLayoutCache.dylib $(THEOS_OBJ_DIR)/MyDebugTool.dylib

# ==========================================
# 指定编译设置面板子项目
# ==========================================
SUBPROJECTS += mypreference
include $(THEOS)/makefiles/aggregate.mk
