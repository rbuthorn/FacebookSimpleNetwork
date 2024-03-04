############## Robert Buthorn ##############
############## 112628833 #################
############## rbuthorn ################

############################ DO NOT CREATE A .data SECTION ############################
############################ DO NOT CREATE A .data SECTION ############################
############################ DO NOT CREATE A .data SECTION ############################
.text:
.globl create_person
create_person:


move $t0, $a0
lb $t1, 0($t0)  ## t1 = number of nodes available
lb $t2, 8($t0)  ## t2 = size of a node
lb $t3, 16($t0)  ## t3 = current number of nodes

beq $t1, $t3, networkFull


mul $t4, $t2, $t3  ## t4 = offset of next available node
addi $t4, $t4, 36  ## accounts for the 36 previous bits in the data structure
add $t0, $t0, $t4  ## t0 points at next available node now

move $v0, $t0  ##v0 = address of new node
move $t0, $a0  ##t0 = address of network- points to number of nodes

li $t5, 1
add $t3, $t3, $t5
sb $t3, 16($t0)  ## number of nodes +=1

  jr $ra
  
networkFull:
li $v0, -1
jr $ra




.globl is_person_exists
is_person_exists:

move $t0, $a0
move $t1, $a1

lb $t2, 8($t0)  ##size of node
lb $t3, 16($t0)

addi $t0, $t0, 36 ## t0 = address of next available node
li $t4, 0

for1:
beq $t4, $t3, noPerson
beq $t0, $t1, personExists
add $t0, $t0, $t2
addi $t4, $t4, 1
j for1

noPerson:
li $v0, 0
  jr $ra
  
personExists:
li $v0, 1
jr $ra




.globl is_person_name_exists
is_person_name_exists:

move $t0, $a0
move $t1, $a1

lb $t3, 8($t0)  ## t3 = size of node(increment of bits)
lb $t4, 16($t0)  ## t4 = number of nodes(counter limit)

addi $t0, $t0, 36

li $t7, 0  ##counter for names
li $t8, 0  ## counter for characters
li $t9, 0 ## null char

for0:
beq $t7, $t4, noName
lb $t5, 0($t0)  ##t5 = first char of name
lb $t6, 0($t1)  ## t6 = first char of name being checked for

bne $t5, $t6, nextPerson
beq $t5, $t9, nameFound  ##checks if end of both name si fnull chars
addi $t8, $t8, 1
addi $t0, $t0, 1
addi $t1, $t1, 1

j for0


nextPerson:
sub $t0, $t0, $t8
sub $t1, $t1, $t8
add $t0, $t0, $t3
addi $t7, $t7, 1
li $t8, 0
j for0

noName:
li $v0, 0
  jr $ra
  
nameFound:
li $v0, 1
sub $t0, $t0, $t8
move $v1, $t0
jr $ra




.globl add_person_property
add_person_property:

move $t0, $a0  ## t0 = address of network
move $t1, $a1  ##t1 = address of person in network
move $t2, $a2  ##t2 = string "NAME"
move $t3, $a3  ##t3 = name of person to be instantiated

lb $t5, 0($t2)
li $t4, 78
bne $t4, $t5, cond1Violated
addi $t2, $t2, 1

lb $t5, 0($t2)
li $t4, 65
bne $t4, $t5, cond1Violated
addi $t2, $t2, 1

lb $t5, 0($t2)
li $t4, 77
bne $t4, $t5, cond1Violated
addi $t2, $t2, 1

lb $t5, 0($t2)
li $t4, 69
bne $t4, $t5, cond1Violated
addi $t2, $t2, 1



move $t2, $a2
move $s0, $t3
move $s1, $t0
move $s2, $t1

addi $sp, $sp, -16
sw $s0, 0($sp)
sw $s1, 4($sp)
sw $s2, 8($sp)
sw $ra, 12($sp)
jal is_person_exists

lw $s0, 0($sp)
lw $s1, 4($sp)
lw $s2, 8($sp)
lw $ra, 12($sp)
addi $sp, $sp, 16

