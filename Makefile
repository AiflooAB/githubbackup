.POSIX:
.SUFFIXES:

NAME=githubbackup
VERSION=$(shell git describe --always --match v[0-9]* HEAD)
SHORT_VERSION=$(patsubst v%,%,$(VERSION))
OUT_DIR=build
DEB_PACKAGE_DIR=$(OUT_DIR)/deb/$(NAME)-$(VERSION)

ok.sh_version=b0d162819f11ad9135d8185ec6460a342fffdd7b
ok.sh_url=https://raw.githubusercontent.com/whiteinge/ok.sh/$(ok.sh_version)/ok.sh

.PHONY: all
all: $(DEB_PACKAGE_DIR).deb

ok.sh: $(OUT_DIR)/ok.sh-$(ok.sh_version)
	cp --link --force $< $@

$(OUT_DIR)/ok.sh-$(ok.sh_version): | $(OUT_DIR)/
	wget $(ok.sh_url) --output-document "$@"
	chmod +x "$@"

$(OUT_DIR)/:
	mkdir -p $(OUT_DIR)

.PHONY: release
release: clean \
	$(DEB_PACKAGE_DIR).deb \

	hub release create \
		--attach="$(DEB_PACKAGE_DIR).deb" \
		"$(VERSION)"

.PHONY: clean
clean:
	rm -rf "$(OUT_DIR)"

$(DEB_PACKAGE_DIR).deb: $(DEB_PACKAGE_DIR)/
	chmod 755 $(DEB_PACKAGE_DIR)/DEBIAN/postinst
	chmod 755 $(DEB_PACKAGE_DIR)/DEBIAN/postrm
	chmod 755 $(DEB_PACKAGE_DIR)/DEBIAN/prerm
	fakeroot dpkg-deb --build "$(DEB_PACKAGE_DIR)"

$(DEB_PACKAGE_DIR)/: \
	$(DEB_PACKAGE_DIR)/DEBIAN/ \
	$(DEB_PACKAGE_DIR)/usr/lib/$(NAME)/backup.sh \
	$(DEB_PACKAGE_DIR)/usr/lib/$(NAME)/list_repos.sh \
	$(DEB_PACKAGE_DIR)/usr/lib/$(NAME)/clone.sh \
	$(DEB_PACKAGE_DIR)/usr/lib/$(NAME)/ok.sh \
	$(DEB_PACKAGE_DIR)/usr/lib/$(NAME)/jwt.sh \
	$(DEB_PACKAGE_DIR)/usr/lib/$(NAME)/token.sh \
	$(DEB_PACKAGE_DIR)/etc/default/$(NAME) \
	$(DEB_PACKAGE_DIR)/usr/lib/systemd/system/$(NAME).service \
	$(DEB_PACKAGE_DIR)/usr/lib/systemd/system/$(NAME).timer \

	@touch "$@"

$(DEB_PACKAGE_DIR)/DEBIAN/: \
	$(DEB_PACKAGE_DIR)/DEBIAN/conffiles \
	$(DEB_PACKAGE_DIR)/DEBIAN/control \
	$(DEB_PACKAGE_DIR)/DEBIAN/postinst \
	$(DEB_PACKAGE_DIR)/DEBIAN/postrm \
	$(DEB_PACKAGE_DIR)/DEBIAN/prerm \

	@touch "$@"

$(DEB_PACKAGE_DIR)/DEBIAN/control: debian/control
	(cat debian/control && echo -n 'Version: ' && echo "$(SHORT_VERSION)") > "$@"

$(DEB_PACKAGE_DIR)/DEBIAN/%: debian/%
	@mkdir -p "$(dir $@)"
	cp -p "debian/$*" "$@"

$(DEB_PACKAGE_DIR)/etc/default/$(NAME): sys/defaults
	mkdir -p "$(dir $@)"
	cp $< $@

$(DEB_PACKAGE_DIR)/usr/lib/$(NAME)/%: %
	mkdir -p "$(dir $@)"
	cp $< $@

$(DEB_PACKAGE_DIR)/usr/lib/systemd/system/%: sys/%
	mkdir -p "$(dir $@)"
	cp $< $@
