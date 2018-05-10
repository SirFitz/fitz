defmodule Store.DateTime do

  def clean_date(date) do
    date
    |> String.replace(["/","-","|"], " ")
  end

  def days, do: ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]

  def timex_directives do
    "{YYYY},{YY},{C},{WYYYY},{WYY},{M},{Mshort},{Mfull},{D},{Dord},{WDmon},{WDsun},{WDshort},{WDfull},{Wiso},{Wmon},{Wsun},{h24},{h12},{m},{s},{ss},{s-epoch},{am},{AM},{Zname},{Zabbr},{Z},{Z:},{Z::},{ISO:Basic},{ISO:Basic:Z},{ISO:Extended},{ISO:Extended:Z},{ISOdate},{ISOtime},{ISOweek},{ISOweek-day},{ISOweek},{ISOord},{ASN1:UTCtime},{ASN1:GeneralizedTime},{ASN1:GeneralizedTime:Z},{ASN1:GeneralizedTime:TZ},{RFC822},{RFC822z},{RFC1123},{RFC1123z},{RFC3339},{RFC3339z},{ANSIC},{UNIX},{ASN1:UTCtime},{ASN1:GeneralizedTime},{ASN1:GeneralizedTime:Z},{ASN1:GeneralizedTime:TZ},{kitchen},{YYYY}-{0D}-{0M}"
    |> String.split(",")
  end

  def str_directives do
    "%Y-%m-%d %H:%M::%a, %b %d, %y::%Y::%b %d, %y::%A, %b %d::%m/%d/%Y::%d/%m/%Y::%Y/%d/%m::%Y/%m/%d::%m-%e-%y %H:%M::%b %e, %l:%M %p::%B %Y::%b %d, %Y::%a, %e %b %Y %H:%M:%S %z::%Y-%m-%dT%l:%M:%S%z::%I:%M:%S %p::%H:%M:%S::%e %b %Y %H:%M:%S%p::%e %b %Y::%e %b %Y %H:%M::%d.%m.%y::%m.%d.%y::%y.%d.%m::%A, %d %b %Y %l:%M %p::%A, %d %b %Y %l:%M::%d %b %Y::%b %d, %Y::%a::%A::%b::%B::%d::%e::%H::%I::%l::%j::%m::%M::%p::%S::%w::%y::%Y::%Z::%d/%m/%Y %H:%M%p::%B %e, %Y %l:%M%p::%B %e, %Y::%%"
    |> String.split("::")
    #[[" %Y", " %Y ", "%Y ", "%Y"], [" %a", " %a ", "%a ", "%a"],
    # [" %A", " %A ", "%A ", "%A"], [" %b", " %b ", "%b ", "%b"],
    # [" %B", " %B ", "%B ", "%B"], [" %d", " %d ", "%d ", "%d"],
    # [" %e", " %e ", "%e ", "%e"], [" %H", " %H ", "%H ", "%H"],
    # [" %I", " %I ", "%I ", "%I"], [" %l", " %l ", "%l ", "%l"],
    # [" %j", " %j ", "%j ", "%j"], [" %m", " %m ", "%m ", "%m"],
    # [" %M", " %M ", "%M ", "%M"], [" %p", " %p ", "%p ", "%p"],
    # [" %S", " %S ", "%S ", "%S"], [" %w", " %w ", "%w ", "%w"],
    # [" %y", " %y ", "%y ", "%y"], [" %Y", " %Y ", "%Y ", "%Y"],
    # [" %Z", " %Z ", "%Z ", "%Z"], [" ", "  ", " ", ""]]
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
              format = Enum.find(str_directives, fn(x) ->
              case Timex.parse(datetime, x,  :strftime) do
                  {:ok, time} ->
                    true
                  {:error, reason} ->
                    false
                end
              end)

              Timex.parse(datetime, format, :strftime)

        "{WDfull}" ->
              next_day(datetime)
          _ ->
              Timex.parse(datetime, format)
        end

  end

  def next_day(day) do
    day =
      cond do
        is_bitstring(day) ->
          day
        is_integer(day) ->
          Enum.at(days, day)
        true ->
          "Sunday"
      end
    day = Timex.day_to_num(day)

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
