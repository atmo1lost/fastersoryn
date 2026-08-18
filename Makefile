.PHONY: psp updater translations theme clean 

PY = $(shell which python3)
PSPDEV = $(shell psp-config --pspdev-path)
BUILDTOOLS = $(PSPDEV)/share/psp-cfw-sdk/build-tools
CHOVYSIGNDIR = ./Resources/Chovy-Sign
CHOVYSIGN = $(CHOVYSIGNDIR)/ChovySign-CLI
LANGFOLDER = Resources/Language/Translations/resources

all: translations themes psp updater
	echo "All Done!"

translations:
	$(PY) $(BUILDTOOLS)/pftools/bdf_to_pf.py $(LANGFOLDER)/satelite_chs_utf8.txt Resources/Language/quan.bdf $(LANGFOLDER)/satelite_chs.txt $(LANGFOLDER)/CHS.pf
	$(PY) $(BUILDTOOLS)/pftools/bdf_to_pf.py $(LANGFOLDER)/satelite_cht_utf8.txt Resources/Language/quan.bdf $(LANGFOLDER)/satelite_cht.txt $(LANGFOLDER)/CHT.pf
	$(PY) $(BUILDTOOLS)/pftools/bdf_to_pf.py $(LANGFOLDER)/satelite_jp_utf8.txt Resources/Language/quan.bdf $(LANGFOLDER)/satelite_jp.txt $(LANGFOLDER)/JP.pf
	$(PY) $(BUILDTOOLS)/pftools/bdf_to_pf.py $(LANGFOLDER)/satelite_kr_utf8.txt Resources/Language/quan.bdf $(LANGFOLDER)/satelite_kr.txt $(LANGFOLDER)/KR.pf
	$(PY) $(BUILDTOOLS)/pack/pkg-res.py Resources/Language LANG.ARK

themes:
	mkdir -p dist/tmp/
	cp -r Resources/themes dist/tmp/
	cd dist/tmp/ && zip -m -r themes.zip * && cd ../../ && mv dist/tmp/themes.zip dist/
	rm -rf dist/tmp

psp: translations
	make -C PSP
#	PSP Lite Install
	mkdir -p dist/tmp/PSP/GAME/FasterARK/
	mkdir -p dist/tmp/PSP/SAVEDATA/
	cp -r Resources/ARK_01234 dist/tmp/PSP/SAVEDATA/
	cp -r Resources/CustomIPL dist/tmp/PSP/GAME/
	cp PSP/EBOOT.PBP dist/tmp/PSP/GAME/FasterARK/
	cp Resources/LIBS/ipl_update.prx dist/tmp/PSP/GAME/CustomIPL/
	cp Resources/LIBS/kbooti_update.prx dist/tmp/PSP/GAME/CustomIPL/
	cp Resources/LIBS/kpspident.prx dist/tmp/PSP/GAME/CustomIPL/
	cp Resources/LIBS/usbdevice.prx dist/tmp/PSP/GAME/FasterARK/
	cp Resources/LIBS/idsregeneration.prx dist/tmp/PSP/GAME/FasterARK/
	cd dist/tmp/ && zip -m -r FasterARK_psp_lite.zip * && cd ../../ && mv dist/tmp/FasterARK_psp_lite.zip dist/
