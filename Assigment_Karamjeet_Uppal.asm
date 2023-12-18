   include 'emu8086.inc'
BUFFER_SIZE EQU 20

org 100h

printn "Please input a string (up to 10 characters):"
lea di, user_input   ; Set up the buffer address for get_string
mov dx, BUFFER_SIZE  ; Set up the buffer size for get_string
call get_string      ; The returned string ends with a null character (0 byte).
printn
printn "Encoded string:"
; Encode and print the string
lea di, user_input   ; Reset di to the beginning of the buffer
encode_loop:
    mov al, [di]     ; Load the current character from the buffer
    cmp al, 0        ; Check if it is the null terminator (end of the string)
    je reverse_string ; Jump to reverse the string if null terminator is reached

    cmp al, 'A'      ; Check if the character is uppercase
    jb handle_lowercase
    cmp al, 'Z'
    jbe handle_uppercase

handle_lowercase:
    cmp al, 'a'      ; Check if the character is lowercase
    jb handle_punctuation
    cmp al, 'z'
    jbe handle_lowercase_conversion

handle_punctuation:
    cmp al, ' '     
    je print_punctution
    cmp al, ','
    je print_punctution
    cmp al, ';'
    je print_punctution
    
   

handle_lowercase_conversion:
    ; Handle lowercase characters
    sub al, 'a'      ; Convert ASCII character to index (0-25)
    xor al, 0x1F     ; Apply the secret code
    add al, 'a'      ; Convert the result back to ASCII
    jmp print_char

handle_uppercase:
    ; Handle uppercase characters
    sub al, 'A'      ; Convert ASCII character to index (0-25)
    xor al, 0x1F     ; Apply the secret code 
    add al, 'A'      ; Convert the result back to ASCII
    jmp print_char

print_punctution:
    mov ah, 0Eh      ; AH=0Eh is the function for printing a character with teletype output
    int 10h          ; Call BIOS interrupt to print the character
    inc di           ; Move to the next character
    jmp encode_loop


print_char: 
    SUB al, 6
    mov ah, 0Eh      ; AH=0Eh is the function for printing a character with teletype output
    int 10h          ; Call BIOS interrupt to print the character
    
    inc di           ; Move to the next character
    jmp encode_loop 

reverse_string:
    ; Reverse the encoded string 
         
    printn "Reversed Code"
    
    lea si, user_input ; Set up si to the beginning of the buffer
    dec di            ; Move back from null terminator
    jmp print_reverse

print_reverse:
      cmp si, di      ; Check if reached the beginning of the string
    ja print_reverse_newline ; If yes, print a new line before finishing
     
    mov al, [di]      ; Load the current character from the buffer       
     mov ah, 0Eh       ; AH=0Eh is the function for printing a character with teletype output
    int 10h           ; Call BIOS interrupt to print the character
    
    dec di            ; Move to the previous character
    jmp print_reverse

print_reverse_newline:
    printn             ; Print a new line before finishing the reversed output
   


ret

user_input DB BUFFER_SIZE DUP(?)

define_get_string
define_print_string

end
