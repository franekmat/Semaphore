extern get_os_time

section .text
  global proberen
  global verhogen
  global proberen_time

proberen:
  mov eax, dword [rdi]
  cmp eax, dword esi ;is semaphore < value?
  jl proberen

  xor eax, eax ;eax = 0
  sub eax, dword esi
  lock xadd [rdi], eax ;attempt to reduce semaphore value

  cmp eax, dword esi ;is semaphore < value? has the reduction failed?
  jl dodaj
  ret

dodaj: ;add back value to semaphore
  lock add [rdi], dword esi
  jmp proberen

verhogen:
  lock add [rdi], dword esi
  ret

proberen_time:
  mov r12, rdi ;save the parameters to registers
  mov r13d, esi

  call get_os_time
  mov r14d, eax ;save the start time in r14d (zachowuje sie podczas call)

  mov rdi, r12 ;restore proberen_time parameters to the relevant registers
  mov esi, r13d
  call proberen

  call get_os_time
  sub eax, r14d ;subtract start time from end time and return it
  ret
