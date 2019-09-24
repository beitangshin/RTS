--Cyclic scheduler with a watchdog: 

with Ada.Calendar;
with Ada.Text_IO;
with Ada.Numerics.Float_Random;
use Ada.Calendar;
use Ada.Text_IO;
use Ada.Numerics.Float_Random;
-- add packages to use randam number generator

procedure Cyclic_wd is
   Message: constant String := "Cyclic scheduler with watchdog";
   -- change/add your declarations here
   Start_Time: Time := Clock;
   T : Time := Clock;
   Tx : Time := Clock;
   
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
      Put(Message);
      Put_Line(Duration'Image(Clock - Start_Time));
   end F2;
   
   procedure F3 is
      Message: constant String := "f3 executing, time is now";
      X: Float;
      G: Generator;
      D3: Duration:= 0.5;
   begin
      Reset(G);
      Put(Message);
      Put_Line(Duration'Image(Clock - Start_Time));
      X:= Random(G);
      D3 := Duration(X);
     -- Put_Line(Duration'Image(D3));   //check for the random float
     delay D3;
      -- add a random delay here
   end F3;
   
   task Watchdog is
      -- add your task entries for communication
      entry Check(Twd : in Time);
      entry Rset(Twd2 : out Time);
    end  Watchdog;
   
  task body Watchdog is
     --Declarations needed by task code
     Twd1 : Time;
     
     
   begin
      loop
	 -- add your task code inside here
	 accept Check(Twd : in Time) do
	    Twd1 := Twd;  -- T=>>Twd1
	    
	    if (Clock-Twd1) > 1.0 then
	       Put_line("Warning!");
	      delay until Clock;    
       
      else
	 delay until Twd1+1.0;
	    end if;
	    end Check;
         accept Rset(Twd2 : out Time) do
	    Twd2 := Twd1; -- Tw1d:=T =>>T
	    end Rset;
      end loop;
      end Watchdog;
  
   
begin
   
   loop
      -- change/add your code inside this loop     
      F1;
      F2;
      delay until T+0.5;
      F3;
      Watchdog.Check(T);
      Watchdog.Rset(T);
      F1;
      F2;
      delay until T+1.0;
   end loop;
end Cyclic_Wd;
