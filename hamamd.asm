INCLUDE Irvine32.inc

.DATA
contact STRUCT
    name    BYTE 128 DUP(0)
    phone   BYTE 128 DUP(0)
    address BYTE 128 DUP(0)
contact ENDS

maxRecords    = 10
recordSize    = SIZEOF contact

menuText      BYTE "1. Add", 0Dh, 0Ah, "2. Edit", 0Dh, 0Ah, "3. Delete", 0Dh, 0Ah, "4. Search", 0Dh, 0Ah, "5. Display", 0Dh, 0Ah, "6. Exit", 0Dh, 0Ah, 0
prompt        BYTE "Choose an option: ", 0
buffer        BYTE 128 DUP(0)
promptName    BYTE "Enter name: ", 0
promptPhone   BYTE "Enter phone number: ", 0
promptAddress BYTE "Enter address: ", 0
goodbyeMessage BYTE "Goodbye!", 0

records       contact maxRecords DUP (<>)
recordCount   DWORD 0

.CODE
main PROC
    menuLoop:
        mov edx, OFFSET menuText
        call WriteString

        mov edx, OFFSET prompt
        call WriteString

        mov edx, OFFSET buffer
        mov ecx, SIZEOF buffer - 1
        call ReadString
        call CrLf
        call CrLf

        mov edx, OFFSET buffer
        call ParseOption

        cmp eax, 1
        je AddRecord
        cmp eax, 2
        je EditRecord
        cmp eax, 3
        je DeleteRecord
        cmp eax, 4
        je SearchRecord
        cmp eax, 5
        je DisplayRecords
        cmp eax, 6
        je ExitProgram

        jmp menuLoop

AddRecord PROC
    ; Check if recordCount < maxRecords
    mov eax, recordCount
    cmp eax, maxRecords
    jge MaxRecordsReached

    ; Input name
    mov edx, OFFSET promptName
    call WriteString
    mov edx, OFFSET buffer
    mov ecx, SIZEOF buffer - 1
    call ReadString
    mov esi, eax
    mov edi, records
    add edi, eax
    lea edi, [edi + eax * recordSize]
    mov ecx, SIZEOF buffer
    cld
    rep movsb

    ; Input phone number
    mov edx, OFFSET promptPhone
    call WriteString
    mov edx, OFFSET buffer
    mov ecx, SIZEOF buffer - 1
    call ReadString
    mov esi, eax
    mov edi, records
    add edi, eax
    lea edi, [edi + eax * recordSize + SIZEOF BYTE * 128]
    mov ecx, SIZEOF buffer
    cld
    rep movsb

    ; Input address
    mov edx, OFFSET promptAddress
    call WriteString
    mov edx, OFFSET buffer
    mov ecx, SIZEOF buffer - 1
    call ReadString
    mov esi, eax
    mov edi, records
    add edi, eax
    lea edi, [edi + eax * recordSize + SIZEOF BYTE * 256]
    mov ecx, SIZEOF buffer
    cld
    rep movsb

    ; Increment recordCount
    inc recordCount

    jmp Done

MaxRecordsReached:
    ; Handle case when maximum records are reached
    mov edx, OFFSET buffer
    mov ecx, SIZEOF buffer - 1
    call WriteString

Done:
    jmp menuLoop
AddRecord ENDP

EditRecord PROC
    ; EditRecord logic here
    jmp menuLoop
EditRecord ENDP

DeleteRecord PROC
    ; DeleteRecord logic here
    jmp menuLoop
DeleteRecord ENDP

SearchRecord PROC
    ; SearchRecord logic here
    jmp menuLoop
SearchRecord ENDP

DisplayRecords PROC
    ; Display all records
    mov ecx, recordCount
    mov esi, OFFSET records
DisplayNextRecord:
    cmp ecx, 0
    je DoneDisplaying
    ; Display name
    mov edx, esi
    call WriteString
    call CrLf

    ; Display phone
    add edx, SIZEOF BYTE * 128
    call WriteString
    call CrLf

    ; Display address
    add edx, SIZEOF BYTE * 128
    call WriteString
    call CrLf
    call CrLf

    ; Move to next record
    add esi, recordSize
    loop DisplayNextRecord

DoneDisplaying:
    jmp menuLoop
DisplayRecords ENDP

ExitProgram PROC
    mov edx, OFFSET goodbyeMessage
    call WriteString
    call ExitProcess, 0
ExitProgram ENDP

ParseOption PROC
    ; Convert buffer to an integer and store in EAX
    mov edx, OFFSET buffer
    call atodw
    ret
ParseOption ENDP

main endp
end main
