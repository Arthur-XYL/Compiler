# Compiler
This is a compiler for the snek programming language.
    <h3>Concrete Syntax</h3>
    <pre>
&lt;prog&gt; - A program consists of 0 or more function definitions followed by a main expression. The expression gets evaluated during runtime execution, which can call function(s) defined previously. 
&lt;defn&gt; - A function definition consists of a function name followed by 0 or more names for its argument. The syntax goes like this — (fun &lt;name&gt; &lt;arg1&gt; &lt;arg2&gt; …).
&lt;expr&gt; - An expression consists of one of the following:
  | &lt;number&gt; - a number within the range  
  | &lt;boolean&gt; - “true” or “false” (without quotation mark)
  | input - a boolean value, a number, or nothing. This is the argument for the main expression, and a main expression doesn't have to have an argument.
  | &lt;identifier&gt; - a string representing a variable.
  | (let ((&lt;identifier&gt; &lt;expr&gt;)+) &lt;expr&gt;) - a let binding that assigns values to 1 or more variables, then evaluates the following expressions with these variables. Example: (let ((x 1) (y 2)) (+ x y)).
  | (&lt;op1&gt; &lt;expr&gt;) - an one expression operation. See below to check op1. Notice that if the last expression is print, the result will get printed twice. 
  | (&lt;op2&gt; &lt;expr&gt; &lt;expr&gt;) - a two expressions operation. Both expressions needed to be evaluated as numbers to make the operation work. If the operation is “equal”, both expressions can be either numbers or booleans. 
  | (set! &lt;identifier&gt; &lt;expr&gt;) - set a new value to an existing variable. The &lt;identifier&gt; is the string representation of an existing variable, and &lt;expr&gt; is the expression whose value is assigned to the variable.
  | (if &lt;expr&gt; &lt;expr&gt; &lt;expr&gt;) - an if statement. The first expression evaluates to a boolean value. If the evaluated boolean value is true, evaluates the second expression, otherwise evaluates the third expression.
  | (block &lt;expr&gt;+) - an expression that contains 1 or more expressions. It evaluates the inner expressions one by one, one after the other. 
  | (loop &lt;expr&gt;) - a loop statement that keeps repeating the expression. 
  | (break &lt;expr&gt;) - a break statement breaks out of the loop with the value of the evaluation of the expression.
  | (tuple &lt;expr&gt;+) - a heap data structure tuple that contains one or more elements. A tuple contains the value of the evaluation of these expressions.
  | (index &lt;expr&gt; &lt;expr&gt;) - get the element of the tuple at a specific index. The first expression evaluates to a tuple, and the second expression evaluates to a nonnegative number. 
  | (&lt;name&gt; &lt;expr&gt;*) - a function call that consists of the name of the function and 0 or more expressions. The values of the evaluated expressions are the values of the arguments of the function. 
&lt;op1&gt; := add1 | sub1 | isnum | isbool | print
&lt;op2&gt; := + | - | * | &lt; | &gt; | &gt;= | &lt;= | =
    </pre>
                                     
There are some files in the tests directory that you can reference. 
If you want to write a snek program, do the following:
1. Go to the root directory
2. Create a file called [name].snek
3. Write the snek program inside the file and save it
4. type "make [name].run" without the quotation mark onto the command line to compile
5. type "./[name].run" to run the program

You can check the files in the tests directory for reference. 
