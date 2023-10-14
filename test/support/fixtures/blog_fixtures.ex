defmodule Blogex.BlogFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Blogex.Blog` context.
  """

  @doc """
  Generate a article.
  """
  def article_fixture(attrs \\ %{}) do
    {:ok, article} =
      attrs
      |> Enum.into(%{
        body: "some body",
        title: "some title"
      })
      |> Blogex.Blog.create_article()

    article
  end
end
