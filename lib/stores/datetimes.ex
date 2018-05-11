defmodule Store.DateTime do

  def clean_date(date) do
    date
    |> String.replace(["/","-","|","  "], " ")
    |> String.trim
  end

  def days, do: ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]

  def timex_directives do
    "{YYYY},{YY},{C},{WYYYY},{WYY},{M},{Mshort},{Mfull},{D},{Dord},{WDmon},{WDsun},{WDshort},{WDfull},{Wiso},{Wmon},{Wsun},{h24},{h12},{m},{s},{ss},{s-epoch},{am},{AM},{Zname},{Zabbr},{Z},{Z:},{Z::},{ISO:Basic},{ISO:Basic:Z},{ISO:Extended},{ISO:Extended:Z},{ISOdate},{ISOtime},{ISOweek},{ISOweek-day},{ISOweek},{ISOord},{ASN1:UTCtime},{ASN1:GeneralizedTime},{ASN1:GeneralizedTime:Z},{ASN1:GeneralizedTime:TZ},{RFC822},{RFC822z},{RFC1123},{RFC1123z},{RFC3339},{RFC3339z},{ANSIC},{UNIX},{ASN1:UTCtime},{ASN1:GeneralizedTime},{ASN1:GeneralizedTime:Z},{ASN1:GeneralizedTime:TZ},{kitchen},{YYYY}-{0D}-{0M}"
    |> String.split(",")
  end

  def str_directives do
    "%Y-%m-%d %H:%M::%a, %b %d, %y::%Y::%b %d, %y::%A, %b %d::%m/%d/%Y::%d/%m/%Y::%Y/%d/%m::%Y/%m/%d::%m-%e-%y %H:%M::%b %e, %l:%M %p::%B %Y::%b %d, %Y::%a, %e %b %Y %H:%M:%S %z::%Y-%m-%dT%l:%M:%S%z::%I:%M:%S %p::%H:%M:%S::%e %b %Y %H:%M:%S%p::%e %b %Y::%e %b %Y %H:%M::%d.%m.%y::%m.%d.%y::%y.%d.%m::%A, %d %b %Y %l:%M %p::%A, %d %b %Y %l:%M::%d %b %Y::%b %d, %Y::%a::%A::%b::%B::%d::%e::%H::%I::%l::%j::%m::%M::%p::%S::%w::%y::%Y::%Z::%d/%m/%Y %H:%M%p::%B %e, %Y %l:%M%p::%B %e, %Y::%d/%m/%Y at %H:%M::%d/%m/%Y %H:%M::%d %m %Y::%d %m %Y at %H:%M::%d %m %Y at %H:%M%p::%d %m %Y at %H:%M %p::%%"
    |> String.split("::")
  end

  def test(datetime) do
    list = timex_directives |> Enum.reverse
    format =
      Enum.find(list , fn(x) ->
        case Timex.parse(datetime, x) do
          {:ok, time} ->
            true
          {:error, reason} ->
            false
        end
      end)

      IO.inspect format

      case format do
        nil ->
              datetime = clean_date(datetime)
              format =
                Enum.find(str_directives, fn(x) ->
                        case Timex.parse(datetime, x,  :strftime) do
                            {:ok, time} ->
                              true
                            {:error, reason} ->
                              false
                          end
                        end)
              IO.puts "NIL FORM"
              IO.inspect datetime
              IO.inspect format
              case format do
                nil ->
                  date = next_day(datetime)
                _ ->
                  Timex.parse(datetime, format, :strftime)
              end
        "{WDfull}" ->
              date = next_day(datetime)
              test(date)
          _ ->
              Timex.parse(datetime, format)
        end

  end

  def check_last(a) do
    i =
      a
      |> String.reverse
      |> Integer.parse
    case i do
      :error ->
        a
      {int, rest} ->
        s = "0#{int}:00"
        String.replace(a, "#{int}", s)
    end
  end

  def next_day(day_init) do
    day_name =
      cond do
        is_bitstring(day_init) ->
          list = String.split(day_init, " ")
          d =
            Enum.filter(list, fn(x)-> Enum.member?(Store.DateTime.days, x) end)
            |> List.first
          case d do
            nil ->
              num =
                Timex.now
                |> Timex.weekday

              (num - 1) |> Timex.day_name
            _ ->
              d
          end
        is_integer(day_init) ->
          Enum.at(days, day_init)
        true ->
          num =
            Timex.now
            |> Timex.weekday
          (num - 1) |> Timex.day_name
      end
    day = Timex.day_to_num(day_name)

    today = Timex.now

    tday =
      Timex.weekday(Timex.now)

    tday = if tday == 7 do 0 else tday end

    date =
      if day > tday do
        Timex.shift(today, days: (day - tday))
      else
        Timex.shift(today, days: (7 - tday + day))
      end

    {:ok, d} = Timex.format(date, "%d/%m/%Y", :strftime)
    IO.inspect result = String.replace(day_init, day_name, d)
    result =
      case String.contains?(result, ":") do
        true ->
          s = result |> String.split([" "])  |> Enum.filter(fn(x)-> String.contains?(x,":") end)  |> List.first
          fin =
            s
            |> String.split(":")
            |> Enum.map(fn(x)-> if String.length(x) < 2 do "0" <> x else x end end)
            |> Enum.join(":")
          String.replace(result, s, fin)
        false ->
          result
        end
  end

  def parallel(start, fin) do
    vals = Enum.chunk_every(str_directives, 10)
       Enum.map(vals, fn(x)->
         spawn(__MODULE__, :save_to_file, [x])
      end)
  end

  def save_to_file(list) do
    path = "/Users/romario/Desktop/#{Timex.now |> Timex.to_gregorian_microseconds}"
    result = list |> Combination.permutate |> Enum.join(",")
    File.write(path, result)
  end

end
