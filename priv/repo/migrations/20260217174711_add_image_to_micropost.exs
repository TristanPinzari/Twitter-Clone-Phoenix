defmodule SampleApp.Repo.Migrations.AddImageToMicropost do
  use Ecto.Migration

  def change do
    alter table(:microposts) do
      add :image, :string
    end
  end
end
