# from optparse import OptionParser
# ...
# parser = OptionParser()
# parser.add_option("-f", "--file", dest="filename",
#                   help="write report to FILE", metavar="FILE")
# parser.add_option("-q", "--quiet",
#                   action="store_false", dest="verbose", default=True,
#                   help="don't print status messages to stdout")
# (options, args) = parser.parse_args()

defmodule Market do

  def read_file(file) do
    {:ok, text} = File.read(file)
    text
  end

  def transform(file) do
    [header | list] = read_file(file)
                      |> String.split("\n", trim: true)
                      |> Enum.map(fn row -> String.split(row, " ", trim: true) end)
    Enum.map(list, fn(row) ->
      Enum.zip(header, row)
      |> Enum.into(%{})
    end)
  end

  def get_top_3_change_percent(file) do
    transform(file)
    |> Enum.sort_by(&(Map.get(&1, "changePercent")
    |>String.to_float()
    |>abs
    ), :desc)
    |> Enum.slice(0..2)
    |> Enum.map(fn(record) -> Map.get(record, "currencyPair") end)
  end
end
