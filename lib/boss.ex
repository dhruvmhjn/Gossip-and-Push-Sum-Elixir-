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
            (topology == "2D") || (topology =="imp2D") -> round(:math.pow(Float.ceil(:math.sqrt(numInt)),2))
            true -> numInt
        end
        
        ApplicationSupervisor.start_link([numInt,topology,algorithm])
        boss_receiver(topology,nil)
    end
            
    def boss_receiver(topology,a) do
        receive do
            {:rumourpropogated,b} ->
                IO.puts "Time in MilliSeconds: #{b-a}"
                :init.stop
            {:topology_created} ->
                rstring = "This is the first rumour"
                IO.puts "Network is created"
                #rstring = "This is the first rumour"
                a = System.system_time(:millisecond)
                if topology == "line" || topology =="full" do
                    GenServer.cast(:node1, {:rumour, rstring})
                end
                if topology == "2D" || topology =="imp2D" do
                    GenServer.cast(:node1@1, {:rumour, rstring})
                end        
            
        end
        boss_receiver(topology,a)
    end
end