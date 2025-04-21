global start
    extern ExitProcess
section .data
    a: DQ 12, 17, 19
    c1: DQ 15
    c2: DQ 26
section .text
    start:
    MOV RAX, [a+8]
    SUB RAX, [a]
    IMUL RAX, [a+16]

    MOV RBX, [a]
    ADD RBX, [a+8]

    MOV RCX, [c1]
    ADD RCX, [c2]

    MOV RDX, [a+8]
    SAL RDX, 4

loop1:
    CMP RCX, -5
    JL end
    
    SUB RCX, 3

    TEST RCX, 1
    JZ loop1
    JMP ifnoeven

ifnoeven:
    ADD RBX, RAX
    JMP loop1

end:
    XOR ecx, ecx
    CALL ExitProcess    