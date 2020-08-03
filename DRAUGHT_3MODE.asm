 ################# HAO LAM's PROJECT #########################

    .data
#############################################
chooseMODE:     .asciiz "\nThere are 3 mode:\n1.P1 vs P2\n2.P1 vs COMP1\n3.COMP1 vs COMP2\n\nChoose mode (Enter 1,2 or 3): " 
p1_chooseColor: .asciiz "\nPLAYER 1 color: "
p2RED:          .asciiz "\nThen PLAYER 2 color is RED "
p2WHITE:        .asciiz "\nThen PLAYER 2 color is WHITE "
c1_chooseColor: .asciiz "\nCOMPUTER 1 color: "
c2RED:        .asciiz "\nThen COMPUTER 2 color RED "
c2WHITE:        .asciiz "\nThen COMPUTER 2 color WHITE "
print_RED:      .asciiz "RED\n"
print_WHITE:    .asciiz "WHITE\n"
print_ColorRule:.asciiz "\n\nPlease choose color (Red =0 ; White =1) for each player\n"
print_P1P2MODE: .asciiz "\n\n<<<<<<<< PLAYER 1 VS PLAYER 2 VERSION >>>>>>>>\n"
print_P1COMMODE:.asciiz "\n\n<<<<<<<< PLAYER VS COMPUTER VERSION >>>>>>>>\n"
print_C1C2MODE: .asciiz "\n\n<<<<<<<< COMPUTER VS COMPUTER VERSION >>>>>>>>\n"
askLuckyNum:    .asciiz "\n\n Before starting the game, enter your lucky number: "
print_p1turn:   .asciiz "\n\nIt's player 1's turn: "
print_p2turn:   .asciiz "\n\nIt's player 2's turn: "
print_c1turn:   .asciiz "\n\nIt's computer 1's turn: "
print_c2turn:   .asciiz "\n\nIt's computer 2's turn: "
print_currWHITE:.asciiz "\n(--Current color is white--)"
print_currRED:  .asciiz "\n(--Current color is red--)"
askR1:  .asciiz "\n\nEnter r1: "
askC1:  .asciiz "\nEnter c1: "
askR2:  .asciiz "\nEnter r2: "
askC2:  .asciiz "\nEnter c2: "
reEnter:.asciiz "\n\nYou entered invalid (r1,c2,r2,c2)! Please re-enter it:\n"
ask_WHO_1st:.asciiz "\n\nDo you want to play first or computer? (ME=1; COMPUTER=0): " 
askCOLOR:   .asciiz "\n\nChoose your color? (RED=0; WHITE=1): "
star:       .asciiz "\n******************************\n "
playerTurn: .asciiz "\n\n->Player turn: \n"
compTurn:   .asciiz "\n\n->Computer turn: \n"
totalRed:   .asciiz "\n\n*****Total of red pieces on board: "
totalWhite: .asciiz "\n\n*****Total of white pieces on board: "
playerWIN:  .asciiz "\nCongrats! You wins :)\n"
compWIN:    .asciiz "\nSorry! You loses :( \n"
p1WIN:      .asciiz "\nPLAYER 1 win!! "
p2WIN:      .asciiz "\nPLAYER 2 win!! "
c1WIN:      .asciiz "\nCOMPUTER 1 win!! "
c2WIN:      .asciiz "\nCOMPUTER 2 win!! "
newline:    .asciiz "\n"
computerNOgo:   .asciiz "\n\nComputer stuck :("
cantMOVE:       .asciiz "\n\nCAN'T find any solution :(\n"

    .globl main
    .text

main:
        li $a1,0
        li $a2,0
        li $a3,0
        li $s3,0 #set initial state
        
        # Create board [8][8]
        addi $sp,$sp, -256  #allocate space for board [8][8]
        add $a1,$a1,$sp        #save board address to a1


        la $a0,newline
        li  $v0,4
        syscall

#INITIALIZE BOARD, fill in with red and white checkers
intialize_board:

#initial RED checkers on the board
        li $t0, 0       # hold board [r][c] location
        li $t1, 0       #row=0
        li $t2, 0       #col=0 
        li $t9, 1       # hold red value
        j initial_red_outcheck
initial_red_outloop:
        j initial_red_incheck
initial_red_inloop:
        #Call isLegalPosition (r,c)

        addi $sp,$sp,-20  #allocate space for row and col      
        sw $t1, 0($sp)
        sw $t2, 4($sp)
        sw $t0, 8($sp)
        sw $t9, 12($sp)
        sw $s3, 16($sp)
        jal isLegalPosition
        lw $t1,0($sp)      #load back the original value in t0
        lw $t2,4($sp)                   # t1,t2, t9
        lw $t0,8($sp)                 
        lw $t9,12($sp)
        lw $s3, 16($sp)
        addi $sp,$sp, 20     #deallocate 

       #v0 hold if valid position, so check if(legal position)
        bne $v0,1, increase_red_Col

        li $t0,0            #reset t0=0
        add $t0,$t0,$t1     #t0+=row
        mul $t0,$t0,8       #t0*=8
        add $t0,$t0,$t2     #t0+=col
        mul $t0,$t0,4       #t0*=4-bit
        add $t0,$t0,$a1     #t0+=board address

        sw $t9,0($t0)       #store red value into board [r][c]
increase_red_Col:
        addi $t2,$t2,1          #col++;
initial_red_incheck:  
       
        blt $t2,8,initial_red_inloop        #if col<8, jump to inloop
        li $t2,0                            # set col back to 0
        addi $t1,$t1,1                          #row++;
initial_red_outcheck: 
        ble $t1,2, initial_red_outloop      #if row<=2, jump to outloop

#initial WHITE checkers on the board
        li $t0, 0       # hold board [r][c] location
        li $t1, 5       #row=0
        li $t2, 0       #col=0 
        li $t9, 3       # hold white value
        j initial_white_outcheck
initial_white_outloop:
        j initial_white_incheck
initial_white_inloop:
        #call isLegalPosition function

        addi $sp,$sp,-16  #allocate space for row and col      
        sw $t1, 0($sp)
        sw $t2, 4($sp)
        sw $t0, 8($sp)
        sw $t9, 12($sp)
        jal isLegalPosition
        lw $t1,0($sp)      #load back the original value in t0
        lw $t2,4($sp)                   # t1,t2, t9
        lw $t0,8($sp)                 
        lw $t9,12($sp)
        addi $sp,$sp, 16     #deallocate 

       #v0 hold if valid position, so check if(legal position)
        bne $v0,1, increase_white_Col

        li $t0,0
        add $t0,$t0,$t1     #t0+=row
        mul $t0,$t0,8       #t0*=8
        add $t0,$t0,$t2     #t0+=col
        mul $t0,$t0,4       #t0*=4-bit
        add $t0,$t0,$a1     #t0+=board address

        sw $t9,0($t0)       #store red value into board [r][c]
increase_white_Col:
        addi $t2,$t2,1          #col++;
initial_white_incheck:  
       
        blt $t2,8,initial_white_inloop        #if col<8, jump to inloop
        li $t2,0                              #set col back to 0
        addi $t1,$t1,1                          #row++;
initial_white_outcheck: 
        ble $t1,7, initial_white_outloop      #if row<=2, jump to outloop



###########     BEGIN THE GAME   ########################
# t7->t9 is temp reg
# a3 hold player's choice
# t1->t4 is r1,c1,r2,c2 for both player and computer
# t0 hold current color for player/computer turn
# s1-> s2 total red/white checkers
# s3 -> hold state

        li $t0, 0  #hold current color, set at red, might change when user's enter choice
        li $s1, 12 # hold current total red checkers
        li $s2, 12 # hold current total white checkers
        li $t8, 0
        li $t9, 0

#######################################
#Print border
        la $a0,star 
        li $v0,4
        syscall

# ASK USER TO CHOOSE MODE
#t7 hold user-input MODE
askAgain:
        la $a0,chooseMODE
        li $v0,4
        syscall

        li $v0,5
        syscall
        move $t7,$v0  #save "chosen MODE" into t7
#PRINT color rule
        la $a0,print_ColorRule
        li $v0,4
        syscall

#JUMP TO INDICATE MODE
        beq $t7,1,p1vsp2VER  # p1 vs p2 = 1
        beq $t7,2,p1c1VER    # p1 vs c1 = 2
        beq $t7,3,c1c2VER    # c1 vs c2 = 3
        j askAgain          # if enter WRONG OPTION , jump to AskAgain

############################################################
### PLAYER 1 VS PLAYER 2 VERSION: 
p1vsp2VER:
        
        la $a0,print_P1P2MODE
        li $v0,4
        syscall

        la $a0,p1_chooseColor
        li $v0,4
        syscall

        li $v0,5
        syscall
        move $t7,$v0  #save "chosen MODE" into t7

        beq $t7,0, p2isred

p2iswhite:
        la $a0,p2RED 
        li $v0,4
        syscall
        j callp1p2
p2isred:
        la $a0,p2WHITE 
        li $v0,4
        syscall
callp1p2:
        #void p1VSp2MODE ( p1Color)
        addi $sp, $sp, -4
        sw $t7,0 ($sp)
        jal p1VSp2VER
        addi $sp,$sp,4

        j exit

############################################################
### PLAYER  VS COMPUTER VERSION: 
p1c1VER:
        la $a0,print_P1COMMODE
        li $v0,4
        syscall
        #void p1VSc1VER (board*)
        jal p1VSc1VER
        j exit

############################################################
### COMPUTER  VS COMPUTER VERSION: 
c1c2VER:
        la $a0,print_C1C2MODE
        li $v0,4
        syscall
        jal c1VSc2VER


exit:
        li $v0,10
        syscall


################################
##########################################
isLegalPosition:
# int isLegalPosition (int row , int col ) 
#t0 store row value
#t1 store col value
#t9 hold calculation value
        lw $t0,0($sp) #store row in t0
        lw $t1,4($sp) #store col in t1
        #if t0>7 || t0<0, return 0
        bgt $t0,7, return0 
        blt $t0,0,return0

        #if t1>7 || t1<0, return 0 
        bgt $t1,7, return0 
        blt $t1,0,return0

        #else , t9=row + col
        li $t9,0
        add $t9,$t0,$t1  

        rem $t9,$t9,2 # t9=remainder= (row + col) %2
        bne $t9,0,return0  # t9!=0 =>black square, return 0
        #else will be white square, return 1
# RETURN VALUE:
return1:
        li $v0,1  # valid 
        jr $ra
return0:
        li $v0,0 # not valid
        jr $ra
