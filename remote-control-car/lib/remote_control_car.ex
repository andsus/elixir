defmodule RemoteControlCar do
  @enforce_keys [:nickname]
  defstruct [:nickname, battery_percentage: 100, distance_driven_in_meters: 0]

  def new(nickname \\ "none") do
    %RemoteControlCar{nickname: nickname}
  end

  def display_distance(%RemoteControlCar{distance_driven_in_meters: meters}) do
    "#{meters} meters"
  end

  def display_battery(%RemoteControlCar{battery_percentage: percent}) do
    case percent do
      0 -> "Battery empty"
      _ -> "Battery at #{percent}%"
    end
  end

  def drive(%RemoteControlCar{battery_percentage: 0} = remote_car), do: remote_car
  def drive(%RemoteControlCar{} = remote_car) do
    remote_car
    |> Map.update!(:battery_percentage, &(&1 - 1))
    |> Map.update!(:distance_driven_in_meters, &(&1 + 20))
  end
end
