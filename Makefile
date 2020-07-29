include $(TOPDIR)/rules.mk

PKG_NAME:=pdnsd
PKG_VERSION:=1.2.9a-par
PKG_RELEASE=$(PKG_SOURCE_VERSION)

PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL:=https://github.com/code4craft/pdnsd.git
PKG_SOURCE_SUBDIR:=$(PKG_NAME)-$(PKG_VERSION)
PKG_SOURCE_VERSION:=a8e46ccba7b0fa2230d6c42ab6dcd92926f6c21d
PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.gz
PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_SOURCE_SUBDIR)
PKG_MIRROR_HASH:=skip
# CMAKE_INSTALL:=1

include $(INCLUDE_DIR)/package.mk

define Package/pdnsd
  SECTION:=net
  CATEGORY:=Network
  SUBMENU:=Web Servers/Proxies
  DEPENDS:=+libpthread
  TITLE:=Proxy DNS Server
endef

define Package/$(PKG_NAME)/conffiles
/etc/pdnsd.conf
endef

define Package/pdnsd/description
  pdnsd, is an IPv6 capable proxy DNS server with permanent caching (the cache
  contents are written to hard disk on exit) that is designed to cope with
  unreachable or down DNS servers (for example in dial-in networking).

  pdnsd can be used with applications that do dns lookups, eg on startup, and
  can't be configured to change that behaviour, to prevent the often
  minute-long hangs (or even crashes) that result from stalled dns queries.
endef

TARGET_CFLAGS += -I$(STAGING_DIR)/usr/include
#TARGET_CFLAGS += -ggdb3
TARGET_CFLAGS += -ffunction-sections -fdata-sections
TARGET_LDFLAGS += -Wl,--gc-sections

# Use Link time optimization
TARGET_CFLAGS += -flto
TARGET_LDFLAGS += -Wl,-flto


CMAKE_OPTIONS += -DDEBUG=1

CONFIGURE_ARGS += \
		--with-cachedir=/tmp/pdnsd \
		--enable-ipv6 \
		--enable-ipv6-startup

define Package/pdnsd/install
	$(INSTALL_DIR) $(1)/usr/sbin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/src/pdnsd $(1)/usr/sbin/
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/src/pdnsd-ctl/pdnsd-ctl $(1)/usr/bin/

	$(INSTALL_DIR) $(1)/etc/init.d
	$(INSTALL_BIN) ./files/pdnsd.init $(1)/etc/init.d/pdnsd
	$(INSTALL_DIR) $(1)/etc
	$(INSTALL_CONF) ./files/pdnsd.conf $(1)/etc/
endef

$(eval $(call BuildPackage,pdnsd))
