.data
#arrays
map:    .asciiz "I.IIIIIIIIIIIIIIIIIII\nI....I....I.......I.I\nIII.IIIII.I.I.III.I.I\nI.I.....I..I..I.....I\nI.I.III.II...II.I.III\nI...I...III.I...I...I\nIIIII.IIIII.III.III.I\nI.............I.I...I\nIIIIIIIIIIIIIII.I.III\n@...............I..II\nIIIIIIIIIIIIIIIIIIIII\n"
	    .space 243
	    .align 0

temp:   .space 100
        .align 0
	  
button: 
.space 1
.align 0

#messages
msg1:
.asciiz "Labyrinth:\n"

msg2:
.asciiz "Make your move:"

msg3:
.asciiz "Invalid choice.Game over...\n"

msg4:
.asciiz "Winner Winner Chicken Dinner!!!\n"

msg5:
.asciiz "You hit the wall.Game over...\n"

newline:
.asciiz "\n"


.text
###########################################MAIN###########################################################
.globl __start            #variable start
__start:  
li           $s0,22       #W=22
li           $s1,11       #H=11
li           $s2,1        #StartX=1
li           $s3,242      #TotalElements=242
li           $s4,1        #PlayerPos=1     
li           $s5,46       #$s5='.'
li           $s6,30000

jal          movePlayer 

li           $v0,10       #exits the program
syscall
############################################USLEEP########################################################
usleep:
li           $t8,0        #x=0
for_label:

bge          $t8,$s6,after_for

addi         $t8,$t8,1    #x++

j for_label

after_for:
jr $ra

############################################function 1####################################################
printLabyrinth:
addi         $sp,$sp,-36  #allocates 32 bytes in memory for the registers stored in stack (4 bytes for each one)
sw           $t0,0($sp)   #$t0 is saved in the first position of stack
sw           $t1,4($sp)   #$t1 is saved in the second position of stack
sw           $t2,8($sp)   #$t2 is saved in the third position of stack
sw           $t3,12($sp)  #$t3 is saved in the forth position of stack
sw           $t4,16($sp)  #$t4 is saved in the fifth position of stack
sw           $t5,20($sp)  #$t5 is saved in the sixth position of stack
sw           $t6,24($sp)  #$t6 is saved in the seventh position of stack
sw           $a0,28($sp)  #$a0 is saved in the eighth position of stack

li           $t0,0        #i
li 	   	     $t1,0        #j
li           $t2,0        #k

#USLEEP
sw           $ra,32($sp)
jal          usleep
lw           $ra,32($sp)

li           $v0,4
la           $a0,msg1
syscall

for1:
bge          $t0,$s1,endFor1
li           $t1,0

for2:
bge          $t1,$s0,endFor2
bne          $t2,$s4,elseLabel1 

la           $t3,temp     #$t3=&temp
add          $t4,$t3,$t1  #$t4=&temp[j]
li           $t5,80		  #t5= 'P'
sb           $t5,0($t4)   #temp[j]='P'

j label1

elseLabel1:
la           $t3,temp     #$t3=&temp
add          $t4,$t3,$t1  #$t4=&temp[j]
la           $t5,map      #$t5,&map
add          $t6,$t5,$t2  #$t6=&map[k]
lb           $t7,0($t6)   #t7=map[k]
sb           $t7,0($t4)   #temp[j]=map[k]

label1:
addi         $t2,$t2,1    #k++
addi         $t1,$t1,1    #j++

j for2

endFor2:
la           $t3,temp     #$t3=&temp
add          $t4,$t3,$t1  #$t4=&temp[j]
addi         $t4,$t4,1    #$t4=&temp[j+1]
sb           $zero,0($t4) #temp[j+1]= '\0'

#prints temp
li           $v0,4
la           $a0,temp     
syscall          

addi         $t0,$t0,1    #i++

j for1

endFor1:
li           $v0,4
la           $a0,newline
syscall

lw           $t0,0($sp)   #reinitiliaze $t0
lw           $t1,4($sp)   #reinitiliaze $t1
lw           $t2,8($sp)   #reinitiliaze $t2
lw           $t3,12($sp)  #reinitiliaze $t3
lw           $t4,16($sp)  #reinitiliaze $t4
lw           $t5,20($sp)  #reinitiliaze $t5
lw           $t6,24($sp)  #reinitiliaze $t6
lw           $a0,28($sp)  #reinitiliaze $a0
addi         $sp,$sp,36   #frees the space allocated in stack previously

jr           $ra 
#######################################################################################################

#################################################function 2############################################
movePlayer:
addi         $sp,$sp,-4   #allocates 4 bytes in memory for the registers stored in stack (4 bytes for each one)
 
sw           $ra,0($sp)   #before calling a new function we must store the $ra in stack so as to get the right address each time
jal          printLabyrinth
lw           $ra,0($sp)   #after calling a new  function we reinitialize $ra to its previous value 

li           $t2,1        #idx=1
move         $s4,$t2      #PlayerPos=idx

