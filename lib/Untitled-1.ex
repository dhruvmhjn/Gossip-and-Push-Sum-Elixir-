

def handle_cast({:spreadrumour,rsrting},{n,list,localcount,top})do
    #Random neighbour call
    #Code For fukk
    len_neb = length(list)
    name_neb = cond do
        len_neb == 0 -> String.to_atom("node#{:rand.uniform(n)}")
        true -> Enum.at(list,(:rand.uniform(len_neb)-1))
    end


    #GenServer.cast()
    :timer.sleep(100)
    if localcount <= 10 do
      GenServer.cast(self(), {:spreadrumour,rsrting})
    end
    #GenServer.cast(self(), {:spreadrumour,rsrting})
    {:noreply,{n,list,localcount,top}}
  end