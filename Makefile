DEBUG = 0
GO_EASY_ON_ME := 1
ARCHS = arm64 arm64e
TARGET = iphone:12.1.2:11.0
PACKAGE_VERSION = $(THEOS_PACKAGE_BASE_VERSION)
THEOS_DEVICE_IP = 0.0.0.0 -p 2222

TWEAK_NAME = VerticalNotify
$(TWEAK_NAME)_FILES = Tweak.xm
$(TWEAK_NAME)_FRAMEWORKS = UIKit
$(TWEAK_NAME)_CFLAGS = -fobjc-arc

include $(THEOS)/makefiles/common.mk
include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall backboardd"