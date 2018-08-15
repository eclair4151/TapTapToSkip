include $(THEOS)/makefiles/common.mk

TWEAK_NAME = TapTapforNetflix
TapTapforNetflix_FILES = Tweak.xm

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 Argo"
