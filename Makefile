bin/kernel.img: linux/arch/x86/boot/bzImage bin
	cp linux/arch/x86/boot/bzImage bin/kernel.img

bin/fs.cpio.gz: bin/fs
	cd bin/fs && find . | cpio -H newc -o | gzip > ../fs.cpio.gz

bin/fs: init busybox/busybox bin
	mkdir -p bin/fs && git clean -dfx bin/fs/
	cp busybox/busybox bin/fs/busybox
	cp init bin/fs/init

bin:
	mkdir -p bin

busybox/.config:
	cd busybox && make defconfig

busybox/busybox: busybox/.config
	cd busybox && make

linux/.config: .config
	cp .config linux/.config

linux/arch/x86/boot/bzImage: linux/.config bin/fs.cpio.gz
	cd linux && make
