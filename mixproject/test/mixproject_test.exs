defmodule MixprojectTest do
  use ExUnit.Case
  doctest Mixproject

  test "greets the world" do
    assert Mixproject.hello() == :world
  end
end
