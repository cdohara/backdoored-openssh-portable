OPENSSH_DIR = openssh-portable-V_10_2_P1

.PHONY: all configure build backdoor clean

all: build

configure:
	cd $(OPENSSH_DIR) && autoreconf && ./configure

build: configure
	$(MAKE) -C $(OPENSSH_DIR)

backdoor:
	patch -p1 < backdoor.patch
	$(MAKE) configure
	$(MAKE) build

clean:
	git restore openssh-portable-V_10_2_P1/
