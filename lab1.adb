with Ada.Calendar;
with Ada.Text_IO;
use Ada.Calendar;
use Ada.Text_IO;

procedure Cyclic is
   Message: constant String := "Cyclic scheduler";
   -- change/add your declarations here
   D: Duration := 1.0;
   Start_Time: Time := Clock;
   S: Integer := 0;
   T: Time := Clock;
   
   procedure F1 is 
      Message: constant String := "f1 executing, time is now";
   begin
      T := Clock;
      Put(Message);
      Put_Line(Duration'Image(Clock - Start_Time));
   end F1;
   
   procedure F2 is 
      Message: constant String := "f2 executing, time is now";
   begin
     -- T2: Time := Clock;	  
      Put(Message);
      Put_Line(Duration'Image(Clock - Start_Time));
     -- TD : Duration := T2+T2+T1;
   end F2;
   
   procedure F3 is 
      Message: constant String := "f3 executing, time is now";
   begin
      Put(Message);
      Put_Line(Duration'Image(Clock - Start_Time));
   end F3;
   
begin
   loop
      -- change/add your code inside this loop   
      F1;
      F2;
      delay until T+0.5;
      F3;
      delay until T+1.0;
      F1;
      F2;
      delay until T+1.0;
   end loop;
   end Cyclic;
