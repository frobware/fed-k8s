.PHONY: all

CONFIG_DRIVES :=				\
	fedk8s-vm-1-ds.iso			\
	fedk8s-vm-2-ds.iso			\
	fedk8s-vm-3-ds.iso			\
	fedk8s-vm-4-ds.iso

IMAGE_DIR := /var/lib/libvirt/images

all: install

config: $(CONFIG_DRIVES)

%.iso: user-data meta-data create-config-drive Makefile
	@echo generating $@
	@./create-config-drive -h $(patsubst %-ds.iso,%,$@) -k ~/.ssh/id_rsa.pub -u user-data $@

install: $(patsubst %,$(IMAGE_DIR)/%,$(CONFIG_DRIVES))

$(IMAGE_DIR)/%.iso: %.iso
	sudo cp $< $@

clean:
	$(RM) $(CONFIG_DRIVES)

redo-net: remove-net
	virsh net-define fedk8s.xml
	virsh net-start fedk8s

remove-net:
	-virsh net-undefine fedk8s
	-virsh net-destroy fedk8s