beq $v0, $0, cond2Violated

li $t6, 0
move $t3, $s0
move $t0, $s1

for3:
lb $t5, 0($t3)
beq $t5, $0, checkLenToNodeSize
addi $t6, $t6, 1
addi $t3, $t3, 1
j for3

checkLenToNodeSize:
lb $t7, 8($t0)  ## t3 = size of node
bge $t6, $t7, cond3Violated

move $a0, $t0
move $a1, $s0
move $s1, $s2

addi $sp, $sp, -12
sw $s0, 0($sp)
sw $s1, 4($sp)
sw $ra, 8($sp)
jal is_person_name_exists

lw $s0, 0($sp)
lw $s1, 4($sp)
lw $ra, 8($sp)
addi $sp, $sp, 12

bne $v0, $0, cond4Violated

move $t3, $s0
move $t1, $s1

for4:
lb $t5, 0($t3)
beq $t5, $0, addPersonPropDone
sb $t5, 0($t1)
addi $t3, $t3, 1
addi $t1, $t1, 1
j for4

cond1Violated:
li $v0, 0
  jr $ra

cond2Violated:
li $v0, -1
  jr $ra
  
cond3Violated:
li $v0, -2
  jr $ra
  
cond4Violated:
li $v0, -3
  jr $ra
  
addPersonPropDone:
li $v0, 1
jr $ra
  
  
  
  
.globl get_person
get_person:

move $t0, $a0
move $t1, $a1

lb $t3, 8($t0)  ## t3 = size of node(increment of bits)
lb $t4, 16($t0)  ## t4 = number of nodes(counter limit)

addi $t0, $t0, 36

li $t7, 0  ##counter for names
li $t8, 0  ## counter for characters
li $t9, 0 ## null char

for5:
beq $t7, $t4, noName1
lb $t5, 0($t0)  ##t5 = first char of name
lb $t6, 0($t1)  ## t6 = first char of name being checked for

bne $t5, $t6, nextPerson1
beq $t5, $t9, nameFound1 ##checks if end of both name si fnull chars
addi $t8, $t8, 1
addi $t0, $t0, 1
addi $t1, $t1, 1

j for5


nextPerson1:
sub $t0, $t0, $t8
sub $t1, $t1, $t8
add $t0, $t0, $t3
addi $t7, $t7, 1
li $t8, 0
j for5

noName1:
li $v0, 0
  jr $ra
  
nameFound1:
sub $t0, $t0, $t8
move $v0, $t0
jr $ra




.globl is_relation_exists
is_relation_exists:

move $t0, $a0
move $t1, $a1
move $t2, $a2

lb $t3, 4($t0)  ##t3 = total number of edges
li $t4, 12

lb $t5, 0($t0)
lb $t6, 8($t0)
mul $t7, $t6, $t5

addi $t0, $t0, 36
add $t0, $t0, $t7

li $t5, 0  ##counter

for6:
lw $t9, 0($t0)
beq $t5, $t3, noRelation
beq $t9, $t1, checkSecondPerson
beq $t9, $t2, checkFirstPerson
add $t0, $t0, $t4
addi $t5, $t5, 1
j for6

checkSecondPerson:
li $t7, 4
add $t0, $t0, $t7 ##goes to next address of seconc person
lw $t9, 0($t0)
beq $t9, $t2, yesRelation
sub $t0, $t0, $t7
add $t0, $t0, $t4
addi $t5, $t5, 1
j for6

checkFirstPerson:
li $t7, 4
add $t0, $t0, $t7 ##goes to next address of seconc person
lw $t9, 0($t0)
beq $t9, $t1, yesRelation
sub $t0, $t0, $t7
add $t0, $t0, $t4
addi $t5, $t5, 1
j for6

noRelation:
li $v0, 0
  jr $ra
  
yesRelation:
li $v0, 1
jr $ra



.globl add_relation
add_relation:

move $s0, $a0
move $s1, $a1
move $s2, $a2

