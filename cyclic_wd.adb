--Cyclic scheduler with a watchdog:
-- Chen Yang, Lianqiao xiao group 18
with Ada.Calendar;
with Ada.Text_IO;
with Ada.Numerics.Float_Random;

use Ada.Calendar;
use Ada.Text_IO;
use Ada.Numerics.Float_Random;

procedure Cyclic_wd is
   Message: constant String := "Cyclic scheduler";
   -- change/add your declarations here
   T1: Time := Clock;
   Start_Time: Time := Clock;
   G: Generator; --random number generator
   X: Float;-- the number that generated
   D: Duration;--F3's delay converted in to Duration format




   procedure F1 is
      Message: constant String := "f1 executing, time is now";
   begin
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
   begin
      Reset (G);
      --reset redom generator every time of the loop
      X:= Random(G); --get the random float
      Put(Message);
      Put_Line(Duration'Image(Clock - Start_Time));
      D:= Duration(X);--conver the type
      delay D;
   end F3;


   task Watchdog is
      entry Start(T : in Time; X1 : in Float);
      entry Stop(Tout : out Time);
   end Watchdog;

   task body Watchdog is
      TW : Time; --T1 will pass it's value to TW
      XW : Float; --X will pass it's value to XW
      R : Float; -- store the round up number of XW

   begin
      loop
         accept Start(T : in Time; X1 : in Float) do
            TW := T;
            XW := X1; --Taking in parameters
            if Clock - T>0.5 then
               Put_Line("WatchDog: F3 misses its deadline!");
               R:=Float'Rounding(XW);
               delay until TW+0.5+Duration(R);
               TW :=TW+0.5+Duration(R);
               --set teh trigger of watchdog, and make sure the next job start and the next whole second
            else
               delay until TW+0.5;
               TW := TW+0.5;
            end if;
         end Start;

         accept Stop(Tout : out Time) do
            Tout := TW;
         end Stop;
         -- pass TW'S value out to T1
      end loop;
   end Watchdog;



begin
   loop
      -- change/add your code inside this loop
      F1;
      F2;
      T1 := T1+0.5;
      delay until T1;
      F3;
      Watchdog.Start(T1,X);
      Watchdog.Stop(T1);
      F1;
      F2;
      delay until T1+1.0;
      T1:=T1+1.0;


   end loop;
end Cyclic_wd;
