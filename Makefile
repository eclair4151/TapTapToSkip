include $(THEOS)/makefiles/common.mk

TWEAK_NAME = TapTapforNetflix
TapTapforNetflix_FILES = Tweak.xm
TARGET = iphone:10.2:10.2


include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 Argo"
