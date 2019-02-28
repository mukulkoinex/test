defmodule TestWeb.EventsController do
	use TestWeb, :controller

	def push(conn, %{"value" => value}) do
		push_queue(value)
		json(conn, %{"message" => "#{value} successfully pushed"})
	end

	def pop(conn, _params) do
		with {nil, _} <- pop_queue() do
			json(conn, %{"message" => "Queue empty", "data" => ""})
		else 
			{value, _} -> json(conn, %{"message" => "Queue successfully popped", "data" => value})
		end
	end
	
	def push_queue(value) do
		GenServer.cast(Test.PQ, {:push, value}) # Sends message to the queue genserver to push value.
	end

	def pop_queue() do
		GenServer.call(Test.PQ, {:pop}) # Sends message to pop value  
	end
end