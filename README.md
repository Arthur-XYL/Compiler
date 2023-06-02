# Compiler
This is a compiler for the snek programming language.

Syntax of the snek programming language:     
<prog> := <defn>* [expr]        
 <defn> := (fun ([fun_name] [arg_name]*) [expr])        
[expr] :=       
 | [number](i64)         
 | [boolean] := true | false       
 | input := true | false | [number]      
 | [identifier](String)       
 | (let (([identifier] [expr])+) [expr])      
 | ([op1] [expr])         
 | ([op2] [expr] [expr])     
 | (set! [name] [expr])     
 | (if [expr] [expr] [expr])     
 | (block [expr]+)    
 | (loop [expr])    
 | (break [expr])     
 | (tuple [expr]+)      
 | (index [expr] [expr])      
 | ([name] [expr]*)      
[op1] := add1 | sub1 | isnum | isbool | print       
[op2] := + | - | * | < | > | >= | <= | =      
where       
   "+"  - at least one of the marked element    
   "*"  - zero or more of the marked element.    
   ":=" - the structure of the element     
   "|"  - can be one of the elements separated by this character    
   "(type)" - the type of the element   
   "[expr]"    - represents an expression     
   "[element]" - represents the value of the element    
                                     
There are some files in the tests directory that you can reference. 
If you want to write a snek program, do the following:
1. Go to the root directory
2. Create a file called [name].snek
3. Write the snek program inside the file and save it
4. type "make [name].run" without the quotation mark onto the command line to compile
5. type "./[name].run" to run the program
