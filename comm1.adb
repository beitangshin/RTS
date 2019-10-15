--Chen Yang, Lianqiao xiao group 18
--Process commnication: Ada lab part 3
--revised now the program will stop when the sum is over 100


with Ada.Calendar;
with Ada.Text_IO;
with Ada.Numerics.Discrete_Random;
use Ada.Calendar;
use Ada.Text_IO;

procedure Comm1 is
   
   Message: constant String := "Process communication";
   Add: Integer :=0;
   
   task Buffer is
      entry PutIn(Value : in Integer) ;
      entry Retrieve (Output: out Integer);
      entry Bstop;
   end Buffer;
   
   task Producer is
      entry Putstart;
   end Producer;
   
   task Consumer is
     -- entry Cstop(Stf:out Integer );
   end Consumer;
   
   task body Buffer is
      Message: constant String := "buffer executing";
      NumbElems : constant :=10;
      type BufferArray is array(1 .. NumbElems) of Integer;
      CurrentSize : Integer range 0.. NumbElems :=0;
      Buffers: BufferArray;
      Next_In, Next_Out : Integer range 1..NumbElems := 1;
      StopB:Integer:=0;
   begin
      Put_Line(Message);
      
      
      --accept StartBuffer(StartB: in Integer) do
      
	 
      --if Add<100 then
      
     if StopB=0 then
	loop
	 select
	    --when CurrentSize < NumbElems =>
	       
	       accept PutIn(Value : in Integer) do
		  Buffers (Next_In) := Value;
		  Next_In := (Next_In mod NumbElems) + 1;
		  CurrentSize := CurrentSize + 1;
	       end PutIn;
	       
	       
	 or
	    --when CurrentSize>0 =>
	       
	       accept Retrieve(Output: out Integer) do
		  Output:= Buffers (Next_Out);
		  Next_Out := (Next_Out mod NumbElems) + 1;
		  CurrentSize := CurrentSize - 1;
	       end Retrieve;
	 or accept Bstop do
	    StopB:=1;
	    end Bstop;
	 end select;
	 end loop;
	end if; 
	 -- elsif Add>=100 then
	 
	 -- exit;
	 --   end if;
	 Put_Line("Ending the consumer");
	 
	 
	 
   end Buffer;
   
   
   task body Producer is
      Message: constant String := "producer executing";
      MessageP: constant String := "producer produced";
      subtype Int is Integer range 1 .. 20;
      package Random_Int is new Ada.Numerics.Discrete_Random (Int);
      use Random_Int;
      G : Generator;
      N: Integer;
   begin
      
      Put_Line(Message);
      --if Add<100 then
      loop
	 accept Putstart do
	    Reset(G);
	    N := Random(G);
	    Buffer.PutIn(N);
	    Put_Line(MessageP);
	    Put_Line(Integer'Image(N));
	 end Putstart;

      end loop;  
      -- elsif Add>=100 then
	 
	 --  exit;
	 --end if;
	 
   end Producer;
   
   task body Consumer is
      Message: constant String := "consumer executing";
      MessageR: constant String := "consumer retrieved";
      RetrievedNumber : Integer;
      Stf:Integer:=0;
   begin
      
      Put_Line(Message);
     
  Main_Cycle:
      -- if Add<=100 then
    
	 loop
	  if Add<= 100 then
	    Producer.Putstart;
	    Buffer.Retrieve(RetrievedNumber);
	    Add := Add+RetrievedNumber;
	    Put_Line(MessageR);
	    Put_Line(Integer'Image(RetrievedNumber));
	    Put_Line("Add");
	    Put_Line(Integer'Image(Add));
	   end if;
	    Buffer.Bstop;
	    Producer.Putstart;
	    	
	 

	  --end if; 
	 end loop Main_Cycle;
  exception
--   when TASKING_ERROR =>
     when others =>
     Put_Line("Buffer finished before producer");
	 Put_Line("Ending the consumer");

	 
   end Consumer;
begin
   Put_Line(Message);
   
   end Comm1;