##########################################
#############################
isValidMove:
# int isValidMove (int *board, int r1, int c1, int r2, int c2)
#t0,t9, t8 is temp reg, saved temp calculation.
#t1: hold board address 
#t2 -> t5: store r1,c1,r2,c2
        li $t0,0
        li $t9,0
	li $t8,0
# STORE board address from stack memory into $t1
        lw $t1, 0($sp)     

#STORE r1,c1,r2,c2 into t2->t5:
    
        lw $t2, 4($sp) #store r1 into t2
        lw $t3, 8($sp) # store c1 into t3
        lw $t4, 12($sp) #store r2 into t4
        lw $t5, 16($sp) # store c2 into t5
        

# CALL funct isLegalPosition checking r1,c1,r2,c2
  #if value=0, return 0
  #else continue checking

        #isLegalPosition(r1,c1);
        addi $sp, $sp,-16 # allocate space for r1,c1
        sw $t2, 0($sp) # store r1 to memory
        sw $t3, 4($sp) # store c1 to memory
        sw $ra, 8($sp) #store return address
        sw $t1, 16 ($sp)
        jal isLegalPosition

        #load back value from memory
        lw $t2, 0($sp) 
        lw $t3, 4($sp)
        lw $ra, 8($sp) 
        lw $t1, 12 ($sp)
        addi $sp,$sp, 16 #deallocate
        move $t8,$v0   # save return value to $t8
        #load value back from memory
  
        beq $t8,0, return_0
       

        #isLegalPosition(r2,c2);
        addi $sp, $sp,-16 # allocate space for r2,c2
        sw $t4, 0($sp) # store r2 to memory
        sw $t5, 4($sp) # store c2 to memory
        sw $ra, 8($sp) #store return address
        sw $t1, 12 ($sp)
        jal isLegalPosition

        #load back all value from memory
        lw $t4, 0($sp) 
        lw $t5, 4($sp) 
        lw $ra, 8($sp) #store back return address
        lw $t1, 16 ($sp)
        addi $sp,$sp, 16 #deallocate
        move $t8,$v0   # save return value to $t8

        beq $t8,0, return_0
        


###################
#THEN: 
#CHECK if (r1,c1) have checker or not 
       
#t8 hold (r1,c1) address (temp)
       #Load value of (r1,c1) store in t0
        li $t0,0
        li $t9,0
        li $t8,0

        mul $t8, $t2,8  # t8= r1*8
        add $t8,$t8,$t3 # t8+= c1
        mul $t8,$t8,4    # t8*=4 => get bit location for (r1,c1)
        add $t8,$t8,$t1  # t8+= t1 (board address)  
        lw $t0, 0($t8)  
        beqz $t0, return_0 # (r1,c1) have no checker, not qualify

#CHECK if (r2,c2) has checker or not
  #get the value of location (r2,c2) store into t9
#t8 hold (r2,c2) address (temp)
        li $t8,0   
        mul $t8, $t4,8  #t8=r2*8
        add $t8,$t8,$t5 # t8+=c2
        mul $t8, $t8, 4  # t8*=4-bit
        add $t8,$t8,$t1  #t8+= t1 (board address)
        lw $t9, 0($t8) #load the value inside (r2,c2) into t9

       # check if t9!=0 (have checker) or =0 (no checker) 
        bne $t9,0, return_0 # if t9!=0, return 0

# IF t9=0 (no checker), continue .... 
#FIND abs (r2-r1)
        # t9= r2-r1
         #check only t9 if asb(t9)=1, else return 0
        sub $t9, $t4,$t2 
        beq $t9,1,checktype
        beq $t9,-1,checktype
        j return_0

#FIND out the value in (r1,c1) represent what type of checker
checktype:
        #if it's a king, no need to check row again
        beq $t0,7,checkValid_col 
        beq, $t0,1,is_red
        beq, $t0, 3, is_white
        beq, $t0, 5, checkValid_col
        # in case, (r1,c1) is not qualify any above, return 0
        j return_0

notKing:
is_red:
        bne $t9,1, return_0 
        j checkValid_col #then jump to check c1 vs c2
is_white:     
        bne $t9,-1, return_0
      
# JUMP to check c1 vs c2
checkValid_col:
        #t9= c1-c2:
        sub $t9, $t3,$t5

        #check if abs(t9)= 1 or not
        beq $t9,1, return_1
        beq $t9,-1,return_1
# RETURN VALUE: 
return_0:
        li $v0,0
        jr $ra
return_1:
        
        li $v0,1      
        jr $ra

#############################################
########################################################
isValidJump:
##### int isValidJump ( int *board,int r1, int c1,int r2,int c2)
#t1: store board address
#t2 -> t5: store r1,c1,r2,c2,
#t6, t7: store rm, cm
#t0,t9,t8: is temp reg, saved temporary calculation.

        li $t0,0
        li $t9,0
# STORE board address from stack memory into $t1
        lw $t1, 0($sp)     

# STORE r1,c1,r2,c2 into t2->t5:
        lw $t2, 4($sp) #store r1 into t2
        lw $t3, 8($sp) # store c1 into t3
        lw $t4, 12($sp) #store r2 into t4
        lw $t5, 16($sp) # store c2 into t5

# CALL funct isLegalPosition checking r1,c1,r2,c2
  #if value=0, return 0
  #else continue checking

        #isLegalPosition(r1,c1);
        addi $sp, $sp,-16 # allocate space for r1,c1 and $ra address
        sw $t2, 0($sp) # store r1 to memory
        sw $t3, 4($sp) # store c1 to memory
        sw $ra, 8($sp) # store the return address to memoory
        sw $t1, 12($sp)
        jal isLegalPosition
        #load back all value from memory
        lw $t2, 0($sp) 
        lw $t3, 4($sp) 
        lw $ra, 8($sp)
        lw $t1, 12($sp)
        addi $sp,$sp, 16 #deallocate 

        move $t8, $v0 #save return value to t8
        beqz $t8, returnZero
       

        #isLegalPosition(r2,c2);
        addi $sp, $sp,-16 # allocate space for r1,c1
        sw $t4, 0($sp) # store r2 to memory
        sw $t5, 4($sp) # store c2 to memory
        sw $ra, 8($sp) # store the return address
        lw $t1, 12($sp)
        jal isLegalPosition
        lw $t4, 0($sp) 
        lw $t5, 4($sp) 
        lw $ra, 8($sp)
        lw $t1, 12($sp)
        addi $sp,$sp, 16 #deallocate

        move $t8,$v0    #save return value to t8
        beq $t8,0, returnZero
      

# CHECK if (r1,c1) have checker or not 
checkR1C1:       
       #Load value of (r1,c1) store in t0
#t6 hold (r1,c1) address (temp)

        mul $t6, $t2,8  # t6= r1*8
        add $t6,$t6,$t3 # t6+= c1
        mul $t6,$t6,4    # t6*=4-bit => get bit location for (r1,c1)
        add $t6,$t6,$t1  # t6+= t1 (board address)  
        lw $t0, 0($t6)  

        beqz $t0, returnZero # (r1,c1) have no checker, not qualify
    
# CHECK if (r2,c2) have checker or not
checkR2C2: 
#t6 hold (r2,c2) address (temp)
        #Load value of (r2,c2) store in t9
        mul $t6, $t4,8  # t6= r2*8
        add $t6,$t6,$t5 # t6+= c2
        mul $t6,$t6,4    # t6*=4 => get bit location for (r2,c2)
        add $t6,$t6,$t1 # t6+= t1 (board address)  
        lw $t9, 0($t6)  

        bnez $t9, returnZero # (r2,c2)!=0, have checker, not qualify.

# CHECK the r2 is a qualify row for jumping
        # t9= r2-r1
         #check only t9 if asb(t9)=2, else return 0
        sub $t9, $t4,$t2

        beq $t9,2,findMid
        beq $t9,-2,findMid
        j returnZero
findMid:
#FIND the middle location and its value
        #store rm into t6
        li $t8,2
#t8 hold value 2 (temp)
        add $t6,$t4,$t2   #t6= r2+r1
        div $t6,$t8       #t6=t6/2 (quotient)
        mflo $t6
        #store cm into t7
        add $t7, $t5,$t3 #t7= c2+c1
        div $t7,$t8        #t7= t7/2 (quotient)
        mflo $t7
#t6 hold address of (rm,cm) (temp)  
        #store value (rm,cm) into t9
        mul $t6, $t6,8  # t6= rm*8
        add $t6,$t6,$t7 # t6+= cm
        mul $t6,$t6,4    # t6*=4-bit => get bit location for (rm,cm)
        add $t6,$t6,$t1  # t6+= t1 (board address)  
#t8 hold value in (rm,cm)
        lw $t8, 0($t6)  

        #check if (rm,cm) have checker or not
        bne $t8,0, checker_Mid 

# CASE 1: no checker in the middle (t8=0)
        j returnZero

# CASE 2: have checker in the middle (t8!=0)
checker_Mid:

# FIND out value in (r1,c1) represent what type of checker
       #then jump to checking part base on its type
        beq $t0,1, isReg_red # (r1,c1)= 'r'
        beq $t0,3, isReg_white # (r1,c1)= 'w'
        beq $t0,7, is_whitepiece # (r1,c1)= 'W'
        beq, $t0, 5, is_redpiece # (r1,c1)= 'R'

         #print out t0 
        la $a0, numberIs
        li $v0,4
        syscall

        move $a0, $t0
        li $v0,1
        syscall

        la $a0, newline
        li $v0,4
        syscall

        # else return 0 
        j returnZero

# IF it's a REGULAR checker piece
 #check if t9 =r2-r1, equal to -2 for white and 2 for red
 #else return 0
isReg_red: 
        beq $t9,2,is_redpiece
        j returnZero
isReg_white:
        beq $t9,-2,is_whitepiece  
        j returnZero

#CHECKING COLOR of checker piece:
checkcolor:
#latest t0 store value of (r1,c1)
      # t8 store value of (rm,cm)
        #If (r1,c1) have different color with (rm,cm) either king or regular piece 
         #return 1

is_whitepiece:#when (r1,c1)='W' or 'w'

        beq $t8,1,returnOne #(rm,cm)='r', return 1
        beq $t8,5,returnOne #(rm,cm)='R', return 1
        j returnZero
is_redpiece:#when (r1,c1)='R' or 'r'
        beq $t8,3,returnOne #(rm,cm)='w', return 1
        beq $t8,7,returnOne #(rm,cm)='W', return 1

# RETURN VALUE:    
returnZero:
        li $v0,0
        jr $ra
returnOne:
        li $v0,1
        jr $ra

