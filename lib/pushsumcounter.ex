defmodule PushsumCounter do
    use GenServer
    def start_link(numnodes) do
        myname = String.to_atom("pcounter")
        return = GenServer.start_link(__MODULE__, {numnodes}, name: myname )
        return
    end
    
    def init({numnodes}) do
        truesum = (numnodes*(numnodes + 1))/2
        {:ok,{0,numnodes,truesum}}
    end

    def handle_cast({:sumreport,computedsum},{count,numnodes,truesum})do
        #IO.puts "#{count} node terminated, AVG: #{computedsum}"
        #if newcount == numnodes do
        b = System.system_time(:millisecond)
        IO.puts "AVG: #{computedsum} Computed, Terminating."
        send(Process.whereis(:boss),{:sumcomputed,b})   
        #end
        {:noreply,{count,numnodes,truesum}}
    end

end