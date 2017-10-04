defmodule GossipNode do
  use GenServer
  
  def start_link(top,n,x) do
    sqn=round(:math.sqrt(n))
    i = div((x-1),sqn) + 1
    j = rem((x-1),sqn) + 1 
    returnok = {:ok,_pid} = cond do
      (top == "line")||(top == "full") ->  GenServer.start_link(__MODULE__, {top,n,x,0}, name: String.to_atom("node#{x}"))
      (top == "2D") || (top == "imp2D") ->  GenServer.start_link(__MODULE__, {top,n,i,j}, name: String.to_atom("node#{i}#{j}"))
    end
  returnok
  end

  def hear_rumour do
    gossip_count = :sys.get_state(__MODULE__)
    
    if gossip_count < 10 do 
        GenServer.call __MODULE__, :rumour
        else
         IO.puts "Gossip count reached 10"
        end
  end

  def init({top,n,i,j}) do
    sqn= round(:math.sqrt(n))
    list = cond do
      (top == "full") -> []  
      (top == "line") && (i == 1) -> [:node2]
      (top == "line") && (i == n) -> [String.to_atom("node#{n-1}")]
      (top == "line")  -> [String.to_atom("node#{i-1}"),String.to_atom("node#{i+1}")]
      (i != 1) && (i != sqn) && (j != 1) && (j != sqn) -> [String.to_atom("node#{i}#{j+1}"),String.to_atom("node#{i+1}#{j}"),String.to_atom("node#{i}#{j-1}"),String.to_atom("node#{i-1}#{j}")]
      (i == 1) && (j == 1) -> [:node21,:node12]
      (i == sqn) && (j == 1) -> [String.to_atom("node#{i-1}#{j}"),String.to_atom("node#{i}#{j+1}")] #{Integer.undigits([i-1,j]), Integer.undigits([i,j+1])}
      (i == 1) && (j == sqn) -> [String.to_atom("node#{i+1}#{j}"),String.to_atom("node#{i}#{j-1}")] #{Integer.undigits([i,j-1]), Integer.undigits([i+1,j])}      
      (i == sqn) && (j == sqn) -> [String.to_atom("node#{i-1}#{j}"),String.to_atom("node#{i}#{j-1}")] #{Integer.undigits([(i-1),j]), Integer.undigits([i,(j-1)])}
      (j == 1) ->[String.to_atom("node#{i-1}#{j}"),String.to_atom("node#{i+1}#{j}"),String.to_atom("node#{i}#{j+1}")]  #{Integer.undigits([i+1,j]), Integer.undigits([i,j+1]), Integer.undigits([i-1,j])}
      (j == sqn) ->  [String.to_atom("node#{i-1}#{j}"),String.to_atom("node#{i+1}#{j}"),String.to_atom("node#{i}#{j-1}")]#{Integer.undigits([i+1,j]), Integer.undigits([i,j-1]), Integer.undigits([i-1,j])}
      (i == 1) ->  [String.to_atom("node#{i}#{j-1}"),String.to_atom("node#{i}#{j+1}"),String.to_atom("node#{i+1}#{j}")]#{Integer.undigits([i,j-1]), Integer.undigits([i,j+1]), Integer.undigits([i+1,j])}
      (i == sqn) ->  [String.to_atom("node#{i}#{j-1}"),String.to_atom("node#{i}#{j+1}"),String.to_atom("node#{i-1}#{j}")]#{Integer.undigits([i,j-1]), Integer.undigits([i,j+1]), Integer.undigits([i-1,j])}
      true ->  []
    end
    #IO.puts "sqn=#{sqn} i=#{i} j=#{j} list=#{inspect(list)}"
    {:ok,{n,list,0,top}}
  end
 
  def handle_cast({:rumour,rsrting},{n,list,localcount,top})do
    localcount = localcount + 1
    if localcount == 1 do
      GenServer.cast(:gcounter, :heardrumour)
    end
    if localcount <= 10 do
      GenServer.cast(self(), {:spreadrumour,rsrting})
    end
    {:noreply,{n,list,localcount,top}}
  end
  
  def handle_cast({:spreadrumour,rsrting},{n,list,localcount,top})do
    
    #Random neighbour call
    #Code For fukk
    len_neb = length(list)
    name_neb = cond do
        len_neb == 0 -> String.to_atom("node#{:rand.uniform(n)}")
        true -> Enum.at(list,(:rand.uniform(len_neb)-1))
    end
    GenServer.cast(name_neb, {:rumour, rstring})
    :timer.sleep(100)
    if localcount <= 10 do
      GenServer.cast(self(), {:spreadrumour,rsrting})
    end
    #GenServer.cast(self(), {:spreadrumour,rsrting})
    {:noreply,{n,list,localcount,top}}
  end
end