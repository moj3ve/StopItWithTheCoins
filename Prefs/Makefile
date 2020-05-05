include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = SIWTCPrefs

SIWTCPrefs_FILES = SIWTCRootListController.m
SIWTCPrefs_INSTALL_PATH = /Library/PreferenceBundles
SIWTCPrefs_FRAMEWORKS = UIKit
SIWTCPrefs_PRIVATE_FRAMEWORKS = Preferences
SIWTCPrefs_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/SIWTCPrefs.plist$(ECHO_END)
