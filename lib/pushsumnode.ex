defmodule PushsumNode do
    use Genserver

    def start_link(top,n,x) do
        sqn=round(:math.sqrt(n))
        i = div((x-1),sqn) + 1
        j = rem((x-1),sqn) + 1 
        returnok = {:ok,_pid} = cond do
          (top == "line")||(top == "full") ->  GenServer.start_link(__MODULE__, {top,n,x,x,0}, name: String.to_atom("node#{x}"))
          (top == "2D") || (top == "imp2D") ->  GenServer.start_link(__MODULE__, {top,n,x,i,j}, name: String.to_atom("node#{i}@#{j}"))
        end
      returnok        
    end

    def init(top,n,x,i,j) do
        sqn= round(:math.sqrt(n))
        list = cond do
          (top == "full") -> []  
          (top == "line") && (i == 1) -> [:node2]
          (top == "line") && (i == n) -> [String.to_atom("node#{n-1}")]
          (top == "line")  -> [String.to_atom("node#{i-1}"),String.to_atom("node#{i+1}")]
          (i != 1) && (i != sqn) && (j != 1) && (j != sqn) -> [String.to_atom("node#{i}@#{j+1}"),String.to_atom("node#{i+1}@#{j}"),String.to_atom("node#{i}@#{j-1}"),String.to_atom("node#{i-1}@#{j}")]
          (i == 1) && (j == 1) -> [:node2@1,:node1@2]
          (i == sqn) && (j == 1) -> [String.to_atom("node#{i-1}@#{j}"),String.to_atom("node#{i}@#{j+1}")] #{Integer.undigits([i-1,j]), Integer.undigits([i,j+1])}
          (i == 1) && (j == sqn) -> [String.to_atom("node#{i+1}@#{j}"),String.to_atom("node#{i}@#{j-1}")] #{Integer.undigits([i,j-1]), Integer.undigits([i+1,j])}      
          (i == sqn) && (j == sqn) -> [String.to_atom("node#{i-1}@#{j}"),String.to_atom("node#{i}@#{j-1}")] #{Integer.undigits([(i-1),j]), Integer.undigits([i,(j-1)])}
          (j == 1) ->[String.to_atom("node#{i-1}@#{j}"),String.to_atom("node#{i+1}@#{j}"),String.to_atom("node#{i}@#{j+1}")]  #{Integer.undigits([i+1,j]), Integer.undigits([i,j+1]), Integer.undigits([i-1,j])}
          (j == sqn) ->  [String.to_atom("node#{i-1}@#{j}"),String.to_atom("node#{i+1}@#{j}"),String.to_atom("node#{i}@#{j-1}")]#{Integer.undigits([i+1,j]), Integer.undigits([i,j-1]), Integer.undigits([i-1,j])}
          (i == 1) ->  [String.to_atom("node#{i}@#{j-1}"),String.to_atom("node#{i}@#{j+1}"),String.to_atom("node#{i+1}@#{j}")]#{Integer.undigits([i,j-1]), Integer.undigits([i,j+1]), Integer.undigits([i+1,j])}
          (i == sqn) ->  [String.to_atom("node#{i}@#{j-1}"),String.to_atom("node#{i}@#{j+1}"),String.to_atom("node#{i-1}@#{j}")]#{Integer.undigits([i,j-1]), Integer.undigits([i,j+1]), Integer.undigits([i-1,j])}
          true ->  []
        end
       
        if(top=="imp2D") do
          randi = :rand.uniform(sqn)
          randj = :rand.uniform(sqn)
          list = list ++ [String.to_atom("node#{randi}@#{randj}")]
        end
       # state: num modes, list of neighbours, last s/w,counter,s,w
        {:ok,{n,list,nil,0,x,1}}
    end
end