#########################################
####################################################
getValidJumps:
#getValidJumps(board,validJumps,color)
#s1= board[][] address 
#s2= validJumps[][] address
#s3= total 
#t1->t4 = r1,c1,r2,c2
#t5: store color
#t0,t7,t9: temp reg for calculation

        li $s3 ,0

        lw $s1,0($sp)   #load board[][] address from memory
        lw $s2,4($sp)   #load tuplesList[][] address from memory
        lw $t5,8($sp)   #load color from memory
     
        li $t1,0  #set r1=0 
        li $t2,0  #set c1=0
        li $t3,-2        #set r2=-1 (r1-2)
        li $t4,-2      #set c2=-1 (c1-2)
        j For1check

For1loop:
  
        j For2check
For2loop:
      
        j For3check
For3loop:
  
        j For4check
For4loop:

        
        #check the color
        li $t0,0        #reset t0=0
         #get (r1,c1) location in the board
        mul $t0,$t1,8       #t0 = r1*8
        add $t0,$t0,$t2     #t0 +=c1
        mul $t0,$t0,4       #t0*=4-bit
        add $t0,$t0,$s1     #t0+= board address
         
         #find value in (r1,c1), check if it matches with the color (t5)
        lw $t7, 0($t0)      # load value of (r1,c1) into t7
        bne $t5,1, red_is0    # if t5=0=red, jump to red_is0   

white_is1:#the color (t5) =1 is white
        
        #if (r1,c1) is white, go to find_valid_jump
        beq $t7,7,find_valid_Jump   #white king
        beq $t7,3,find_valid_Jump   #white regular
        #else skip to next (r1,c1)
        j Incre

red_is0:#the color (t5) =0 is red
        beq $t7,5,find_valid_Jump   #red king
        beq $t7,1,find_valid_Jump   #red regular
        #else skip to next (r1,c1)
        j Incre

find_valid_Jump:

      
        #Call funct isValidJump(*board,r1,c1,r2,c2)
        addi $sp,$sp,-40    #allocate space for 5 parameters
        sw $s1 0($sp)     #store board address
        sw $t1,4($sp)     #store r1   
        sw $t2,8($sp)     #store c1 
        sw $t3,12($sp)    #store r2
        sw $t4,16($sp)    #store c2    
        sw $t5,20($sp)
        sw $t7,24($sp)
        sw $t9,28($sp)
        sw $s3,32($sp)      
        sw $ra,36($sp)    #store $ra

        jal isValidJump

        #load back all original value
        lw $s1 0($sp)     
        lw $t1,4($sp)      
        lw $t2,8($sp)     
        lw $t3,12($sp)    
        lw $t4,16($sp)       
        lw $t5,20($sp)
        lw $t7,24($sp)
        lw $t9,28($sp)
        lw $s3,32($sp)      
        lw $ra,36($sp)    

        move $t0,$v0    #move return value to t0

        addi $sp,$sp,40 #deallocate 

        
        #check if (t0==1)...
        bne $t0,1,Incre     #if v0!=1, jump to incre
       
        mul $t9, $s3, 4     #t9= num *4
        mul $t9, $t9,4      #t9*=4 bit   
        add $t9, $t9, $s2   #t9= t9 + address of tuppleList[][]
        sw $t1, 0($t9)      #tuples[num][0]=r1;
        sw $t2, 4($t9)      #tuples[num][1]=c1;
        sw $t3, 8($t9)      #tuples[num][2]=r2;
        sw $t4, 12($t9)     #tuples[num][3]=c2;
        addi $s3,$s3,1          #num++;
        #j ForloopBreak     # break when get a tupple added to the list
Incre:
        addi $t4,$t4,4   # c2+=4;
        
For4check:
        addi $t0,$t2,2          #t0=c1+2     
        ble $t4,$t0, For4loop   # if c2<=(c1+2), jump to for4loop
        addi $t4, $t2,-2        #reset c2=c1-2
        addi $t3,$t3,4              # r2+=4;
For3check:
        addi $t0,$t1,2          #t0=r1+2
        ble $t3,$t0, For3loop   # if r2<=(r1+2), jump to for3loop
        addi $t3,$t1,-2         #reset r2=r1-2
        addi $t2,$t2,1              # c1++;
        addi $t4, $t2,-2        #reset c2=c1-2
For2check:
        blt $t2,8, For2loop # if c1<8, jump to for2loop 
        li $t2,0                #reset c1=0
        addi $t1,$t1,1           # r1++; 
        addi $t3,$t1,-2         #reset r2=r1-2
For1check:
        blt $t1,8, For1loop # if r1<8, jump to for1loop

ForloopBreak:
        move $v0,$s3        #return num;
        jr $ra
######################################################
####################################################
getValidMoves:
#getValidMoves(board,validMoves,color)
#s1= board[][] address 
#s2= tuplesList[][] address
#s3= total 
#t1->t4 = r1,c1,r2,c2
#t5: store color
#t0,t7,t9: temp reg for calculation
        li $s3,0
        lw $s1,0($sp)   #load board[][] address from memory
        lw $s2,4($sp)   #load tuples[][] address from memory
        lw $t5,8($sp)   #load color from memory
     
        li $t1,0  #set r1=0 
        li $t2,0  #set c1=0
        li $t3,-1     #set r2=-1  (r1-1)
        li $t4,-1     #set c2=-1  (c1-1)
        j for1check

#######################
#print test
la $a0, insideMovefunct
li $v0,4
syscall
##############
for1loop:

        j for2check
for2loop:

        j for3check
for3loop:

        j for4check
for4loop:

        #check the color
          #get (r1,c1) location in the board
        li $t0,0            #reset t0=0
        mul $t0,$t1,8       #t0 = r1*8
        add $t0,$t0,$t2     #t0 +=c1
        mul $t0,$t0,4       #t0*=4-bit
        add $t0,$t0,$s1     #t0+= board address
         
          #find value in (r1,c1), check if it matches with the color (t5)
        lw $t7, 0($t0)      # load value of (r1,c1) into t7
  
        bne $t5,1, red_0    # if t5=0=red, jump to red_0   


white_1:#the color (t5) =1 is white
       
        #if (r1,c1) is white, go to find_valid_move
        beq $t7,7,find_valid_Move   #white king
        beq $t7,3,find_valid_Move   #white regular
        #else skip to next (r1,c1)
        j incre

red_0:#the color (t5) =0 is red
    
        beq $t7,5,find_valid_Move   #red king
        beq $t7,1,find_valid_Move   #red regular
        #else skip to next (r1,c1)
        j incre

find_valid_Move:

        #Call funct isValidMove(*board,r1,c1,r2,c2)
        addi $sp,$sp,-40   #allocate space for 5 parameters
        sw $s1, 0($sp)     #store board address
        sw $t1,4($sp)     #store r1   
        sw $t2,8($sp)     #store c1 
        sw $t3,12($sp)    #store r2
        sw $t4,16($sp)    #store c2 
        sw $t5, 20 ($sp)
        sw $t7, 24 ($sp)
        sw $t9, 28 ($sp)
        sw $s3, 32 ($sp)       
        sw $ra, 36($sp)    #store $ra
        
        jal isValidMove
      
        #load back  all original values in current registers
        lw $s1, 0($sp)    
        lw $t1,4($sp)    
        lw $t2,8($sp)     
        lw $t3,12($sp)    
        lw $t4,16($sp)   
        lw $t5, 20 ($sp)
        lw $t7, 24 ($sp)
        lw $t9, 28 ($sp)
        lw $s3, 32 ($sp)       
        lw $ra, 36($sp)  

        move $t0,$v0    #move return value to t0
        addi $sp,$sp,40    #Deallocate 

        #check if (t0==1)...
        bne $t0,1,incre     #if v0!=1, jump to incre
       
        mul $t9, $s3, 4     #t9= num *4
        mul $t9, $t9,4      #t9*=4 bit   
        add $t9, $t9, $s2   #t9= t9 + address of tuppleList[][]
        sw $t1, 0($t9)      #tuples[num][0]=r1;
        sw $t2, 4($t9)      #tuples[num][1]=c1;
        sw $t3, 8($t9)      #tuples[num][2]=r2;
        sw $t4, 12($t9)     #tuples[num][3]=c2;
        addi $s3,$s3,1          #num++;

        #j forloop_break     # break when get a tupple added to the list
incre:
        addi $t4,$t4,2   # c2+=2;
        
for4check:
        addi $t0,$t2,1          #t0=c1+1     
        ble $t4,$t0, for4loop   # if c2<=(c1+1), jump to for4loop
        addi $t4, $t2,-1        #reset c2=c1-1
        addi $t3,$t3,2              # r2+=2;
for3check:
        addi $t0,$t1,1          #t0=r1+1
        ble $t3,$t0, for3loop   # if r2<=(r1+1), jump to for3loop
        addi $t3,$t1,-1         #reset r2=r1-1
        addi $t2,$t2,1              # c1++;
        addi $t4, $t2,-1        #reset c2=c1-1
for2check:
        blt $t2,8, for2loop # if c1<8, jump to for2loop 
        li $t2,0  #reset c1=0
        addi $t1,$t1,1   # r1++; 
        addi $t3,$t1,-1         #reset r2=r1-1
for1check:
        blt $t1,8, for1loop # if r1<8, jump to for1loop

forloop_break:
        move $v0,$s3        #return num;
        jr $ra
######################################################################
################
generateRANDOM:
###  int generateRANDOM (int userInput_RandNUM)
#t0 hold tap
#t1 hold user_input --> STATE
#t2 hold B= state & 0x1;
#t3 hold randnum
#t9= int i (use in for loop)

        #tap =  x^20 + x^19 + x^16 + x^14 (leave last digit)=0000000000001100101000000000000
        #store tap in t0        
        li $t0,0x000CA000 

        #set t3=randnum=0
        li $t3,0

        #load user_input from memory into t1 
        lw $t1, 0($sp)

        #generate random num (5-bit) using for loop
# t9= int i
        li $t9, 0

        j FOR_check
        # for (int i=0; i<5; i++)
FOR_loop:

	#CALL FUNCT: state = LFSR (int tap, int state)
            #call LFSR(state)
            addi $sp,$sp, -20
            sw $t0,0($sp)  #store tap
            sw $t1,4($sp)  #store STATE
            sw $t3,8($sp)
            sw $t9, 12($sp)
            sw $ra, 16($sp)

            jal LFSR #CALL

            #load back original value for tap, i and $ra 
            lw $t0,0 ($sp)
            lw $t3,8 ($sp)
            lw $t9,12($sp)
            lw $ra,16($sp)

            #set state= new state (return value)
            move $t1, $v0

            #deallocate
            addi $sp,$sp, 20

        # STORE new state back into memory
            sw $t1, 0($sp)
	#CALCULATE B= state & 0x1;
