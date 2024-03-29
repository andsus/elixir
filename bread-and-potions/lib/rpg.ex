defmodule RPG do
  defmodule Character do
    defstruct health: 100, mana: 0
  end

  defmodule LoafOfBread do
    defstruct []
  end

  defmodule ManaPotion do
    defstruct strength: 10
  end

  defmodule Poison do
    defstruct []
  end

  defmodule EmptyBottle do
    defstruct []
  end

  # Add code to define the protocol and its implementations below here...
  defprotocol Edible do
    @doc """
    Defines if an item is edible, which item is possibly returned after eaten, and
    what effect it has on the charater
    """
    def eat(item, character)

  end

  defimpl Edible, for: LoafOfBread  do
    def eat(_bread, character) do
      {nil, %RPG.Character{character | health: character.health + 5}}
    end
  end

  defimpl Edible, for: ManaPotion  do
    def eat(mana, character) do
      {%RPG.EmptyBottle{}, %RPG.Character{character | mana: character.mana + mana.strength}}
    end
  end

  defimpl Edible, for: Poison  do
    def eat(_poison, character) do
      {%RPG.EmptyBottle{}, %RPG.Character{character | health: 0}}
    end

  end
end
