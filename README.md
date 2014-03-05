Credit Card Processing
########################
  
Instructions:
------------------
In a terminal window, navigate to the programs root directory to run the following command with input file argument. 

	>ruby program.rb <textfile name>  
  

Design Overview:
------------------
I used the technique of Test Driven Development to guide the development of this program. RSpec was used to test for a method and its expected output at the program's simplest requirement, building on that until the all requirements are met.  

However, I encountered an issue in my initial design. I needed to figure out how to store the customers' information while still making them available to be adjusted by their successive transactions. I solved this by creating an array to be passed as additional argument with the string during the object creation of Processing class.  
  
When a line of string from the input file is submitted for object creation it is converted to an array of strings and parsed. The first element of the string array is the type of process request (Add, Charge, Credit). For each of these requests, I create a specific method that will mimmick each task. These requests are triggered with the execution of the output method associated with the object.
  
When each task is completed, they have successfully modified the array of customer information and this array is returned to the method call on output and stored.  
  
This process keeps going until all the lines in the input file have been read. Finally, the latest version of the array is sorted by credit card customer name and outputted.  
  
  
Why Ruby Language?  
-------------------
I chose Ruby language as it has a lot of built in methods that can be chained or combined and manipulated to produce a required feature. Additionally, for me, Ruby is easier to read; there are a lot of documentations that demonstrate the built in function like http://www.ruby-doc.org/. Moreover, implementing TDD with RSpec to test my class was fundamental in my decision.