#t2 hold B value
#t8 hold 0x01 value (temp)

            #calculate
            li $t8, 0x01
            and $t2, $t1, $t8 

	#GENERATE rand= (rand <<1) | B;  #rand shift left, then or with B
#t3 hold randnum
            # randnum shift left 1
            sll $t3,$t3,1

            # randnum or with B
            or $t3,$t3,$t2

        #INCREASE count , t9++
        addi $t9,$t9,1

FOR_check:
        blt $t9,5,FOR_loop

        #return value
        move $v0,$t3
        jr $ra

######################################################       
LFSR:
## int LFSR (int tap, int state)
#t0 hold tap
#t1 hold state
#t3 hold LSB

        lw $t0, 0($sp)          #load tap
        lw $t1, 4($sp)          #load state
        # t3 = t1 & 1 = LSB
        andi $t3,$t1,1           #find the LSB; LSB=t3
        #check t3 if (t3==1)
        beq $t3,1,withTap 
        # shift right t1 to 1 
        srl $t1,$t1,1            #shift t1 to 1 bit and store in t1
     
        #return new state in t1
        move $v0,$t1
        jr $ra
withTap:
        # shift right t1 to 1 
        srl $t1,$t1,1            #shift t1 to 1 bit and store in t1
        #xor with taps
        xor $t1,$t1,$t0      
       
        # then return new state in t1
        move $v0, $t1
        jr $ra

##############################################################
Print_Out:
# Print_Out (int *board)
        # load board address into t1
        lw $t1, 0($sp)

        li $t2,0 #count row
        li $t4,0 #count column
        li $t0,0 #reset array location to 0
        li $t3,0 # t3 store int from memory
        li $s4,0 #s4 store value indicated a character.
        j check_col
loop:
positionInArray_is:
  #determine specific location in array by row*8+column, and store it to t0
        mul $t0,$t2,8   # t0= row*8
        add $t0,$t0,$t4 # t0= t0 +col
    
        mul $t0,$t0,4   # t0= t0* 4-bit 
        add $t0,$t1,$t0 # t0= t0 + board address

        lw $t3,0($t0)   # load value (row,col) from memory and store into t3
        beq $t3,5,b5
        beq $t3,3,b3
        beq $t3,7,b7
        beq $t3,1,b1
        j BWsquare
b5: #board[r,c]=5
        li $s4,82 #set num value for 'R'
        j Print
b3: #board[r,c]=3
        li $s4,119 #set num value for 'w'
        j Print
b7: #board[r,c]=7
        li $s4,87 #set num value for 'W'
        j Print
b1: #board[1,0]=1
        li $s4,114 #set num value for 'r'
        j Print


BWsquare:

else1: #if there is no checker, (s4!=0) print black/white char

findRem_to2: # determine even or odd spot
        rem $t3,$t4,2 # t3 store remainder determine even or odd spot

IF_evenRow: 
#If it's an even row, white square start first
        rem $t5,$t2,2 # t5 store remainder determine even or odd row 
        beq $t5,0,if2 #even row
        j if3 #odd row
          
# if for even row
if2:      beq $t3,0,even2

odd2:     li $s4,219 
          j Print

even2:    li $s4,32
          j Print
ELSE_oddRow:
#if it's an odd row, black square start first
         
if3:      beq $t3,0,even3

odd3:     li $s4,32
          j Print

even3:    li $s4,219

Print:
addNewLine:        
#take remainder to locate whether newline is needed 
        bne $t4,0,printchar 

# #if it's a first number of a row (col=t4=0), then add newline before print int
        la $a0,newline   
        li $v0,4
        syscall

#else continue print next int
printchar:
        move $a0,$s4 
        li $v0,11    #print char
        syscall
increment:     
        addi $t4,$t4,1 #increase column

check_col:
        blt $t4,8,loop
        li $t4,0 #reset column to 0 if column=8
        addi $t2,$t2,1 #increase row if column=8

check_row:
        blt $t2,8, loop

        jr $ra #return to calling func

###########################################################################
####################################################################################
p1VSp2VER:
#void p1VSp2MODE (p1Color)
# t7->t9 is temp reg
#a1 (global) hold board address
#t0 hold current color, hold player1 color at beginnig,
#s1,s2 hold total red/white checkers
#s3 hold p1 color
#t1->t4 hold r1,c1,r2,c2 input

        lw $t0, 0($sp)  #hold current color, start at p1 color at begining
        lw $s3, 0($sp)  # hold p1 color
        li $s1, 12 # hold current total red checkers
        li $s2, 12 # hold current total white checkers
        li $t8, 0
        li $t9, 0
        j while_check_IN_p1p2ver
do_loop_IN_p1p2ver:

#DISPLAY BOARD
display_IN_p1p2ver:
        
        la $a0,star 
        li $v0,4
        syscall

        addi $sp, $sp, -24       #allocate
        sw $a1, 0($sp)          #store board address to memory
        sw $t0, 4($sp)
        sw $s1, 8($sp)
        sw $s2, 12($sp)
        sw $s3, 16($sp)
        sw $ra, 20($sp)

        jal Print_Out
         #load back t0,s1,s2 original value from memory
        lw $a1, 0($sp) 
        lw $t0, 4($sp)
        lw $s1, 8($sp)
        lw $s2, 12($sp)
        lw $s3, 16($sp)
        lw $ra, 20($sp)

        addi $sp, $sp, 24        #deallocate

#print current total checkers on both color:
        la $a0, totalRed
        li $v0,4
        syscall
        move $a0,$s1
        li $v0,1
        syscall

        la $a0, totalWhite
        li $v0,4
        syscall
        move $a0,$s2
        li $v0,1
        syscall
        la $a0,newline
        li $v0,4
        syscall
        #print which player's turn:
        beq $t0,$s3, p1turn

        la $a0, print_p2turn
        j p2turn
p1turn:      
        la $a0, print_p1turn
p2turn:
        li $v0,4
        syscall
        #print current color:

        beq $t0,1, iswhite 
isred:  
        la $a0, print_currRED
        li $v0,4
        syscall
        j askfor_r1c1r2c2_IN_p1p2ver
iswhite:
        la $a0,print_currWHITE
        li $v0,4
        syscall

#ASK USER for r1,c1,r2,c2
askfor_r1c1r2c2_IN_p1p2ver:
        la $a0,askR1
        li $v0,4
        syscall
        li $v0,5
        syscall
        move $t1,$v0    #save r1->t1

        la $a0,askC1
        li $v0,4
        syscall
        li $v0,5
        syscall
        move $t2,$v0    #save c1->t2

        la $a0,askR2
        li $v0,4
        syscall
        li $v0,5
        syscall
        move $t3,$v0    #save r2->t3

        la $a0,askC2
        li $v0,4
        syscall
        li $v0,5
        syscall
        move $t4,$v0    #save c2->t4

#CHECK R1C1 COLOR
#t0 hold curColor value
#use t9 to hold (r1,c1) value (temp)
#use t8 to hold (r1,c1) location (temp)

        #save value of (r1,c1) into t9 temporarily 
                #from address saved in t8
        
        li $t8,0                #reset t8=0
        mul $t8,$t1,8           #t8=t1*8
        add $t8,$t8,$t2         #t8+=t2
        mul $t8,$t8,4           #t8*=4-bit
        add $t8,$t8,$a1         #t8+=board address

        lw $t9, 0($t8)          #load value (r1,c1) from memory to t9

        #find the color of the (r1,c1)
                # (r1,c1) = 7 || 3 is white piece
                beq $t9,7,r1c1_isWhite_IN_p1p2ver
                beq $t9,3,r1c1_isWhite_IN_p1p2ver

                # (r1,c1) = 1 || 5 is red piece
                beq $t9,1,r1c1_isRed_IN_p1p2ver
                beq $t9,5,r1c1_isRed_IN_p1p2ver

                # if not,  player entered invalid value
                 #print message
                la $a0, reEnter
                li $v0,4
                syscall
                 #ask player to re-enter value
                j askfor_r1c1r2c2_IN_p1p2ver    

        #compare (r1,c1) with current color (t0)
                #if (r1,c1)=curColor
r1c1_isRed_IN_p1p2ver: 
                beqz $t0, check_JUMP_IN_p1p2ver    #if color is match, go to check_JUMP

                #else player entered invalid value
                 #print message
                la $a0, reEnter
                li $v0,4
                syscall
                 #ask player to re-enter value
                j askfor_r1c1r2c2_IN_p1p2ver    

r1c1_isWhite_IN_p1p2ver:
                beq $t0,1, check_JUMP_IN_p1p2ver   #if color is match, go to check_JUMP
                #else player entered invalid value
                 #print message
                la $a0, reEnter
                li $v0,4
                syscall
                 #ask player to re-enter value
                j askfor_r1c1r2c2_IN_p1p2ver     

#CALL FUNCT isValidJump 
        #int isValidJump ( int *board,int r1, int c1,int r2,int c2)
check_JUMP_IN_p1p2ver:
        addi $sp, $sp, -40             #allocate space for 5 parameters
        sw $a1, 0($sp)
        sw $t1, 4($sp)
        sw $t2, 8($sp)
        sw $t3, 12($sp)
        sw $t4, 16($sp)
        sw $t0, 20($sp)
        sw $s1, 24($sp)
        sw $s2, 28 ($sp)
        sw $s3, 32 ($sp)
        sw $ra, 36 ($sp)

        jal isValidJump
        #load back all value from memory
        lw $a1, 0($sp)
        lw $t1, 4($sp)
        lw $t2, 8($sp)
        lw $t3, 12($sp)
        lw $t4, 16($sp)
        lw $t0, 20($sp)
        lw $s1, 24($sp)
        lw $s2, 28 ($sp)
        lw $s3, 32 ($sp)
        lw $ra, 36($sp)
     
        addi $sp,$sp,40 #deallocate

#t9 hold return value (temp)
        move $t9,$v0   
 
        #if return invalid, jump to check_MOVE
        bne $t9,1,check_MOVE_IN_p1p2ver

        #else return valid, then

                #update current of the total checkers
                beqz $t0, ValidJUMP_delete_WHITE_IN_p1p2ver       
ValidJUMP_delete_RED_IN_p1p2ver: # white piece EATs red piece
                sub $s1,$s1, 1         #currentRED-=1;
                j CalculateRmCm_IN_p1p2ver 
ValidJUMP_delete_WHITE_IN_p1p2ver:# red piece EATs white piece
                sub $s2,$s2, 1         #currentWHITE-=1;

CalculateRmCm_IN_p1p2ver:
                #calculate (rm,cm) 
#t7 hold value 2 (temp)
                li $t7,2                #set t7=2
