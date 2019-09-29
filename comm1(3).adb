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
        NumbElems : constant :=9;
        type BufferArray is array(0 .. NumbElems) of Integer;
        CurrentSize : integer range 0.. NumbElems :=0;
        Buffers: BufferArray;
        Next_in, Next_out : integer range 1..NumbElems := 1;

                -- change/add your local declarations here
                
        begin
        Put_Line(Message);
            loop
            select
                when CurrentSize < NumbElems =>
                    accept PutIn(value : in Integer) do
                        Buffers (Next_in) := value;
                        Next_in := (Next_in mod NumbElems) + 1;
                        CurrentSize := CurrentSize + 1;
                        end PutIn;
                or
                when CurrentSize>0 =>
                    accept Retrieve(output: out Integer) do
                        output:= Buffers (Next_out);
                        Next_out := (Next_out mod NumbElems) + 1;
                        CurrentSize := CurrentSize - 1;
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
  

