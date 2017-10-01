defmodule GCounter do
    use GenServer
    def start_link(numnodes) do
        IO.puts "abc in gcounter"
        myname = String.to_atom("gcounter")
        return = {:ok, pid} = GenServer.start_link(__MODULE__, {numnodes}, name: myname )
        return
    end
    
    def init({numnodes}) do
        {:ok,{0,numnodes}}
    end

    def handle_cast(:count,_from,count)do
        {:reply,count,count+1}
    end

end