#t8 hold rm (temp)
                add $t8, $t1, $t3       #t8=r1+r2
                div $t8, $t7            #t8=t8/2
                mflo $t8                #save quotient to t8

#t9 hold cm (temp)
                add $t9, $t2, $t4       #t9=c1+c2
                div $t9, $t7              #t9=t9/2
                mflo $t9                #save quotient to t8
#t8 hold (rm,cm) location
                mul $t8,$t8,8           #t8= rm*8
                add $t8,$t8,$t9         #t8=t8+ cm
                mul $t8,$t8,4           #t8=t8* 4-bit
                add $t8,$t8,$a1         #t8=t8+ board address
           
                #locate (rm,cm) and remove game piece (set to 0)
                sw $zero, 0($t8)        #(rm,cm)=0
                #then, move (r1,c1) -> (r2,c2)
                j mover1c1_2r2c2_IN_p1p2ver

#CALL FUNCT isValidMove 
        #int isValidMove ( int *board,int r1, int c1,int r2,int c2)
check_MOVE_IN_p1p2ver:

        addi $sp, $sp, -40             #allocate space for 5 parameters
        sw $a1, 0($sp)
        sw $t1, 4($sp)
        sw $t2, 8($sp)
        sw $t3, 12($sp)
        sw $t4, 16($sp)
        sw $t0, 20($sp)
        sw $s1, 24($sp)
        sw $s2, 28 ($sp)
        sw $s3, 32 ($sp)
        sw $ra, 36 ($sp)
        jal isValidMove
        # load back all value from memory
        lw $a1, 0($sp)
        lw $t1, 4($sp)
        lw $t2, 8($sp)
        lw $t3, 12($sp)
        lw $t4, 16($sp)
        lw $t0, 20($sp)
        lw $s1, 24($sp)
        lw $s2, 28 ($sp)
        lw $s3, 32 ($sp)
        lw $ra, 36($sp)
        addi $sp,$sp, 40        #deallocate
#t9 hold return value (temp)
        move $t9,$v0 

        #if return valid 
        beq $t9, 1, mover1c1_2r2c2_IN_p1p2ver 

        #else player entered invalid value
                #print message
                la $a0, reEnter
                li $v0,4
                syscall
                 #ask player to re-enter value
                j askfor_r1c1r2c2_IN_p1p2ver

#MOVE (r1,c1) -> (r2,c2)
mover1c1_2r2c2_IN_p1p2ver:  
#t8 hold (r1,c1) address (temp)
#t9 hold value in (r1,c1) (temp)

        #locate (r1,c1)
        li $t8,0                #reset t8
        mul $t8, $t1,8          #t8=r1*8
        add $t8,$t8,$t2         #t8=t8+c1
        mul $t8,$t8,4           #t8=t8*4-bit
        add $t8,$t8,$a1         #t8=t8+ board address

        #save value in (r1,c1) to t9
        lw $t9, 0($t8)

       
        #remove (r1,c1) game piece (set to 0)
        li $t7,0
        sw $t7, 0($t8)

#t8 hold (r2,c2) address (temp)
        #locate (r2,c2)
        li $t8,0                #t8=0
        mul $t8, $t3,8          #t8=r2*8
        add $t8,$t8,$t4         #t8=t8+c2
        mul $t8,$t8,4           #t8=t8*4-bit
        add $t8,$t8,$a1         #t8=t8+ board address

        #change value of (r2,c2) => value of (r2,c2)=(r1,c1)=t9
        sw $t9, 0($t8)

#CONVERT TO KING CHECK

        bnez $t0, KING_WHITEcheck_IN_p1p2ver      #if current player is white, (t0=1 !=0),
                                        #jump to check if needed to turn WHITE KING

KING_REDcheck_IN_p1p2ver:#else, current player is red, check if needed to turn to RED KING

        # if (r2!=7), jump to change color
        bne $t3, 7, changeCOLOR_IN_p1p2ver
        # set t9 hold value 5 (RED KING)
        li $t9, 5
        # jump to Convert2KING
        j Convert2KING_IN_p1p2ver
        
KING_WHITEcheck_IN_p1p2ver:
        #if (r2!=0), jump to do_loop
        bnez $t3, changeCOLOR_IN_p1p2ver
         # set t9 hold value 7 (WHITE KING)
        li $t9, 7
        # jump to Convert2KING
       
Convert2KING_IN_p1p2ver:
#t8 still hold (r2,c2) address from above (temp)
#t9 hold KING value that will be saved into (r2,c2)
        #change color value of (r2,c2)

        sw $t9,0($t8)

#CHANGE CURRENT COLOR
        #if current color is !=0, jump to SETcolor_to0
changeCOLOR_IN_p1p2ver:     
        beq $t0,1, SETcolor_to0

SETcolor_to1_IN_p1p2ver:
        li $t0,1
        j while_check_IN_p1p2ver

SETcolor_to0:
        li $t0,0

while_check_IN_p1p2ver:
# if (red_total==0) || (white_total==0) then jump to declareWINNER
        beqz $s1,declareWINNER_IN_p1p2ver    
        beqz $s2,declareWINNER_IN_p1p2ver     
        j do_loop_IN_p1p2ver

declareWINNER_IN_p1p2ver:
#in the last turn, color (t0) is changed then stop the loop,
    #so loser will be the one with current color played. 
    #check with s3 to know if current turn is p1 or p2's turn
        beq $t0,$s3,player2win   #if it's p1 turn (t0=s3) then p2 win
        
player1win:# else p1 win
        la $a0,p1WIN
        li $v0,4
        syscall

        j jumpback_IN_p1p2ver
player2win:
        la $a0,p2WIN
        li $v0,4
        syscall

jumpback_IN_p1p2ver:
        jr $ra 

####################################################################################
#############################################################################################
p1VSc1VER:
#void p1VSc1VER (board*)
#a1 (global) hold board address
#a2 hold Jump/Move List address
#a3 hold player's choice of color
#s1-s2 hold total red/white checkers
#s3 hold STATE
#t0 hold current color
#t1->t4 hold r1,c1,r2,c2 input


#ASK USER a random number to set the initial state 
        la $a0, askLuckyNum
        li $v0, 4
        syscall

        li $v0,5
        syscall
        move $v0,$s3  #save rand num to s3

#ASK USER to choose color
        la $a0,askCOLOR
        li $v0,4
        syscall 
        li $v0,5 #read-in value
        syscall
        move $a3,$v0    #save player's choice->a3

#ASK FOR WHO PLAY FIRST
        la $a0,ask_WHO_1st
        li $v0,4
        syscall 
        li $v0,5
        syscall
        move $t9,$v0

        #Print border
        la $a0,star 
        li $v0,4
        syscall

#CHECK whose play fisrt
#t9 hold  player's choice of who go first (temp)
        beqz $t9,comp_first #if player want to go first (t9=1) jump to player turn
player_first:
        move $t0,$a3        #set current room to player's color
        j display_IN_p1c1ver
comp_first:
        beq $a3,0, set_curr_2white
set_curr_2red:
        li $t0,0
        j printCurrentCOLOR_IN_p1c1ver
set_curr_2white:
        li $t0,1        
        j printCurrentCOLOR_IN_p1c1ver

do_loop_IN_p1c1ver:

#DISPLAY BOARD
display_IN_p1c1ver:

        addi $sp, $sp, -24       #allocate
        sw $a1, 0($sp)          #store board address to memory
        sw $t0, 4($sp)
        sw $s1, 8($sp)
        sw $s2, 12($sp)
        sw $s3, 16($sp)
        sw $ra, 20($sp)

        jal Print_Out
         #load back t0,s1,s2 original value from memory
        lw $a1, 0($sp)
        lw $t0, 4($sp)
        lw $s1, 8($sp)
        lw $s2, 12($sp)
        lw $s3, 16($sp)
        lw $ra, 20 ($sp)
        addi $sp, $sp, 24        #deallocate

#print current total checkers on both color:
        la $a0, totalRed
        li $v0,4
        syscall
        move $a0,$s1
        li $v0,1
        syscall

        la $a0, totalWhite
        li $v0,4
        syscall
        move $a0,$s2
        li $v0,1
        syscall
        la $a0,newline
        li $v0,4
        syscall

printCurrentCOLOR_IN_p1c1ver:
#PRINT current color
        beq $t0,1, printCurr_white_IN_p1c1ver
printCurr_red_IN_p1c1ver:
        la $a0, print_currRED
        li $v0,4
        syscall
        j printWhoseTurn_IN_p1c1ver

printCurr_white_IN_p1c1ver:
        la $a0, print_currWHITE
        li $v0,4
        syscall

printWhoseTurn_IN_p1c1ver:       
#PRINT whose turn 

        # if current color (t0) == player's color, then it's player turn
        beq $t0,$a3,playerGO 
        # else it's computer turn
compGO:

        la $a0,compTurn
        li $v0,4
        syscall 

        la $a0, newline
        li $v0,4
        syscall

        j compGENERATE_IN_p1c1ver  # if computer turn, jump directly to comp's part

#####################################################################
##################### PLAYER PLAY PART
playerGO:


        la $a0,playerTurn
        li $v0,4
        syscall 

        la $a0, newline
        li $v0,4
        syscall

#ASK USER for r1,c1,r2,c2
askfor_r1c1r2c2_IN_p1c1ver:
        la $a0,askR1
        li $v0,4
        syscall
        li $v0,5
        syscall
        move $t1,$v0    #save r1->t1

        la $a0,askC1
        li $v0,4
        syscall
        li $v0,5
        syscall
        move $t2,$v0    #save c1->t2

        la $a0,askR2
        li $v0,4
        syscall
        li $v0,5
        syscall
        move $t3,$v0    #save r2->t3

        la $a0,askC2
        li $v0,4
        syscall
        li $v0,5
        syscall
        move $t4,$v0    #save c2->t4

#CHECK R1C1 COLOR
#t0 hold curColor value
#use t9 to hold (r1,c1) value (temp)
#use t8 to hold (r1,c1) location (temp)

        #save value of (r1,c1) into t9 temporarily 
                #from address saved in t8
        
        li $t8,0                #reset t8=0
        mul $t8,$t1,8           #t8=t1*8
        add $t8,$t8,$t2         #t8+=t2
        mul $t8,$t8,4           #t8*=4-bit
        add $t8,$t8,$a1         #t8+=board address

        lw $t9, 0($t8)          #load value (r1,c1) from memory to t9

        #find the color of the (r1,c1)
                # (r1,c1) = 7 || 3 is white piece
                beq $t9,7,r1c1_isWhite_IN_p1c1ver
                beq $t9,3,r1c1_isWhite_IN_p1c1ver

                # (r1,c1) = 1 || 5 is red piece
                beq $t9,1,r1c1_isRed_IN_p1c1ver
                beq $t9,5,r1c1_isRed_IN_p1c1ver

                # if not,  player entered invalid value
                 #print message
                la $a0, reEnter
                li $v0,4
                syscall
                 #ask player to re-enter value
                j askfor_r1c1r2c2_IN_p1c1ver    

        #compare (r1,c1) with current color (t0)
                #if (r1,c1)=curColor
