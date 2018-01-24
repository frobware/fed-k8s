.PHONY: all

ifndef PREFIX
$(error PREFIX is not set)
endif

ifndef DOMAINNAME
DOMAINNAME = k8s.frobware.com
endif

CONFIG_DRIVES :=				\
	$(PREFIX)-vm-1-ds.iso			\
	$(PREFIX)-vm-2-ds.iso			\
	$(PREFIX)-vm-3-ds.iso			\
	$(PREFIX)-vm-4-ds.iso			\
	$(PREFIX)-vm-5-ds.iso			\
	$(PREFIX)-vm-6-ds.iso			\
	$(PREFIX)-vm-7-ds.iso

IMAGE_DIR := /var/lib/libvirt/images

all: install

config: $(CONFIG_DRIVES)

%.iso: user-data meta-data create-config-drive Makefile
	@echo generating $@
	@./create-config-drive -h $(patsubst %-ds.iso,%,$@) --domainname $(DOMAINNAME) -k ~/.ssh/id_rsa.pub -u user-data $@

install: $(patsubst %,$(IMAGE_DIR)/%,$(CONFIG_DRIVES))

$(IMAGE_DIR)/%.iso: %.iso
	sudo cp $< $@

Makefile: setup-vm.sh delete-vm.sh

clean:
	$(RM) $(CONFIG_DRIVES)

redo-net: remove-net
	virsh net-define $(NETWORK).xml
	virsh net-start $(NETWORK)

remove-net:
	-virsh net-undefine $(NETWORK)
	-virsh net-destroy $(NETWORK)
