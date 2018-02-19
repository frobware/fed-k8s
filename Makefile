.PHONY: all

ifndef PREFIX
$(error PREFIX is not set)
endif

ifndef USER_DATA
$(error USER_DATA is not set)
endif

ifndef DOMAINNAME
DOMAINNAME = k8s.home
endif

CONFIG_DRIVES :=				\
	$(PREFIX)-vm-1-ds.iso			\
	$(PREFIX)-vm-2-ds.iso			\
	$(PREFIX)-vm-3-ds.iso			\
	$(PREFIX)-vm-4-ds.iso			\
	$(PREFIX)-vm-5-ds.iso			\
	$(PREFIX)-vm-6-ds.iso			\
	$(PREFIX)-vm-7-ds.iso			\
	$(PREFIX)-vm-8-ds.iso

IMAGE_DIR := /var/lib/libvirt/images

all: install

config: $(CONFIG_DRIVES)

%.iso: $(USER_DATA) meta-data create-config-drive Makefile
	@echo generating $@
	@./create-config-drive -h $(patsubst %-ds.iso,%,$@) --domainname $(DOMAINNAME) -k ~/.ssh/id_rsa.pub -u $(USER_DATA) $@

install: $(patsubst %,$(IMAGE_DIR)/%,$(CONFIG_DRIVES))

$(IMAGE_DIR)/%.iso: %.iso
	sudo cp $< $@

Makefile: bin/setup-vm bin/delete-vm

clean:
	$(RM) $(CONFIG_DRIVES)

redo-net: remove-net
	virsh net-define $(NETWORK).xml
	virsh net-start $(NETWORK)

remove-net:
	-virsh net-undefine $(NETWORK)
	-virsh net-destroy $(NETWORK)