r1c1_isRed_IN_p1c1ver: 
                beqz $t0, check_JUMP_IN_p1c1ver    #if color is match, go to check_JUMP

                #else player entered invalid value
                 #print message
                la $a0, reEnter
                li $v0,4
                syscall
                 #ask player to re-enter value
                j askfor_r1c1r2c2_IN_p1c1ver      

r1c1_isWhite_IN_p1c1ver:
                beq $t0,1, check_JUMP_IN_p1c1ver   #if color is match, go to check_JUMP
                #else player entered invalid value
                 #print message
                la $a0, reEnter
                li $v0,4
                syscall
                 #ask player to re-enter value
                j askfor_r1c1r2c2_IN_p1c1ver     

#CALL FUNCT isValidJump 
        #int isValidJump ( int *board,int r1, int c1,int r2,int c2)
check_JUMP_IN_p1c1ver:
        addi $sp, $sp, -40              #allocate space for 5 parameters
        sw $a1, 0($sp)
        sw $t1, 4($sp)
        sw $t2, 8($sp)
        sw $t3, 12($sp)
        sw $t4, 16($sp)
        sw $t0, 20($sp)
        sw $s1, 24($sp)
        sw $s2, 28 ($sp)
        sw $s3, 32 ($sp)
        sw $ra, 36 ($sp)
        jal isValidJump
        #load back all value from memory
        lw $a1, 0($sp)
        lw $t1, 4($sp)
        lw $t2, 8($sp)
        lw $t3, 12($sp)
        lw $t4, 16($sp)
        lw $t0, 20($sp)
        lw $s1, 24($sp)
        lw $s2, 28 ($sp)
        lw $s3, 32 ($sp)
        lw $ra, 36 ($sp)
        addi $sp,$sp,40 #deallocate

#t9 hold return value (temp)
        move $t9,$v0   
 
        #if return invalid, jump to check_MOVE
        bne $t9,1,check_MOVE_IN_p1c1ver

        #else return valid, then

                #update current of the total checkers
                beqz $t0, ValidJUMP_delete_WHITE_IN_p1c1ver       
ValidJUMP_delete_RED_IN_p1c1ver: # white piece EATs red piece
                sub $s1,$s1, 1         #currentRED-=1;
                j CalculateRmCm_IN_p1c1ver
ValidJUMP_delete_WHITE_IN_p1c1ver:# red piece EATs white piece
                sub $s2,$s2, 1         #currentWHITE-=1;

CalculateRmCm_IN_p1c1ver:
                #calculate (rm,cm) 
#t7 hold value 2 (temp)
                li $t7,2                #set t7=2
#t8 hold rm (temp)
                add $t8, $t1, $t3       #t8=r1+r2
                div $t8, $t7            #t8=t8/2
                mflo $t8                #save quotient to t8

#t9 hold cm (temp)
                add $t9, $t2, $t4       #t9=c1+c2
                div $t9, $t7              #t9=t9/2
                mflo $t9                #save quotient to t8
#t8 hold (rm,cm) location
                mul $t8,$t8,8           #t8= rm*8
                add $t8,$t8,$t9         #t8=t8+ cm
                mul $t8,$t8,4           #t8=t8* 4-bit
                add $t8,$t8,$a1         #t8=t8+ board address
           
                #locate (rm,cm) and remove game piece (set to 0)
                sw $zero, 0($t8)        #(rm,cm)=0
                #then, move (r1,c1) -> (r2,c2)
                j mover1c1_2r2c2_IN_p1c1ver

#CALL FUNCT isValidMove 
        #int isValidMove ( int *board,int r1, int c1,int r2,int c2)
check_MOVE_IN_p1c1ver:

        addi $sp, $sp, -40              #allocate space for 5 parameters
        sw $a1, 0($sp)
        sw $t1, 4($sp)
        sw $t2, 8($sp)
        sw $t3, 12($sp)
        sw $t4, 16($sp)
        sw $t0, 20($sp)
        sw $s1, 24($sp)
        sw $s2, 28 ($sp)
        sw $s3, 32 ($sp)
        sw $ra, 36($sp)
        jal isValidMove
        # load back all value from memory
        lw $a1, 0($sp)
        lw $t1, 4($sp)
        lw $t2, 8($sp)
        lw $t3, 12($sp)
        lw $t4, 16($sp)
        lw $t0, 20($sp)
        lw $s1, 24($sp)
        lw $s2, 28 ($sp)
        lw $s3, 32 ($sp)
        lw $ra, 36 ($sp)
        addi $sp,$sp, 40        #deallocate
#t9 hold return value (temp)
        move $t9,$v0 

        #if return valid 
        beq $t9, 1, mover1c1_2r2c2_IN_p1c1ver 

        #else player entered invalid value
                #print message
                la $a0, reEnter
                li $v0,4
                syscall
                 #ask player to re-enter value
                j askfor_r1c1r2c2_IN_p1c1ver 


#################################################################
############  COMPUTER PLAY PART

compGENERATE_IN_p1c1ver:
#a2 store ValidJump list address/ ValidMove list address
#a3 player color's choice  
#s3 hold STATE
#t9 hold computer's color 
#t1->t4 hold r1,c1,r2,c2 for computer
#t5,t6,t7,t8  temp reg
        

#GENERATE random number by calling int generateRANDOM (int userInput_RandNUM)
#s3 hold STATE
#t5 hold return randnum value (temp)

        addi $sp, $sp, -28
        sw $s3,0($sp)
        sw $a1, 4($sp)
        sw $t9, 8($sp)
        sw $t0, 12($sp)
        sw $s1, 16($sp)
        sw $s2, 20($sp)
        sw $ra, 24 ($sp)
        jal generateRANDOM  #call funct
        
        #load back value
        lw $s3,0($sp)  # --> NEW STATE will be store back for later computer's turn 
        lw $a1, 4($sp)
        lw $t9, 8($sp)
        lw $t0, 12($sp)
        lw $s1, 16($sp)
        lw $s2, 20($sp)
        lw $ra, 24($sp)
        #store back new randnum (return value) to t5
#t5 hold return randnum value (temp)
        move $t5,$v0
        addi $sp,$sp, 28 #deallocate

#COMPARE player's color (t0) to get computer's color (t9)
        beqz $a3, comp_isWhite_IN_p1c1ver #player is red, so comp is white

com_isRed_IN_p1c1ver:
        li $t9,0        #player is white, so comp is red
        j create_jumpList_IN_p1c1ver
comp_isWhite_IN_p1c1ver:
        li $t9,1

create_jumpList_IN_p1c1ver:

 #CREATE ValidJump List [48][4]
        li $a2,0        #reset a2 address
        addi $sp,$sp, -768      # create arr[48][4] 
        add $a2,$a2,$sp         #save arr[][] address to a2

        #CALL getValidJump (board,validJump,color)
                addi $sp,$sp,-36
                sw $a1, 0($sp)
                sw $a2, 4($sp)
                sw $t9, 8($sp)
                sw $t0, 12($sp)
                sw $s1, 16($sp)
                sw $s2, 20($sp)  
                sw $s3, 24($sp)  #store state
                sw $t5, 28($sp)  #store randnum
                sw $ra, 32($sp)
                jal getValidJumps #call funct

                #load back original value
                lw $a1, 0($sp)
                lw $a2, 4($sp)
                lw $t9, 8($sp)
                lw $t0, 12($sp)
                lw $s1, 16($sp)
                lw $s2, 20($sp)
                lw $s3, 24($sp)
                lw $t5, 28($sp)  
                lw $ra, 32 ($sp)
                #store return value (total element in validJump list) into t8

#t8 hold total element inside validJump list (temp)
                move $t8,$v0

                #deallocate
                addi $sp,$sp,36

        #CHECK total of validJump list
                #if total=0, then there is no possible jump for computer
                  #so jump to create validMove list
                beqz $t8, create_moveList_IN_p1c1ver

                #else 
#GET Valid jump (r1,c1,r2,c2) for computer
        #CHECK and REDUCE randnum
#t5 hold randnum value (temp)
        rem $t5,$t5,$t8  # take remainder of (randnum/total jumps)
               
                     
        #FIND rand-location in JumpList
#t7 hold rand-address (temp)
                mul $t7,$t5, 4    #t7=  rand-pos * 4
                mul $t7, $t7, 4   #t7= rand-position * 4-bit
                add $t7,$t7,$a2   #t7+= JumpList address (a2)

        #GET r1,c1,r2,c2 from JumpList
        lw $t1, 0($t7)
        lw $t2, 4($t7)
        lw $t3, 8($t7)
        lw $t4, 12($t7)         

        #REMOVE (rm,cm)
                #calculate (rm,cm) 
#t7 hold value 2 (temp)
                li $t7,2                #set t7=2
#t5 hold rm (temp)
                li $t5 ,0               #reset t5=0
                add $t5, $t1, $t3       #t5=r1+r2
                div $t5, $t7            #t5=t5/2
                mflo $t5                #save quotient to t5

#t6 hold cm (temp)
                add $t6, $t2, $t4       #t6=c1+c2
                div $t6, $t7              #t6=t6/2
                mflo $t6                #save quotient to t6

#t5 hold (rm,cm) location

                mul $t5,$t5,8           #t5= rm*8
                add $t5,$t5,$t6         #t5=t5+ cm
                mul $t5,$t5,4           #t5=t5* 4-bit
                add $t5,$t5,$a1         #t5=t5+ board address
#t7 hold value 0 (temp)
                li $t7,0
                #locate (rm,cm) and remove game piece (set to 0)
                sw $t7, 0($t5)        #(rm,cm)=0
        #REDUCE TOTAL CHECKER of COMPUTER
#t9 hold comp's color
                beq $t9,0, comp_minusWhite_IN_p1c1ver
comp_minusRed_IN_p1c1ver:
                addi $s1,$s1,-1
                j comp_moveCheckers_IN_p1c1ver
comp_minusWhite_IN_p1c1ver: 
                addi $s2,$s2,-1 # total white--;
                #if color is white
        #JUMP to move (r1,c1) to  (r2,c2)
