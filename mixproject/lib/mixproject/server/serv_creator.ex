defmodule Server.TheCreator do
  import Plug.Conn

  @doc false
  defmacro __using__(_opts) do
    quote do
      import Server.TheCreator

      # Initialize @tests to an empty list
      @routes []

      @error_code 404
      @error_content "Go away, you are not welcome here"

      # Invoke TestCase.__before_compile__/1 before the module is compiled
      @before_compile Server.TheCreator
    end
  end

  defmacro my_get(path, do: block) do
    funcname = String.to_atom(path)
    quote do
      def unquote(funcname)() do
        unquote(block)
      end
      @routes [unquote(funcname) | @routes]
    end
  end

  defmacro my_error([_code, _content]) do
    # IO.inspect elem(code,1)
    # IO.inspect elem(content,1)
    # Module.delete_attribute(Server.TheCreator, :error_code)
    # Module.set_attribute(Server.TheCreator, :error_code, elem(code, 1))
    quote do

    end
  end

  #This will be invoked right before the target module is compiled
  defmacro __before_compile__(_env) do
    quote do
      def init(options) do
        # initialize options
        options
      end

      def call(conn, _opts) do
        Enum.each @routes, fn name ->
          if (name == String.to_existing_atom(conn.request_path)) do
            {code, message} = apply(__MODULE__, name, [])
            send_resp(conn, code, message)
          end
        end
          # Enum.each @routes, fn name ->
          #   IO.puts "test"
          #   if (name == String.to_existing_atom(conn.request_path)) do
          #     {code, message} = apply(__MODULE__, name, [])
          #     send_resp(conn, code, message)
          #   end
          # end
          # send_resp(conn, 404, "ERROR")
          # IO.puts "END"
        end

      end
    end
  end
