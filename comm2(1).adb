--Protected types: Ada lab part 4

with Ada.Calendar;
with Ada.Text_IO;
with Ada.Numerics.Discrete_Random;
use Ada.Calendar;
use Ada.Text_IO;

procedure comm2 is

    Message: constant String := "Protected Object";
    NumbElems : constant :=10;
    type BufferArray is array (1 .. NumbElems) of Integer;
        -- protected object declaration
    protected  buffer is
        entry PutIn (value: in  integer);
        entry Retrieve (output: out integer);
            -- add entries of protected object here
    private
        Buffers : BufferArray;
        Next_in, Next_out : integer range 1..NumbElems := 1;
        CurrentSize : integer range 0..NumbElems := 0;
            -- add local declarations
    end buffer;

    task producer is
        -- add task entries
    end producer;

    task consumer is
                -- add task entries
    end consumer;

    protected body buffer is
        entry PutIn (value: in  integer) when CurrentSize < NumbElems is
            begin
                Buffers (Next_in) := value;
                Next_in := (Next_in mod NumbElems) + 1;
                CurrentSize := CurrentSize + 1;
        end PutIn;

        entry Retrieve (output: out integer) when CurrentSize > 0 is
            begin
                output := Buffers (Next_out);
                Next_out := (Next_out mod NumbElems) + 1;
                CurrentSize := CurrentSize - 1;
        end Retrieve;
              -- add definitions of protected entries here
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
                -- add local declrations of task here
        MessageR: constant String := "consumer retrieved";
        RetrievedNumber : Integer;
        Add: Integer :=0;
                 --change/add your local declarations here
    begin

        Put_Line(Message);
        Main_Cycle:
            loop
            if Add<=100 then
            buffer.Retrieve(RetrievedNumber);
            Add := Add+RetrievedNumber;
            Put_Line(MessageR);
            Put_Line(Integer'Image(RetrievedNumber));
            end if;
            end loop Main_Cycle;
            Put_Line("Ending the consumer");
    end consumer;

begin
Put_Line(Message);
end comm2;
