defmodule Boss do
    def main(args) do 
        parse_args(args)
    end
    defp parse_args(args) do
        cmdarg = OptionParser.parse(args)
        {[],[numNodes,topology,algorithm],[]} = cmdarg
        numInt = String.to_integer(numNodes)
        #IO.puts "#{inspect(self)}"
        Process.register(self(),:boss)
        
        #Code to Round OFF
        numInt = cond do
            (topology == "2D") -> round(:math.pow(Float.ceil(:math.sqrt(numInt)),2))
                                    #IO.puts "Rounded off. Starting 2D grid with #{numInt} Nodes." 
            (topology =="imp2D") -> round(:math.pow(Float.ceil(:math.sqrt(numInt)),2))
                                   # IO.puts "Rounded off. Starting imp2D grid with #{numInt} Nodes." 
            true -> numInt
        end
        
        ApplicationSupervisor.start_link([numInt,topology,algorithm])

        #sleep the main process
        
        
        # IO.puts "foo";
        # :timer.sleep(1000)
        # IO.puts "bar"


       
        boss_receiver("string",topology,nil)
    end
            
    def boss_receiver(k,topology,a) do
        receive do
            {:rumourpropogated,b} ->
                IO.puts b-a
                :init.stop
            {:topology_created} ->
                rstring = "This is the first rumour"
                IO.puts "Network is created"
                #rstring = "This is the first rumour"
                IO.puts a = System.system_time(:millisecond)
                if topology == "line" || topology =="full" do
                    GenServer.cast(:node1, {:rumour, rstring})
                end
                if topology == "2D" || topology =="imp2D" do
                    GenServer.cast(:node11, {:rumour, rstring})
                end        
            
        end
        boss_receiver(k,topology,a)
    end
end
        