slt          $t0,$t2,$zero#$t0=if(idx<0)        
slt          $t1,$s3,$t2  #$t1=if(TotalElements>=242)
or           $t3,$t0,$t1  #$t3=if((idx<0) || (idx>=242))
li           $t4,1

bne          $t3,$t4,while_label #if ((idx<0) || (idx>=242))!=1 -> if !((idx<0) || (TotalElements>=242)) goto  while_label
jr           $ra

while_label:
la           $t0,map      #$t0=&map
add          $t1,$t0,$s4  #$t1=&map[PlayerPos]
lb           $t2,0($t1)   #$t2=map[Playerpos]

bne          $t2,$s5,after_while #if (map[Playerpos]!= '.' goto after_while
   
li           $v0,4
la           $a0,msg2
syscall

#reads button from user
li          $v0,8
la          $a0,button
syscall

move        $t4,$a0       #$t4=&button
lb          $t5,0($t4)    #$t5=button
li          $t0,68        #$t0='D'

bne         $t5,$t0,else1 
addi        $s4,$s4,1     #PlayerPos=PlayerPos+1

j if_label

else1:
li          $t0,83        #$t0='S'
bne         $t5,$t0,else2
add         $s4,$s4,$s0   #PlayerPos=PlayerPos+W

j if_label
   
else2:
li          $t0,65        #$t0='A'
bne         $t5,$t0,else3
addi        $s4,$s4,-1    #PlayerPos=PlayerPos-1

j if_label
        
else3:
li          $t0,87        #$t0='W'
bne         $t5,$t0,else4
sub         $s4,$s4,$s0   #PlayerPos=PlayerPos+W

j if_label
        
else4:
li          $t0,69        #$t0='E'
bne         $t5,$t0,else5

li          $a0,1         #$a0=1 because the argument of makeMove will be initially 1(makeMove(startX=1)
sw          $ra,0($sp)    #before calling a new function we must store the $ra in stack so as to get the right address each time
jal         makeMove      #calls makeMove (makeMove(startX);)
lw          $ra,0($sp)    #after calling a new  function we reinitialize $ra to its previous value 

j if_label
        
else5:
li          $v0,4
la          $a0,msg3
syscall

jr          $ra        
        
if_label:
la          $t0,map
add         $t1,$t0,$s4
lb          $t2,0($t1)    #$t2=map[playerpos]
li          $t3,73        #t3='I'
beq         $t2,$t3,end_if

sw          $ra,0($sp)    #before calling a new function we must store the $ra in stack so as to get the right address each time
jal         printLabyrinth
lw          $ra,0($sp)    #after calling a new  function we reinitialize $ra to its previous value 

end_if:
j while_label

after_while:
la          $t0,map       #$t0=&map
add         $t1,$t0,$s4   #$t1=&map[PlayerPos]
lb          $t2,0($t1)    #$t2=map[PlayerPos]
li          $t3,64        #$t3='@'

bne         $t2,$t3,else6 #if(map[PlayerPos]!='@' goto else6

li          $v0,4
la          $a0,msg4
syscall

jr          $ra

else6:
la          $t0,map       #$t0=&map
add         $t1,$t0,$s4   #$t1=&map[PlayerPos]
lb          $t2,0($t1)    #$t2=map[PlayerPos]
li          $t3,73        #$t3='I'

bne         $t2,$t3,end_func #if(map[PlayerPos]!='I' goto end_func

li          $v0,4
la          $a0,msg5
syscall
         
end_func:
addi        $sp,$sp,4    #frees the space allocated in stack previously

jr          $ra
########################function 3###########################################################################
makeMove:
addi        $sp,$sp,-8   #allocates 8 bytes in memory for the registers stored in stack (4 bytes for each one)
sw          $t1,4($sp)   #$t1 is stored in the second position of the stack
sw          $ra,0($sp)   #$ra is stored in the first position of the stack

move        $t1,$a0      #moves the argument of makeMove in $t1($t1=index)

slt         $t0,$t1,$zero#$t0=if(idx<0)  
slt         $t2,$s3,$t1  #$t1=if(TotalElements>=242)
or          $t3,$t0,$t2  #$t3=if((idx<0) || (TotalElements>=242))
li          $t4,1

bne         $t3,$t4,end2 #if ((idx<0) || (TotalElements>=242))!=1 -> if !((idx<0) || (TotalElements>=242)) goto end2

jr          $ra
 
end2:
la          $t0,map      #$t0=&map
add         $t2,$t0,$t1  #$t2=&map[index]

lb          $t3,0($t2)   #t3=map[index]
bne         $t3,$s5,elseLabel3 #if(map[index]!='.' goto elseLabel3

li          $t4,42       #$t4='*'
sb          $t4,0($t2)   #map[index]='*'

sw          $ra,0($sp)   #before calling a new function we must store the $ra in stack so as to get the right address each time
jal         printLabyrinth
lw          $ra,0($sp)   #after calling a new  function we reinitialize $ra to its previous value 