comp_moveCheckers_IN_p1c1ver:
        j mover1c1_2r2c2_IN_p1c1ver
################################
create_moveList_IN_p1c1ver:
        #deallocate jumpList before create movelist
        addi $sp,$sp, -768

        li $a2,0 #reset a2 address

        # Create a validMove[48][4]
        addi $sp,$sp, -768 # create arr[48][4] 
        add $a2,$a2,$sp         #save arr[][] address to a2

#CALL getValidMove(board,validMove,color)
                addi $sp,$sp,-36
                sw $a1, 0($sp)
                sw $a2, 4($sp)
                sw $t9, 8($sp)
                sw $t0, 12($sp)
                sw $s1, 16($sp)
                sw $s2, 20($sp)
                sw $s3, 24($sp) #store STATE
                sw $t5, 28($sp) #store randnum
                sw $ra, 32($sp)
                jal getValidMoves #call funct

                #load back original value
                lw $a1, 0($sp)
                lw $a2, 4($sp)
                lw $t9, 8($sp)
                lw $t0, 12($sp)
                lw $s1, 16($sp)
                lw $s2, 20($sp)
                lw $s3, 24($sp)
                lw $t5, 28 ($sp)
                lw $ra, 32($sp)
                #store return value (total element in validMove list) into t8

#t8 hold total element inside validMove list (temp)
                move $t8,$v0

                #deallocate
                addi $sp,$sp,36


        #CHECK total of validMove list
                #if total!=0, then there is  possible moves for computer
                  #so jump to getMOVES
                bnez $t8, getMOVES_IN_p1c1ver

                #else, none possible moves, computer can't jump or move
######################
#COMPUTER CANT JUMP OR MOVE SITUATION:
                #print line "COMPUTER cant go any futher :( "
                la $a0, computerNOgo_IN_p1c1ver
                li $v0,4
                syscall
                #reset computer checkers to 0 to stop the game and print out winners

                beqz $t9, setTotal_red2zero_IN_p1c1ver
setTotal_white2zero_IN_p1c1ver:                
                li $s2,0        #computer is white, set its checkers to 0 (s2=0)
                j player_win_IN_p1c1ver    #then claim player win
setTotal_red2zero_IN_p1c1ver:
                li $s1,0        #computer is red, set its checkers to 0 (s1=0)
                j player_win_IN_p1c1ver    #then claim player win
#########################
getMOVES_IN_p1c1ver:
#GET Valid move (r1,c1,r2,c2) for computer

        #CHECK and REDUCE randnum
#t5 hold randnum value (temp)
         rem $t5,$t5,$t8  # take remainder of (randnum/total jumps)

        #FIND rand-location in MoveList
#t7 hold rand-address (temp)
                mul $t7,$t5,4     #t7= rand-position * 4
                mul $t7, $t7, 4   #t7= rand-position * 4-bit
                add $t7,$t7,$a2   #t7+= JumpList address (a2)

        li $t5,0 #reset t5=0

        #GET r1,c1,r2,c2 from MoveList
        lw $t1, 0($t7)
        lw $t2, 4($t7)
        lw $t3, 8($t7)
        lw $t4, 12($t7)         

        #JUMP to move (r1,c1) to  (r2,c2)
        j mover1c1_2r2c2_IN_p1c1ver


        #deallocate moveList 
        addi $sp,$sp, -768
########################################################
#MOVE (r1,c1) -> (r2,c2)
mover1c1_2r2c2_IN_p1c1ver:  
#t8 hold (r1,c1) address (temp)
#t9 hold value in (r1,c1) (temp)

        #locate (r1,c1)
        li $t8,0                #reset t8
        mul $t8, $t1,8          #t8=r1*8
        add $t8,$t8,$t2         #t8=t8+c1
        mul $t8,$t8,4           #t8=t8*4-bit
        add $t8,$t8,$a1         #t8=t8+ board address

        #save value in (r1,c1) to t9
        lw $t9, 0($t8)

       
        #remove (r1,c1) game piece (set to 0)
        li $t7,0
        sw $t7, 0($t8)

#t8 hold (r2,c2) address (temp)
        #locate (r2,c2)
        li $t8,0                #t8=0
        mul $t8, $t3,8          #t8=r2*8
        add $t8,$t8,$t4         #t8=t8+c2
        mul $t8,$t8,4           #t8=t8*4-bit
        add $t8,$t8,$a1         #t8=t8+ board address

        #change value of (r2,c2) => value of (r2,c2)=(r1,c1)=t9
        sw $t9, 0($t8)

#CONVERT TO KING CHECK

        bnez $t0, KING_WHITEcheck_IN_p1c1ver      #if current player is white, (t0=1 !=0),
                                        #jump to check if needed to turn WHITE KING

KING_REDcheck_IN_p1c1ver:#else, current player is red, check if needed to turn to RED KING

        # if (r2!=7), jump to change color
        bne $t3, 7, changeCOLOR_IN_p1c1ver
        # set t9 hold value 5 (RED KING)
        li $t9, 5
        # jump to Convert2KING
        j Convert2KING_IN_p1c1ver
        
KING_WHITEcheck_IN_p1c1ver:
        #if (r2!=0), jump to do_loop
        bnez $t3, changeCOLOR_IN_p1c1ver
         # set t9 hold value 7 (WHITE KING)
        li $t9, 7
        # jump to Convert2KING
       
Convert2KING_IN_p1c1ver:
#t8 still hold (r2,c2) address from above (temp)
#t9 hold KING value that will be saved into (r2,c2)
        #change color value of (r2,c2)

        sw $t9,0($t8)

#CHANGE CURRENT COLOR
        #if current color is !=0, jump to SETcolor_to0
changeCOLOR_IN_p1c1ver:     
        beq $t0,1, SETcolor_to0_IN_p1c1ver

SETcolor_to1_IN_p1c1ver:
        li $t0,1
        j while_check_IN_p1c1ver

SETcolor_to0_IN_p1c1ver:
        li $t0,0

while_check_IN_p1c1ver:
# if (red_total==0) || (white_total==0) then jump to declareWINNER
        beqz $s1,declareWINNER_IN_p1c1ver    
        beqz $s2,declareWINNER_IN_p1c1ver     
        j do_loop_IN_p1c1ver

declareWINNER_IN_p1c1ver:
#PRINT OUT RESULT:
        #check which color is out of checkers
        beqz $s1,red_equal0_IN_p1c1ver  
        beqz $s2,white_equal0_IN_p1c1ver

        #check who win
                #if color checker=0 = player's color, then computer win
red_equal0_IN_p1c1ver:
        beqz $a3, compWIN_IN_p1c1ver
white_equal0:
        beq $a3,1, compWIN_IN_p1c1ver

                #else player win!
player_win_IN_p1c1ver:
        la $a0, player1win
        li $v0,4
        syscall
        j jumpback_IN_p1c1ver

comp_win_IN_p1c1ver:
        la $a0, c1WIN
        li $v0,4
        syscall
jumpback_IN_p1c1ver:
        jr $ra

#########################################################################################
#######################################################################################
c1VSc2VER:
# void c1VSc2VER (board*)
#a1 (global) hold board address
#a2 hold Jump/Move List address
#a3 hold player's choice of color for C1
#s1-s2 hold total red/white checkers
#s3 hold STATE
#t0 hold current color, at begining will hold c1 color since c1 go first
#t1->t4 hold r1,c1,r2,c2 input


#ASK USER a random number to set the initial state 
        la $a0, askLuckyNum
        li $v0, 4
        syscall

        li $v0,5
        syscall
        move $v0,$s3  #save rand num to s3

#ASK USER to choose color
        la $a0,c1_chooseColor
        li $v0,4
        syscall 
        li $v0,5 #read-in value
        syscall
        move $a3,$v0    #save user's choice of color for c1->a3

        beq $a3,1,c2isred
c2iswhite:
        la $a0,c2WHITE
        li $v0,4
        syscall
        j print_border
c2isred:
        la $a0,c2RED
        li $v0,4
        syscall

print_border:
        li $t0,0
        add $t0,$t0,$a3 #set current color to c1's color

        #Print border
        la $a0,star 
        li $v0,4
        syscall

        
do_loop_IN_c1c2ver:

#DISPLAY BOARD
display_IN_c1c2ver:

        addi $sp, $sp, -24       #allocate
        sw $a1, 0($sp)          #store board address to memory
        sw $t0, 4($sp)
        sw $s1, 8($sp)
        sw $s2, 12($sp)
        sw $s3, 16($sp)
        sw $ra, 20($sp)

        jal Print_Out
         #load back t0,s1,s2 original value from memory
        lw $a1, 0($sp)
        lw $t0, 4($sp)
        lw $s1, 8($sp)
        lw $s2, 12($sp)
        lw $s3, 16($sp)
        lw $ra, 20 ($sp)
        addi $sp, $sp, 24        #deallocate

#print current total checkers on both color:
        la $a0, totalRed
        li $v0,4
        syscall
        move $a0,$s1
        li $v0,1
        syscall

        la $a0, totalWhite
        li $v0,4
        syscall
        move $a0,$s2
        li $v0,1
        syscall
        la $a0,newline
        li $v0,4
        syscall

        #print which player's turn
        beq $t0,$a3,c1turn
c2turn:
        la $a0, print_c2turn
        li $v0,4
        syscall
        j printcolor
c1turn:
        la $a0, print_c1turn
        li $v0,4
        syscall

printcolor:
        beqz $t0,currisRED

currisWHITE:
        la $a0,print_currWHITE
        li $v0,4
        syscall
        j compGENERATE_IN_c1c2ver
currisRED:
        la $a0,print_currRED
        li $v0,4
        syscall

compGENERATE_IN_c1c2ver:
#a2 store ValidJump list address/ ValidMove list address
#a3 player color's choice  
#s3 hold STATE
#t9 hold computer's color 
#t1->t4 hold r1,c1,r2,c2 for computer
#t5,t6,t7,t8  temp reg
        

#GENERATE random number by calling int generateRANDOM (int userInput_RandNUM)
#s3 hold STATE
#t5 hold return randnum value (temp)

        addi $sp, $sp, -28
        sw $s3,0($sp)
        sw $a1, 4($sp)
        sw $t9, 8($sp)
        sw $t0, 12($sp)
        sw $s1, 16($sp)
        sw $s2, 20($sp)
        sw $ra, 24 ($sp)
        jal generateRANDOM  #call funct
        
        #load back value
        lw $s3,0($sp)  # --> NEW STATE will be store back for later computer's turn 
        lw $a1, 4($sp)
        lw $t9, 8($sp)
        lw $t0, 12($sp)
        lw $s1, 16($sp)
        lw $s2, 20($sp)
        lw $ra, 24($sp)
        #store back new randnum (return value) to t5
