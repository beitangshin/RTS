--Chen Yang, Lianqiao xiao group 18
--Process commnication: Ada lab part 3

with Ada.Calendar;
with Ada.Text_IO;
with Ada.Numerics.Discrete_Random;
use Ada.Calendar;
use Ada.Text_IO;

procedure comm1 is

    Message: constant String := "Process communication";
    
    task buffer is
        entry PutIn(value : in Integer) ;
        entry Retrieve (output: out Integer);
        -- add your task entries for communication
    end buffer;

    task producer is
    -- add your task entries for communication
    end producer;

    task consumer is
    -- add your task entries for communication
    end consumer;
    --task body

    task body buffer is
        Message: constant String := "buffer executing";
        Type Index is range 0..10;
        B_SIZE: Index := 0;
        B_DATA: array(Index range 1..Index'last) of Integer;
        In_P,Out_P:Index := 1;

                -- change/add your local declarations here
                
        begin
        Put_Line(Message);
            loop
            select
                when B_SIZE < Index'last =>
                    accept PutIn(value : in Integer) do
                        In_P := In_P mod Index'last+1;
                        B_SIZE := B_SIZE + 1;
                        B_DATA(In_P) := value;
                        end PutIn;
                or
                when B_SIZE>0 =>
                    accept Retrieve(output: out Integer) do
                        Out_P := Out_P mod Index'last+1;
                        B_SIZE := B_SIZE -1;
                        output :=B_DATA(Out_P);
                        end Retrieve;
            end select;
            end loop;
        -- add your task code inside this loop=
    end buffer;


    task body producer is
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
            reset(G);
            N := Random(G);
            buffer.PutIn(N);
            Put_Line(MessageP);
            Put_Line(Integer'Image(N));
        end loop;
    end producer;


    task body consumer is
        Message: constant String := "consumer executing";
        MessageR: constant String := "consumer retrieved";
        RetrievedNumber : Integer;
        RetrievedPointer: Integer;
        Add: Integer :=0;
                 --change/add your local declarations here
    begin

        Put_Line(Message);
        Main_Cycle:
            loop
            if Add<=100 then
            buffer.retrieve(RetrievedNumber);
            Add := Add+RetrievedNumber;
            Put_Line(MessageR);
            Put_Line(Integer'Image(RetrievedNumber));
            end if;
            end loop Main_Cycle;




                -- add your code to stop executions of other tasks
        exception
             when TASKING_ERROR =>
                 Put_Line("Buffer finished before producer");
                 Put_Line("Ending the consumer");
    end consumer;
    
    
    
begin
    Put_Line(Message);
end comm1;
  

