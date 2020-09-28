// This file is part of www.nand2tetris.org
// and the book "The Elements of Computing Systems"
// by Nisan and Schocken, MIT Press.
// File name: projects/04/Fill.asm

// Runs an infinite loop that listens to the keyboard input.
// When a key is pressed (any key), the program blackens the screen,
// i.e. writes "black" in every pixel;
// the screen should remain fully black as long as the key is pressed. 
// When no key is pressed, the program clears the screen, i.e. writes
// "white" in every pixel;
// the screen should remain fully clear as long as no key is pressed.

// Put your code here.


// while ( 1 ) {
//   if ( KBD == 0 ) {
//       for ( i=0;i < 8192;i++) M[SCREEN+i] = 0;
//       continue;
//   }
// 
//   for ( i = 0; i < 8192; i++ ) {
//    M[SCREEN+i] = -1; // -1 mean 1111111111111111
//   }
// }

  @i
  M=0

(WHILE)
  @KBD
  D=M
  @LOOP_BLACK
  D;JGT

(LOOP_WHITE)
  @i           // i == 8192 goto WHILE
  D=8192-M
  @WHILE
  D;JEQ

  @SCREEN
  D=A
  @i
  A=D+M
  M=0
  @i
  M=M+1
  @LOOP_WHITE
  0;JMP

(LOOP_BLACK)
  @i    // i == 8192 goto WHILE
  D=8192-M
  @WHILE
  D;JEQ

  @SCREEN
  D=A
  @i
  A=D+M
  M=-1
  @i
  M=M+1
  @LOOP_BLACK
  0;JMP
