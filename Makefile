prefix ?= /usr/local
bindir = $(prefix)/bin
libdir = $(prefix)/lib

build:
	swift build \
		--configuration release \
		--disable-sandbox \
		--arch arm64 \
		--arch x86_64

install: build
	install -d "$(bindir)" "$(libdir)"
	install ".build/release/zet" "$(bindir)"

uninstall:
	rm -rf "$(bindir)/zet"

clean:
	rm -rf .build

.PHONY: build install uninstall clean