addi $sp, $sp, -16
sw $s0, 0($sp)
sw $s1, 4($sp)
sw $s2, 8($sp)
sw $ra, 12($sp)
jal is_person_exists

lw $s0, 0($sp)
lw $s1, 4($sp)
lw $s2, 8($sp)
lw $ra, 12($sp)
addi $sp, $sp, 16

beq $v0, $0, cond1Violated1

move $a0, $s0
move $a1, $s2

addi $sp, $sp, -16
sw $s0, 0($sp)
sw $s1, 4($sp)
sw $s2, 8($sp)
sw $ra, 12($sp)
jal is_person_exists

lw $s0, 0($sp)
lw $s1, 4($sp)
lw $s2, 8($sp)
lw $ra, 12($sp)
addi $sp, $sp, 16

beq $v0, $0, cond1Violated1

move $t0, $s0

lb $t3, 4($t0)  ##number of edges available
lb $t4, 20($t0)  ##current number of edges in the network
bge $t4, $t3,  cond2Violated1

move $a0, $s0
move $a1, $s1
move $a2, $s2

addi $sp, $sp, -16
sw $s0, 0($sp)
sw $s1, 4($sp)
sw $s2, 8($sp)
sw $ra, 12($sp)
jal is_relation_exists

lw $s0, 0($sp)
lw $s1, 4($sp)
lw $s2, 8($sp)
lw $ra, 12($sp)
addi $sp, $sp, 16

bne $v0, $0, cond3Violated1

move $t0, $s0
move $t1, $s1
move $t2, $s2

beq $t1, $t2, cond4Violated1

lb $t6, 0($t0)  ##t3 = number of available nodes
lb $t7, 8($t0)  
mul $t8, $t7, $t6

lb $t3, 20($t0)  ##t3 = current number od edges
li $t5, 12
mul $t4, $t3, $t5

addi $t0, $t0, 36  ##36 for the first 36 constant bytes
add $t0, $t0, $t8  ## size of a node*number of nodes

lb $t9, 0($t0)
beq $t9, $0, edgeStart
addi $t0, $t0, 1

lb $t9, 0($t0)
beq $t9, $0, edgeStart
addi $t0, $t0, 1

lb $t9, 0($t0)
beq $t9, $0, edgeStart
addi $t0, $t0, 1

edgeStart:
add $t0, $t0, $t4  ## size of an edge times current number of edges


sw $t1, 0($t0)
addi $t0, $t0, 4
sw $t2, 0($t0)

move $t0, $s0
lb $t1, 20($t0)
addi $t1, $t1, 1
sw $t1, 20($t0)

li $v0, 1
jr $ra

cond1Violated1:
li $v0, 0
jr $ra

cond2Violated1:
li $v0, -1
jr $ra

cond3Violated1:
li $v0, -2
jr $ra

cond4Violated1:
li $v0, -3
jr $ra

.globl add_relation_property
add_relation_property:

move $s0, $a0
move $s1, $a1
move $s2, $a2
move $s3, $a3

addi $sp, $sp, -20
sw $s0, 0($sp)
sw $s1, 4($sp)
sw $s2, 8($sp)
sw $s3, 12($sp)
sw $ra, 16($sp)

jal is_relation_exists

lw $s0, 0($sp)
lw $s1, 4($sp)
lw $s2, 8($sp)
lw $s3, 12($sp)
lw $ra, 16($sp)
addi $sp, $sp, 20

beq $v0, $0, cond1Violated2

move $t0, $s0
move $t1, $s1
move $t2, $s2
move $t3, $s3

li $t5, 70  ##checks for F
lb $t4, 29($t0)
bne $t4, $t5, cond2Violated2  
addi $t0, $t0, 1

li $t5, 82  ##checks for R
lb $t4, 29($t0)
bne $t4, $t5, cond2Violated2  
addi $t0, $t0, 1

li $t5, 73  ##checks for I
lb $t4, 29($t0)
bne $t4, $t5, cond2Violated2  
addi $t0, $t0, 1

