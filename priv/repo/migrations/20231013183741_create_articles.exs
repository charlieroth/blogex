defmodule Blogex.Repo.Migrations.CreateArticles do
  use Ecto.Migration

  def change do
    create table(:articles) do
      add :title, :text
      add :body, :text

      timestamps(type: :utc_datetime)
    end
  end
end
