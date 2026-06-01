typedef unsigned char   undefined;

typedef unsigned char    undefined1;
typedef unsigned short    undefined2;
typedef unsigned int    undefined4;
typedef unsigned char    byte;



// WARNING: Control flow encountered bad instruction data

void FUN_08000c42(undefined4 param_1)

{
  undefined4 *unaff_r6;
  
  *unaff_r6 = param_1;
                    // WARNING: Bad instruction - Truncating control flow here
  halt_baddata();
}