addi        $a0,$t1,1    #now the new argument of makeMove will be index+1

sw          $ra,0($sp)   #before calling a new function we must store the $ra in stack so as to get the right address each time
jal         makeMove     #calls makeMove(index+1), (makeMove(index+1);)
lw          $ra,0($sp)   #after calling a new  function we reinitialize $ra to its previous value 

li          $t5,1       
bne         $v0,$t5,if2  #$v0 contains the returning value of makeMove. if($v0!=1) -> if(move(index+1)!=1) goto if2

la          $t2,map      #$t2=&map
add         $t3,$t2,$t1  #$t3=&map[index]
li          $t4,35       #$t4='#'
sb          $t4,0($t3)   #map[index]='#'
 
li          $v0,1        #$v0 takes value 1 so as to return 1
lw          $t1,4($sp)   #reinitializes $t1
addi        $sp,$sp,8    #frees space allocated in stack previously

jr          $ra          

if2:
add         $a0,$t1,$s0  #now the new argument of makeMove will be index + W 

sw          $ra,0($sp)   #before calling a new function we must store the $ra in stack so as to get the right address each time
jal         makeMove     #calls makeMove(index+W), (makeMove(index+W);)
lw          $ra,0($sp)   #after calling a new  function we reinitialize $ra to its previous value 

li          $t5,1
bne         $v0,$t5,if3  #$v0 contains the returning value of makeMove. if($v0!=1) -> if(move(index+W)!=1) goto if3

la          $t2,map      #$t2=&map
add         $t3,$t2,$t1  #$t3=&map[index]
li          $t4,35       #$t4='#'
sb          $t4,0($t3)   #map[index]='#'
 
li          $v0,1        #$v0 takes value 1 so as to return 1
lw          $t1,4($sp)   #reinitializes $t1
addi        $sp,$sp,8    #frees space allocated in stack previously

jr          $ra
    
if3:
addi        $a0,$t1,-1   #now the new argument of makeMove will be index - 1

sw          $ra,0($sp)   #before calling a new function we must store the $ra in stack so as to get the right address each time
jal         makeMove     #calls makeMove(index-1), (makeMove(index-1);)
lw          $ra,0($sp)   #after calling a new  function we reinitialize $ra to its previous value 

li          $t5,1
bne         $v0,$t5,if4  #$v0 contains the returning value of makeMove. if($v0!=1) -> if(move(index-1)!=1) goto if3

la          $t2,map      #$t2=&map
add         $t3,$t2,$t1  #$t3=&map[index]
li          $t4,35       #$t4='#'
sb          $t4,0($t3)   #map[index]='#'
 
li          $v0,1        #$v0 takes value 1 so as to return 1
lw          $t1,4($sp)   #reinitializes $t1
addi        $sp,$sp,8    #frees space allocated in stack previously

jr          $ra
     
if4:
sub         $a0,$t1,$s0  #now the new argument of makeMove will be index - W

sw          $ra,0($sp)   #before calling a new function we must store the $ra in stack so as to get the right address each time
jal         makeMove     #calls makeMove(index-W), (makeMove(index-W);)
lw          $ra,0($sp)   #after calling a new  function we reinitialize $ra to its previous value 

li          $t5,1
bne         $v0,$t5,elseLabel4 #$v0 contains the returning value of makeMove. if($v0!=1) -> if(move(index-W)!=1) goto elseLabel4

la          $t2,map      #$t2=&map
add         $t3,$t2,$t1  #$t3=&map[index]
li          $t4,35       #$t4='#'
sb          $t4,0($t3)   #map[index]='#'
 
li          $v0,1        #$v0 takes value 1 so as to return 1
lw          $t1,4($sp)   #reinitializes $t1
addi        $sp,$sp,8    #frees space allocated in stack previously

jr          $ra
      
elseLabel3:
la          $t2,map      #$t2=&map
add         $t3,$t2,$t1  #$t3=&map[index]
lb          $t5,0($t3)   #$t5=map[index]
li          $t4,64       #$t4='@'

bne         $t5,$t4,elseLabel4 #if(map[index]!='@' goto elseLabel4

li          $t6,37       #$t6='%'
sb          $t6,0($t3)   #map[index]='%'

sw          $ra,0($sp)   #before calling a new function we must store the $ra in stack so as to get the right address each time
jal         printLabyrinth
lw          $ra,0($sp)   #after calling a new  function we reinitialize $ra to its previous value 

li          $v0,1        #$v0 takes value 1 so as to return 1
lw          $t1,4($sp)   #reinitializes $t1
addi        $sp,$sp,8    #frees space allocated in stack previously

jr          $ra
  
elseLabel4:
li          $v0,0        #$v0 takes value 0 so as to return 0
lw          $t1,4($sp)   #reinitializes $t1
addi        $sp,$sp,8    #frees space allocated in stack previously

jr          $ra

####################################################################################################################

