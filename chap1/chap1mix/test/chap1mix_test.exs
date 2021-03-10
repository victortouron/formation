defmodule Chap1mixTest do
  use ExUnit.Case
  doctest Chap1mix

  test "greets the world" do
    assert Chap1mix.hello() == :world
  end
end