#	PSP Full Install
	mkdir -p dist/tmp/PSP/GAME/FasterARK/
	mkdir -p dist/tmp/PSP/SAVEDATA/
	cp -r Resources/ARK_01234 dist/tmp/PSP/SAVEDATA/
	cp Resources/Extras/* dist/tmp/PSP/SAVEDATA/ARK_01234/
	cp Resources/Language/Translations/LANG.ARK dist/tmp/PSP/SAVEDATA/ARK_01234/
	cp -r Resources/CustomIPL dist/tmp/PSP/GAME/
	cp -r Resources/DC10 dist/tmp/PSP/GAME/
	cp -r Resources/ARK150on660 dist/tmp/PSP/GAME/
	cp -r Resources/OC_Tester dist/tmp/PSP/GAME/
	cp PSP/EBOOT.PBP dist/tmp/PSP/GAME/FasterARK/
	cp Resources/LIBS/usbdevice.prx dist/tmp/PSP/GAME/FasterARK/
	cp Resources/LIBS/idsregeneration.prx dist/tmp/PSP/GAME/FasterARK/
	cp Resources/LIBS/ipl_update.prx dist/tmp/PSP/GAME/CustomIPL/
	cp Resources/LIBS/kbooti_update.prx dist/tmp/PSP/GAME/CustomIPL/
	cp Resources/LIBS/kpspident.prx dist/tmp/PSP/GAME/CustomIPL/
	cp Resources/LIBS/iop.prx dist/tmp/PSP/GAME/DC10/
	cp Resources/LIBS/ipl_update.prx dist/tmp/PSP/GAME/DC10/
	cp Resources/LIBS/usbdevice.prx dist/tmp/PSP/GAME/DC10/
	cp Resources/LIBS/idsregeneration.prx dist/tmp/PSP/GAME/DC10/
	cp Resources/LIBS/vlf.prx dist/tmp/PSP/GAME/DC10/
	cp Resources/LIBS/intraFont-vlf.prx dist/tmp/PSP/GAME/DC10/
	cp Resources/LIBS/pspdecrypt.prx dist/tmp/PSP/GAME/DC10/
	cp Resources/LIBS/libpsardumper.prx dist/tmp/PSP/GAME/DC10/
	cp Resources/LIBS/lflash_fdisk.prx dist/tmp/PSP/GAME/DC10/
	cp Resources/LIBS/pspdecrypt.prx dist/tmp/PSP/GAME/ARK150on660/
	cp Resources/LIBS/libpsardumper.prx dist/tmp/PSP/GAME/ARK150on660/
	cd dist/tmp/ && zip -m -r FasterARK_psp_full.zip * && cd ../../ && mv dist/tmp/FasterARK_psp_full.zip dist/
	rm -r dist/tmp/

updater: translations
#	Updater
	mkdir -p dist/tmp/
	cp -r Resources/LIBS Updater/Resources/
	cp -r Resources/ARK_01234 Updater/Resources/
	cp Resources/DC10/DC10.ARK Updater/Resources/ARK_01234/
	cp Resources/ARK150on660/FLASH150.ARK Updater/Resources/ARK_01234/
	cp Resources/ARK150on660/LANG150.ARK Updater/Resources/ARK_01234/
	cp Resources/Language/Translations/LANG.ARK Updater/Resources/ARK_01234/
	cp Resources/Extras/VBOOT.PBP Updater/Resources/ARK_01234/
	cp Resources/Extras/VSHMENU.PRX Updater/Resources/ARK_01234/
	cp Resources/PSVita/XBOOT.PBP Updater/Resources/ARK_01234/
	make -C Resources/Peops
	$(PY) $(BUILDTOOLS)/gz/pspgz.py Updater/Resources/ARK_01234/PS1SPU.PRX $(BUILDTOOLS)/gz/UserModule.hdr Resources/Peops/peops.prx peops 0x0000
	make -C Updater
	mkdir -p dist/tmp/PSP/GAME/UPDATE/
	cp Updater/EBOOT.PBP dist/tmp/PSP/GAME/UPDATE/
	cd dist/tmp/ && zip -m -r ARK_UPDATE.zip * && cd ../../ && mv dist/tmp/ARK_UPDATE.zip dist/
	rm -r dist/tmp/
	rm -rf Updater/Resources/LIBS
	rm -rf Updater/Resources/ARK_01234

clean:
	rm -rf dist
	rm -rf $(CHOVYSIGNDIR)/output
	rm -f Resources/Language/Translations/LANG.ARK
	make -C PSP clean
	make -C Updater clean
	make -C Resources/Peops clean