#t5 hold return randnum value (temp)
        move $t5,$v0
        addi $sp,$sp, 28 #deallocate

#COMPARE t0 to get computer's color (t9)
        bnez $t0, comp_isWhite_IN_c1c2ver 

com_isRed_IN_c1c2ver:
        li $t9,0       
        j create_jumpList_IN_c1c2ver
comp_isWhite_IN_c1c2ver:
        li $t9,1

create_jumpList_IN_c1c2ver:

 #CREATE ValidJump List [48][4]
        li $a2,0        #reset a2 address
        addi $sp,$sp, -768      # create arr[48][4] 
        add $a2,$a2,$sp         #save arr[][] address to a2

        #CALL getValidJump (board,validJump,color)
                addi $sp,$sp,-36
                sw $a1, 0($sp)
                sw $a2, 4($sp)
                sw $t9, 8($sp)
                sw $t0, 12($sp)
                sw $s1, 16($sp)
                sw $s2, 20($sp)  
                sw $s3, 24($sp)  #store state
                sw $t5, 28($sp)  #store randnum
                sw $ra, 32($sp)
                jal getValidJumps #call funct

                #load back original value
                lw $a1, 0($sp)
                lw $a2, 4($sp)
                lw $t9, 8($sp)
                lw $t0, 12($sp)
                lw $s1, 16($sp)
                lw $s2, 20($sp)
                lw $s3, 24($sp)
                lw $t5, 28($sp)  
                lw $ra, 32 ($sp)
                #store return value (total element in validJump list) into t8

#t8 hold total element inside validJump list (temp)
                move $t8,$v0

                #deallocate
                addi $sp,$sp,36

        #CHECK total of validJump list
                #if total=0, then there is no possible jump for computer
                  #so jump to create validMove list
                beqz $t8, create_moveList_IN_c1c2ver

                #else 
#GET Valid jump (r1,c1,r2,c2) for computer
        #CHECK and REDUCE randnum
#t5 hold randnum value (temp)
        rem $t5,$t5,$t8  # take remainder of (randnum/total jumps)
               
                     
        #FIND rand-location in JumpList
#t7 hold rand-address (temp)
                mul $t7,$t5, 4    #t7=  rand-pos * 4
                mul $t7, $t7, 4   #t7= rand-position * 4-bit
                add $t7,$t7,$a2   #t7+= JumpList address (a2)

        #GET r1,c1,r2,c2 from JumpList
        lw $t1, 0($t7)
        lw $t2, 4($t7)
        lw $t3, 8($t7)
        lw $t4, 12($t7)         

        #REMOVE (rm,cm)
                #calculate (rm,cm) 
#t7 hold value 2 (temp)
                li $t7,2                #set t7=2
#t5 hold rm (temp)
                li $t5 ,0               #reset t5=0
                add $t5, $t1, $t3       #t5=r1+r2
                div $t5, $t7            #t5=t5/2
                mflo $t5                #save quotient to t5

#t6 hold cm (temp)
                add $t6, $t2, $t4       #t6=c1+c2
                div $t6, $t7              #t6=t6/2
                mflo $t6                #save quotient to t6

#t5 hold (rm,cm) location

                mul $t5,$t5,8           #t5= rm*8
                add $t5,$t5,$t6         #t5=t5+ cm
                mul $t5,$t5,4           #t5=t5* 4-bit
                add $t5,$t5,$a1         #t5=t5+ board address
#t7 hold value 0 (temp)
                li $t7,0
                #locate (rm,cm) and remove game piece (set to 0)
                sw $t7, 0($t5)        #(rm,cm)=0
        #REDUCE TOTAL CHECKER of COMPUTER
#t9 hold comp's color
                beq $t9,0, comp_minusWhite_IN_c1c2ver
comp_minusRed_IN_c1c2ver:
                addi $s1,$s1,-1
                j comp_moveCheckers_IN_c1c2ver
comp_minusWhite_IN_c1c2ver: 
                addi $s2,$s2,-1 # total white--;
                #if color is white
        #JUMP to move (r1,c1) to  (r2,c2)
comp_moveCheckers_IN_c1c2ver:
        j mover1c1_2r2c2_IN_c1c2ver
################################
create_moveList_IN_c1c2ver:
        #deallocate jumpList before create movelist
        addi $sp,$sp, -768

        li $a2,0 #reset a2 address

        # Create a validMove[48][4]
        addi $sp,$sp, -768 # create arr[48][4] 
        add $a2,$a2,$sp         #save arr[][] address to a2

#CALL getValidMove(board,validMove,color)
                addi $sp,$sp,-36
                sw $a1, 0($sp)
                sw $a2, 4($sp)
                sw $t9, 8($sp)
                sw $t0, 12($sp)
                sw $s1, 16($sp)
                sw $s2, 20($sp)
                sw $s3, 24($sp) #store STATE
                sw $t5, 28($sp) #store randnum
                sw $ra, 32($sp)
                jal getValidMoves #call funct

                #load back original value
                lw $a1, 0($sp)
                lw $a2, 4($sp)
                lw $t9, 8($sp)
                lw $t0, 12($sp)
                lw $s1, 16($sp)
                lw $s2, 20($sp)
                lw $s3, 24($sp)
                lw $t5, 28 ($sp)
                lw $ra, 32($sp)
                #store return value (total element in validMove list) into t8

#t8 hold total element inside validMove list (temp)
                move $t8,$v0

                #deallocate
                addi $sp,$sp,36


        #CHECK total of validMove list
                #if total!=0, then there is  possible moves for computer
                  #so jump to getMOVES
                bnez $t8, getMOVES_IN_c1c2ver

                #else, none possible moves, computer can't jump or move
######################
#COMPUTER CANT JUMP OR MOVE SITUATION:
                la $a0, cantMOVE
                li $v0,4
                syscall
                #reset computer checkers to 0 to stop the game and print out winners

                beqz $t9, setTotal_red2zero_IN_c1c2ver
setTotal_white2zero_IN_c1c2ver:                
                li $s2,0        #computer is white, set its checkers to 0 (s2=0)
                j declareWINNER_IN_c1c2ver   #then claim player win
setTotal_red2zero_IN_c1c2ver:
                li $s1,0        #computer is red, set its checkers to 0 (s1=0)
                j declareWINNER_IN_c1c2ver    #then claim player win
#########################
getMOVES_IN_c1c2ver:
#GET Valid move (r1,c1,r2,c2) for computer

        #CHECK and REDUCE randnum
#t5 hold randnum value (temp)
         rem $t5,$t5,$t8  # take remainder of (randnum/total jumps)

        #FIND rand-location in MoveList
#t7 hold rand-address (temp)
                mul $t7,$t5,4     #t7= rand-position * 4
                mul $t7, $t7, 4   #t7= rand-position * 4-bit
                add $t7,$t7,$a2   #t7+= JumpList address (a2)

        li $t5,0 #reset t5=0

        #GET r1,c1,r2,c2 from MoveList
        lw $t1, 0($t7)
        lw $t2, 4($t7)
        lw $t3, 8($t7)
        lw $t4, 12($t7)         

        #JUMP to move (r1,c1) to  (r2,c2)
        j mover1c1_2r2c2_IN_c1c2ver


        #deallocate moveList 
        addi $sp,$sp, -768
########################################################
#MOVE (r1,c1) -> (r2,c2)
mover1c1_2r2c2_IN_c1c2ver:  
#t8 hold (r1,c1) address (temp)
#t9 hold value in (r1,c1) (temp)

        #locate (r1,c1)
        li $t8,0                #reset t8
        mul $t8, $t1,8          #t8=r1*8
        add $t8,$t8,$t2         #t8=t8+c1
        mul $t8,$t8,4           #t8=t8*4-bit
        add $t8,$t8,$a1         #t8=t8+ board address

        #save value in (r1,c1) to t9
        lw $t9, 0($t8)

       
        #remove (r1,c1) game piece (set to 0)
        li $t7,0
        sw $t7, 0($t8)

#t8 hold (r2,c2) address (temp)
        #locate (r2,c2)
        li $t8,0                #t8=0
        mul $t8, $t3,8          #t8=r2*8
        add $t8,$t8,$t4         #t8=t8+c2
        mul $t8,$t8,4           #t8=t8*4-bit
        add $t8,$t8,$a1         #t8=t8+ board address

        #change value of (r2,c2) => value of (r2,c2)=(r1,c1)=t9
        sw $t9, 0($t8)

#CONVERT TO KING CHECK

        bnez $t0, KING_WHITEcheck_IN_c1c2ver      #if current player is white, (t0=1 !=0),
                                        #jump to check if needed to turn WHITE KING

KING_REDcheck_IN_c1c2ver:#else, current player is red, check if needed to turn to RED KING

        # if (r2!=7), jump to change color
        bne $t3, 7, changeCOLOR_IN_c1c2ver
        # set t9 hold value 5 (RED KING)
        li $t9, 5
        # jump to Convert2KING
        j Convert2KING_IN_c1c2ver
        
KING_WHITEcheck_IN_c1c2ver:
        #if (r2!=0), jump to do_loop
        bnez $t3, changeCOLOR_IN_c1c2ver
         # set t9 hold value 7 (WHITE KING)
        li $t9, 7
        # jump to Convert2KING
       
Convert2KING_IN_c1c2ver:
#t8 still hold (r2,c2) address from above (temp)
#t9 hold KING value that will be saved into (r2,c2)
        #change color value of (r2,c2)

        sw $t9,0($t8)

#CHANGE CURRENT COLOR
        #if current color is !=0, jump to SETcolor_to0
changeCOLOR_IN_c1c2ver:     
        beq $t0,1, SETcolor_to0_IN_c1c2ver

SETcolor_to1__IN_c1c2ver:
        li $t0,1
        j while_check_IN_c1c2ver

SETcolor_to0_IN_c1c2ver:
        li $t0,0

while_check_IN_c1c2ver:
# if (red_total==0) || (white_total==0) then jump to declareWINNER
        beqz $s1,declareWINNER_IN_c1c2ver  
        beqz $s2,declareWINNER_IN_c1c2ver   
        j do_loop_IN_c1c2ver

declareWINNER_IN_c1c2ver:
    #if current color = user's choice of color for c1
        #then c1 lose
        beq $t0,$a3, computer2win

computer1win:
        la $a0, c1WIN
        li $v0,4
        syscall
        j jumpback_IN_c1c2ver
computer2win:
        la $a0,c2WIN
        li $v0,4
        syscall

jumpback_IN_c1c2ver:
        jr $ra
	
 ################# HAO LAM's PROJECT - END #########################

