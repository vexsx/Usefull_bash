# Grub Recovery in UBUNTU 22.04

In grub.cfg we have this 
>set root='hd0,gpt2'  
>linux   /vmlinuz-6.0.1 root=/dev/mapper/ubuntu--vg-ubuntu--lv ro single nomodeset dis_ucode_ldr  
>initrd  /initrd.img-6.0.1


## now reboot then recovery
```bash
ls => (find partition with filesystem)
mine is ls (hd0,gpt2) => filesystem type ext*

set root =(hd0,gpt2)


linux16 /vm(tab and select what suits for you)  root=/dev/mapper/ubuntu--vg-ubuntu--lv

initrd16 /(tab and select what suits for you)

boot

```

### install grub

grub2-mkconfig -o /boot/grub/grub.cfg
