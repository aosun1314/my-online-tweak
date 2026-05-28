include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = MyDebugToolPrefs

# ✅ 修正：偏好设置插件不需要编译 layout.xml，如果还有其他 .m 文件再写在这里，没有就留空或写空
MyDebugToolPrefs_FILES = 
# ✅ 核心：把 layout.xml 当作资源文件打包进 Bundle 中
MyDebugToolPrefs_RESOURCES = layout.xml

MyDebugToolPrefs_INSTALL_PATH = /Library/PreferenceBundles
MyDebugToolPrefs_FRAMEWORKS = UIKit
MyDebugToolPrefs_PRIVATE_FRAMEWORKS = Preferences

include $(THEOS)/makefiles/bundle.mk
