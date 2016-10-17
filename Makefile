source := README.md \
          ChangeLog.md \
          bin/phpctags \
          plugin/tagbar-phpctags.vim

version := 0.6.0

.PHONY: all
all: bin/phpctags

.PHONY: clean
clean:
	@echo "Cleaning old build files ..."
	@rm -f bin/phpctags
	@rm -f build/tagbar-phpctags-$(version).zip
	@cd build/phpctags-$(version) && $(MAKE) clean
	@echo "Done!"

.PHONY: dist-clean
dist-clean:
	@echo "Cleaning old build files ..."
	@rm -rf bin/
	@rm -rf build/
	@echo "Done!"

.PHONY: archive
archive: build/tagbar-phpctags-$(version).zip

bin:
	@mkdir bin/

bin/phpctags: build/phpctags-$(version)/build/phpctags.phar | bin
	@cp build/phpctags-$(version)/build/phpctags.phar $@

build:
	@mkdir build/

build/phpctags-$(version).zip: | build
	@echo "Downloading phpctags ..."
	@curl -o $@ -s -L https://github.com/vim-php/phpctags/archive/$(version).zip
	@echo "Done!"

build/phpctags-$(version): build/phpctags-$(version).zip | build
	@echo "Preparing phpctags ..."
	@cd build/ && unzip phpctags-$(version).zip
	@echo "Done!"

build/phpctags-$(version)/build/phpctags.phar: | build/phpctags-$(version)
	@echo "Building phpctags ..."
	@cd build/phpctags-$(version) && $(MAKE)
	@echo "Done!"

build/tagbar-phpctags-$(version).zip: $(source)
	@echo "Building tagbar-phpctags distributable archive ..."
	@zip $@ $(source)
	@echo "Done!"
