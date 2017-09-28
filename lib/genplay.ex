defmodule Genplay do
use GenServer

  def start_link(count) do
    GenServer.start_link(__MODULE__, count, name: __MODULE__)
  end
  def hear_rumour do
    gossip_count = :sys.get_state(__MODULE__)
    if gossip_count < 10 do 
       GenServer.call __MODULE__, :rumour
       else
        IO.puts "Gossip count reached 10"
      end
  end

  def handle_call(:get_count,_from,count) do
    {:reply,count}
  end
  def handle_call(:rumour,_from,count)do
    {:reply,count,count+1}
  end

 
end