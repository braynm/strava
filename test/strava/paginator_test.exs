defmodule Strava.PaginatorTest do
  use ExUnit.Case, async: false

  test "paginate empty list" do
    stream = Strava.Paginator.stream(fn _ -> [] end)

    assert stream != nil
    assert Enum.to_list(stream) == []
  end

  test "paginate single page" do
    stream =
      Strava.Paginator.stream(
        fn pagination ->
          case pagination do
            %Strava.Pagination{page: 1} -> [1, 2, 3, 4]
            %Strava.Pagination{page: 2} -> []
            _ -> raise "should not call"
          end
        end,
        5
      )

    assert stream != nil
    assert Enum.to_list(stream) == [1, 2, 3, 4]
  end

  test "paginate exactly one page" do
    stream =
      Strava.Paginator.stream(
        fn pagination ->
          case pagination do
            %Strava.Pagination{page: 1} -> [1, 2, 3, 4, 5]
            %Strava.Pagination{page: 2} -> []
            _ -> raise "should not call"
          end
        end,
        5
      )

    assert stream != nil
    assert Enum.to_list(stream) == [1, 2, 3, 4, 5]
  end

  test "paginate two pages" do
    stream =
      Strava.Paginator.stream(
        fn pagination ->
          case pagination do
            %Strava.Pagination{page: 1} -> [1, 2, 3, 4, 5]
            %Strava.Pagination{page: 2} -> [6, 7, 8, 9]
            %Strava.Pagination{page: 3} -> []
            _ -> raise "should not call"
          end
        end,
        5
      )

    assert stream != nil
    assert Enum.to_list(stream) == [1, 2, 3, 4, 5, 6, 7, 8, 9]
  end
end
