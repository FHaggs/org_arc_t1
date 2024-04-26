# Data section
.data
result_msg: .asciiz "Result: "
x: .word 100
i: .word 10
result: .space 4
# Text section
.text
.globl main

# Main function
main:
    # Set up arguments for newton_raphson function
    lw   $a0, x     # Load x into $a0
    lw   $a1, i     # Load i into $a1
    
    subi $sp, $sp, 8 # Open space in stack
    sw   $a1, 4($sp) # Put i in stack
    sw	 $ra, 0($sp) # Put $ra in top of the stack	

    # Call newton_raphson function
    jal  newton_raphson
    sw $v0, result
    lw $ra, 0($sp)		# 	// Recupera o endereço de retorno para o SO (inexistente ao usar o MARS)
    addiu $sp, $sp, 8
    # Display result
    li   $v0, 4            # System call for printing string
    la   $a0, result_msg   # Load address of the string to print
    syscall

    # Display result value
    lw $a0, result      # 
    li   $v0, 1            # System call for printing integer
    syscall

    # Exit program
    li   $v0, 10           # System call for exit
    syscall


# Function: newton_raphson
# Returns:
#   $v0: result

newton_raphson:
    
    lw $t0, 4($sp) # t0 = i
    # Base case: if i == 0, return 1
    bne $t0, $zero, recurs
    li	$v0, 1	# Return 1		
    jr	$ra
recurs:
    # Recursive call 1: newton_raphson(x, i-1)
    addiu $t0, $t0, -1        # Decrement i
    subi $sp, $sp, 8        # Open stack
    sw	 $t0, 4($sp)         # Save i-1
    sw   $ra, 0($sp)         # Save return adress

    jal  newton_raphson      # Recursive call

    # Restore argument and ra
    lw   $ra, 0($sp)         # Restore $ra
    lw   $t0, 4($sp)         # Restore i
    addiu $sp, $sp, 8         # Restore stack

    # Calculate result
    div  $a0, $v0            # X / newton_raphson(x, i-1)
    mflo $t1                 # Move result to $t1
    add $t1, $t1, $v0        # (newton_raphson(x, i-1) + (x / newton_raphson(x, i-1)
    sra $t1, $t1, 1
    
    move $v0, $t1

    jr   $ra                 # Return

