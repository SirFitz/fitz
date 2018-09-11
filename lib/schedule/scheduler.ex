defmodule Fitz.Schedule do
  use Timex

  def validate_params(params) do
    params =
      Map.new
      |> Map.put(:interval, (Map.get(params, :interval) || "days"))
      |> Map.put(:from_date, (Map.get(params, :from_date) || Timex.format(Timex.now, "{YYYY}-{0M}-{0D}")))
      |> Map.put(:period, (Map.get(params, :period) || 7))
      |> Map.put(:hours, (Map.get(params, :hours) || 8))
      |> Map.put(:minutes, (Map.get(params, :minutes) || 30))
      |> Map.put(:timezone, (Map.get(params, :timezone) || "UTC"))
      |> Map.put(:schedule, (Map.get(params, :schedule || %{week_day: nil, interval: "1"})))
      |> Map.put(:step, (Map.get(params, :step) || "1"))
  end

  def days_interval(params) do
    today = Timex.today |> Timex.to_naive_datetime
    params.from_date
    #IO.inspect from_date = Timex.today |> Timex.to_naive_datetime |>
    from_date = params.from_date |> Timex.shift(hours: params.hours, minutes: params.minutes)
    from_date = from_date |> timezone_converter(params.timezone)
    period = String.to_integer(params.period) - 1
    if Timex.before?(from_date, Timex.now |> timezone_converter(params.timezone)) do
      from_date = Timex.today |> Timex.to_naive_datetime |> Timex.shift(hours: params.hours, minutes: params.minutes)
    else
      from_date = from_date
    end

    list =
        Interval.new(from: from_date, until: [days: period], right_open: false)
        |> Interval.with_step([days: String.to_integer(params.step)])
        #|> Enum.map(fn (x) -> Timex.shift(x, hours: params.hours, minutes: params.minutes) end)
        |>  Enum.map(&Timex.format!(&1, "%Y-%m-%d %H:%M", :strftime))
    #list = list -- [Enum.at(list, 0)]

  end

  def weeks_interval(params) do
    weekday = params.schedule.week_day
    today = Timex.today
    from_date =
	 if weekday == nil || weekday == "" do
       from_date = params.from_date
     else
       weekday = params.schedule.week_day
       if Timex.weekday(params.from_date) > weekday do
          int = weekday - Timex.weekday(params.from_date) + 7
          params.from_date
           from_date =
            Interval.new(from: params.from_date, until: [days: int], right_open: false)
            |> Map.get(:until)
       else
         params.weekday
         Timex.weekday(today)
         int = weekday - Timex.weekday(today)
         from_date =
          Interval.new(from: today, until: [days: int], right_open: false)
          |> Map.get(:until)
       end
     end

     from_date = from_date |> timezone_converter(params.timezone)
     from_date
     ndate = from_date |> Timex.shift(hours: params.hours, minutes: params.minutes)
     if Timex.before?(ndate, Timex.now) do
       from_date = from_date |> Timex.shift(days: 7)
     end
     #= from_date |> Timex.shift(days: -7), to account for the current week maybe?
    list =
        Timex.Interval.new(from: from_date, until: [weeks: String.to_integer(params.period)], right_open: false)
        |> Timex.Interval.with_step([weeks: String.to_integer(params.step)])
        |> Enum.map(fn (x) -> Timex.shift(x, hours: params.hours, minutes: params.minutes)
        |> Timex.format!("%Y-%m-%d %H:%M", :strftime) end)
    list = list -- [List.last(list)]

  end

  def months_interval(params) do
    day_of_month = params.day

    if day_of_month == nil or day_of_month == "" do
      day_of_month =
          params.from_date |> Timex.format!("%d" , :strftime)
    end

    day_of_month = day_of_month |> String.to_integer


    if day_of_month > 28 do

      from_date = Timex.beginning_of_month(Timex.today)
      from_date = from_date |> timezone_converter(params.timezone)


      day = String.to_integer(params.day)
      from_date = from_date |> Timex.shift(days: day)
      findate = from_date |> Timex.shift(days: -1, hours: params.hours, minutes: params.minutes)
      if Timex.before?(findate, Timex.now) do
        from_date = from_date |> Timex.shift(months: 1)
      end
      prelist =
        Interval.new(from: from_date, until: [months: String.to_integer(params.period)], right_open: false)
        |> Interval.with_step([months: String.to_integer(params.step)])
      list =
        for x <- prelist do
          #x =
          #if Timex.days_in_month(x) < day_of_month do
          #  Timex.end_of_month(x) |> Timex.shift(hours: 23, minutes: 59)
            # end of month function sets it to 11:59pm
            # we need the beginning of the day so we can shift later
          #else
          #  Timex.shift(x, days: day_of_month - 1)
            #subtract 1 because the shift doesn't count the existing date
          #end
          Timex.shift(x, days: -1, hours: params.hours, minutes: params.minutes)
          |> Timex.format!("%Y-%m-%d %H:%M", :strftime)
        end

    else

      from_date = Timex.beginning_of_month(params.from_date) |> Timex.shift(days: day_of_month - 1)
      from_date = from_date |> timezone_converter(params.timezone)

      if Timex.before?(from_date, Timex.today) do
        from_date = from_date |> Timex.shift(months: 1)
      end
      list =
          Interval.new(from: from_date, until: [months: String.to_integer(params.period)], right_open: false)
          |> Interval.with_step([months: String.to_integer(params.step)])
          |> Enum.map(fn (x) -> Timex.shift(x, hours: params.hours, minutes: params.minutes)
          |> Timex.format!("%Y-%m-%d %H:%M", :strftime) end)

    end
          list = list -- [List.last(list)]

  end

  def make(params) do
      params = validate_params(params)
      interval = params.interval
      from_date =  params.from_date

      if from_date == nil || from_date == "" do
        from_date = Timex.today |> Timex.to_naive_datetime
        date = from_date |> String.split(["-"])
        day = Enum.at(date, 0)
        month = Enum.at(date, 1)
        year = Enum.at(date, 2)
      else
        date = from_date |> String.split(["-"])
        day = Enum.at(date, 0)
        month = Enum.at(date, 1)
        year = Enum.at(date, 2)
        {:ok, from_date} = Timex.parse(from_date, "{0D}-{0M}-{YYYY}")
      end

      params =
        params
        |> Map.put(:day, day)
        |> Map.put(:month, month)
        |> Map.put(:year, year)
        |> Map.put(:from_date, from_date)

      list =
         case interval do
          "days" ->
            days_interval(params)
          "weeks" ->
            weeks_interval(params)
          "months" ->
            months_interval(params)
         end


  end



  def map_to_atom(map) do
     newmap = for {key, val} <- map, into: %{}, do: {String.to_atom(key), val}
  end

  def map_to_string(map) do
     newmap = for {key, val} <- map, into: %{}, do: {Atom.to_string(key), val}
  end

  def date_converter(list) do
    list = Enum.map(list, fn(date) ->
      month = date |> DateTime.to_string |> String.split("-") |> Enum.at(1) |> String.to_integer |> Timex.month_name
      day = date |> DateTime.to_string |> String.split(["-", " "]) |> Enum.at(2)
      year = date |> DateTime.to_string |> String.split(["-", " "]) |> Enum.at(0)
      hour = date |> DateTime.to_string |> String.split(["-", " ", "."]) |> Enum.at(3) |> String.split(":") |> Enum.at(0) |> String.to_integer
      minute = date |> DateTime.to_string |> String.split(["-", " ", "."]) |> Enum.at(3) |> String.split(":") |> Enum.at(1)
      if hour > 12 do
        hour = hour - 12
        time = ([hour, minute] |> Enum.join(":")) <> "pm"
      else
        time = ([hour, minute] |> Enum.join(":")) <> "am"
      end
      date = month <> " " <> day <> ", " <> year <> " @ " <> time
    end)
    list = list |> Enum.join("<br/>")
  end


  def get_time(time) do

      hours = String.split(time, ":") |> Enum.at(0) |> String.to_integer
      minutes = String.split(time, ":") |> Enum.at(1) |> String.slice(0, 2) |> String.to_integer
      tod = String.split(time, ":") |> Enum.at(1) |> String.slice(2, 4)
      if tod == "PM" do
        hours = hours + 12
      end

      time = [hours, minutes]
  end



  def timezone_converter(datetime, timezone) do

    ntz = Timex.Timezone.get(timezone)
    datetime = datetime |> Timex.to_datetime
    offset = Timex.Timezone.total_offset(ntz) /60 /60
    hours = offset
            |> Float.to_string
            |> String.split(".")
            |> Enum.at(0)
            |> String.to_integer
    minutes = ( hours - offset ) * 60 + 0.0
            |> Float.round
            |> Float.to_string
            |> String.split(".")
            |> Enum.at(0)
            |> String.to_integer
    #converts integer to float, or keeps existing float, we need a float to convert properly to an integer/whole number for the shift function
    time = Timex.shift(datetime, hours: -(hours), minutes: minutes)

  end

  def timezone_reconverter(datetime, timezone) do


    ntz = Timex.Timezone.get(timezone)
    datetime = datetime |> Timex.to_datetime
    offset = Timex.Timezone.total_offset(ntz) /60 /60
    hours = offset
            |> Float.to_string
            |> String.split(".")
            |> Enum.at(0)
            |> String.to_integer
    minutes = ( hours - offset ) * 60 + 0.0
            |> Float.round
            |> Float.to_string
            |> String.split(".")
            |> Enum.at(0)
            |> String.to_integer
    #converts integer to float, or keeps existing float, we need a float to convert properly to an integer/whole number for the shift function
    time = Timex.shift(datetime, hours: (hours), minutes: minutes)

  end

end