li $t5, 69  ##checks for E
lb $t4, 29($t0)
bne $t4, $t5, cond2Violated2  
addi $t0, $t0, 1

li $t5, 78  ##checks for N
lb $t4, 29($t0)
bne $t4, $t5, cond2Violated2  
addi $t0, $t0, 1

li $t5, 68  ##checks for D
lb $t4, 29($t0)
bne $t4, $t5, cond2Violated2  

move $t0, $s0

lb $t4, 20($t0)
li $t5, 0  ##counter
lb $t8, 4($t0)
li $t6, 12

for9:
beq $t5, $t8, cond2Violated2
lw $t9, 0($t0)
beq $t9, $t1, checkSecondPerson0
beq $t9, $t2, checkFirstPerson0
add $t0, $t0, $t6
addi $t5, $t5, 1
j for9

checkSecondPerson0:
li $t7, 4
add $t0, $t0, $t7 ##goes to next address of seconc person
lw $t9, 0($t0)
beq $t9, $t2, done9
sub $t0, $t0, $t7
add $t0, $t0, $t6
addi $t5, $t5, 1
j for9

checkFirstPerson0:
li $t7, 4
add $t0, $t0, $t7 ##goes to next address of seconc person
lw $t9, 0($t0)
beq $t9, $t1, done9
sub $t0, $t0, $t7
add $t0, $t0, $t6
addi $t5, $t5, 1
j for9

done9:
li $t1, 1
sw $t1, 4($t0)

li $v0, 1
jr $ra

cond1Violated2:
li $v0, 0
jr $ra

cond2Violated2:
li $v0, -1
  jr $ra

.globl is_friend_of_friend
is_friend_of_friend:

move $s0, $a0
move $s1, $a1
move $s2, $a2




addi $sp, $sp, -16
sw $s0, 0($sp)
sw $s1, 4($sp)
sw $s2, 8($sp)
sw $ra, 12($sp)

jal is_person_name_exists

lw $s0, 0($sp)
lw $s1, 4($sp)
lw $s2, 8($sp)
lw $ra, 12($sp)
addi $sp, $sp, 16

beq $v0, $0 noExist

move $a0, $s0
move $a1, $s2

addi $sp, $sp, -16
sw $s0, 0($sp)
sw $s1, 4($sp)
sw $s2, 8($sp)
sw $ra, 12($sp)

jal is_person_name_exists

lw $s0, 0($sp)
lw $s1, 4($sp)
lw $s2, 8($sp)
lw $ra, 12($sp)
addi $sp, $sp, 16

beq $v0, $0, noExist



addi $sp, $sp, -16
sw $s0, 0($sp)
sw $s1, 4($sp)
sw $s2, 8($sp)
sw $ra, 12($sp)

jal get_person

lw $s0, 0($sp)
lw $s1, 4($sp)
lw $s2, 8($sp)
lw $ra, 12($sp)
addi $sp, $sp, 16

move $s3, $v0
move $a0, $s0
move $a1, $s2


addi $sp, $sp, -20
sw $s0, 0($sp)
sw $s1, 4($sp)
sw $s2, 8($sp)
sw $s3, 12($sp)
sw $ra, 16($sp)

jal get_person

lw $s0, 0($sp)
lw $s1, 4($sp)
lw $s2, 8($sp)
lw $s3, 12($sp)
lw $ra, 16($sp)
addi $sp, $sp, 20

move $s2, $v0
move $s1, $s3

move $a0, $s0
move $a1, $s1
move $a2, $s2

addi $sp, $sp, -16
sw $s0, 0($sp)
sw $s1, 4($sp)
sw $s2, 8($sp)
sw $ra, 12($sp)

jal is_relation_exists

lw $s0, 0($sp)
lw $s1, 4($sp)
lw $s2, 8($sp)
lw $ra, 12($sp)
addi $sp, $sp, 16

bne $v0, $0, P1andP3Friends

P1andP3Friends:
li $v0, 0
  jr $ra
  
  
noExist:
li $v0, -1
jr $ra
