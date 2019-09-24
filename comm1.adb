--- Chen Yang, Lianqiao xiao group 18
--Process commnication: Ada lab part 3

with Ada.Calendar;
with Ada.Text_IO;
with Ada.Numerics.Discrete_Random;
use Ada.Calendar;
use Ada.Text_IO;

procedure Comm1 is

   Message: constant String := "Process communication";


   task Buffer is
      entry Store (Input : in Integer );
      entry Retrieve (Output : out Integer );
      entry SumAbove100;
      -- add your task entries for communication
   end Buffer;

   task Producer is
      -- add your task entries for communication
   end Producer;

   task Consumer is
      entry Over100(B : out Boolean);
      -- add your task entries for communication
   end Consumer;


   --task body

   task body Buffer is
      Message: constant String := "buffer executing";
      B_SIZE: constant Natural := 10;
      B_DATA: array(0..B_SIZE-1) of Natural;
      B_FRONT: Integer :=0;
      B_REAR: Integer :=0;
      B_EMPTY: BOOLEAN := TRUE;
      B_FULL: BOOLEAN := FALSE;
      SUM_ABOVE100: BOOLEAN := FALSE;
      -- change/add your local declarations here
   begin
      Put_Line(Message);
      loop
         Consumer.Over100(SUM_ABOVE100);
         while not (B_EMPTY and SUM_ABOVE100) loop
            select
               when not B_FULL =>
                  accept Store(Input: in Integer) do
                     B_DATA(B_REAR) := Input;
                     Put_Line(Integer'Image(B_DATA(B_REAR)));
                     B_REAR := (B_REAR+1) rem B_SIZE;
                     B_EMPTY:= FALSE;
                     B_FULL := B_FRONT=B_REAR;

                  end Store;
            or
               when not B_EMPTY  =>
                  accept Retrieve(Output: out Integer) do
                     Output := B_DATA(B_FRONT);
                     B_FRONT  := (B_FRONT + 1) rem B_SIZE;
                     B_EMPTY := B_FRONT = B_REAR;
                     B_FULL  := FALSE;
                  end RETRIEVE;
            or
               accept SumAbove100 do
                  SUM_ABOVE100 := TRUE;
               end SumAbove100;

            end select;
         end loop;  -- add your task code inside this loop
      end loop;

   end Buffer;

   task body Producer is
      Message: constant String := "producer executing";
      MessageP: constant String := "producer produced";
      subtype Int is Integer range 1 .. 20;
      package Random_Int is new Ada.Numerics.Discrete_Random (Int);
      use Random_Int;
      G : Generator;
      N: Integer;
      -- change/add your local declarations here
   begin
      Put_Line(Message);
      loop
         for I in 1..10 loop
            Reset (G);
            N := Random(G);
            Buffer.Store(N);
            Put_Line(MessageP);
            Put_Line(Integer'Image(N));
         end loop;
      end loop;
   end Producer;

   task body Consumer is
      Message: constant String := "consumer executing";
      MessageR: constant String := "consumer retrieved";
      RetrievedNumber : Integer;
      Add: Integer :=0;
      Over : Boolean := False;
      -- change/add your local declarations here
   begin
      Put_Line(Message);
      Main_Cycle:
          loop

             accept Over100(B : out Boolean) do
                if Add>100 then
                   Over := TRUE;
                   B := Over;
                end if;
             end Over100;



             Buffer.Retrieve(RetrievedNumber);
             Add := Add+RetrievedNumber;
             Put_Line(MessageR);
             Put_Line(Integer'Image(RetrievedNumber));
             -- add your task code inside this loop
             delay 0.1;
          end loop Main_Cycle;


          -- add your code to stop executions of other tasks
   exception
      when TASKING_ERROR =>
         Put_Line("Buffer finished before producer");
         Put_Line("Ending the consumer");
   end Consumer;



begin
   Put_Line(Message);
   end Comm1;
