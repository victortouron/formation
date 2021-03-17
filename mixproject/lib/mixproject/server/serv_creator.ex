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

  defmacro my_error([code, content]) do
    error_code = elem(code,1)
    error_content = elem(content,1)
    quote do
      @error_code unquote(error_code)
      @error_content unquote(error_content)
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
        route =  Enum.find(@routes, fn name ->
          name == String.to_atom(conn.request_path)
        end)
        case route do
          nil -> send_resp(conn, @error_code, @error_content)
          _ ->
          {code, message} = apply(__MODULE__, route, [])
          send_resp(conn, code, message)
        end
      end
    end
  end
end
