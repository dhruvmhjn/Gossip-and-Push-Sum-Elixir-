defmodule Boss do
    def main(args) do 
        parse_args(args)
    end
    defp parse_args(args) do
        cmdarg = OptionParser.parse(args)
        {[],[numNodes,topology,algorithm],[]} = cmdarg
        numInt = String.to_integer(numNodes)

        Process.register(self(),:boss)
        
        #Code to Round OFF
        numInt = cond do
            (topology == "2D") -> round(:math.pow(Float.ceil(:math.sqrt(numInt)),2))
            (topology =="imp2D") -> round(:math.pow(Float.ceil(:math.sqrt(numInt)),2))
            true -> numInt
        end

        if topology == "2D" || topology =="imp2D" do
            IO.puts "Rounded off. Starting 2D grid with #{numInt} Nodes." 
        end
        
        ApplicationSupervisor.start_link([numInt,topology,algorithm])

        #sleep the main process
        
        
        # IO.puts "foo";
        # :timer.sleep(1000)
        # IO.puts "bar"


       
        boss_receiver("string",topology)
    end
            
    def boss_receiver(k,topology) do
        receive do
            {:hello, cpid} ->
                send cpid, {:k_valmsg, k}
            {:topology_created, _} ->
               IO.puts "boss gets the get go"
                if topology == "line" || topology =="full" do
                    GenServer.cast(:node1, {:rumour, rstring})
                end
                if topology == "2D" || topology =="imp2D" do
                    GenServer.cast(:node11, {:rumour, rstring})
                end        
        end
        boss_receiver(k,topology)
    end
end
        
