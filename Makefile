prefix ?= /usr/local
bindir = $(prefix)/bin
libdir = $(prefix)/lib

build:
	swiftc ./scripts/build.swift
	./build
	rm ./build
	
install: build
	install -d "$(bindir)" "$(libdir)"
	install ".build/release/zet" "$(bindir)"
	
uninstall:
	rm -rf "$(bindir)/zet"
	
clean:
	rm -rf .build
	
.PHONY: build install uninstall clean
