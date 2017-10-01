defmodule Genplay do
use GenServer

  def start_link(top,n,i) do
    IO.puts "abc in genplay"
    myname = cond do
      (top=="line")||(top=="full") -> String.to_atom("node#{i}")
      true -> String.to_atom("node#{i}#{i}")
    end
    {:ok, pid} = GenServer.start_link(__MODULE__, {top,n,i,0}, name: myname )
    {:ok, pid}
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
        sqn= :math.sqrt(n)
        list = cond do
        (top=="full") -> {0}  
        (top=="line")&&(i==1) -> {2}
        (top=="line")&&(i==n) -> {n}
        (top=="line")  -> {i-1,i+1}
        (i==1)&&(j==1) -> {12,21}
        (i==1)&&(j==sqn) -> {Integer.undigits([1,(j-1)]), Integer.undigits([2,j])}
        (i==sqn)&&(j==1) -> {Integer.undigits([i,2]), Integer.undigits([(n-1),j])}
        (i==sqn)&&(j==sqn) -> {Integer.undigits([(i-1),j]), Integer.undigits([i,(j-1)])}
        (top=="2D")    -> {Integer.undigits([(i-1),j]), Integer.undigits([(i+1),j]), Integer.undigits([i,(j-1)]),Integer.undigits([i,(j+1)])}
        true ->  {}
        end
    

      {:ok,{n,list}}
  end
 
  def handle_call(:rumour,_from,count)do
    {:reply,count,count+1}
  end

 
end