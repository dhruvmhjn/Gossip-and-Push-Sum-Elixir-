defmodule Genplay do
use GenServer

  def start_link(top, n, i) do
    GenServer.start_link(__MODULE__, {top,n,i}, name: String.to_atom("node#{i}"))
  end

  
  def hear_rumour do
    gossip_count = :sys.get_state(__MODULE__)
    
    if gossip_count < 10 do 
        GenServer.call __MODULE__, :rumour
        else
         IO.puts "Gossip count reached 10"
        end
  end

  def init({top,n,i}) do
        list = cond do
            
        (i==1) -> {2}
        (i==n) -> {n}
        
        true ->  {i-1,i+1}
        end
    

      {:ok,{n,list}}
  end
 
  def handle_call(:rumour,_from,count)do
    {:reply,count,count+1}
  end

 
end