defmodule SampleApp.Posts.Micropost do
  use Ecto.Schema
  use Waffle.Ecto.Schema
  import Ecto.Changeset
  alias SampleApp.Accounts.User

  schema "microposts" do
    field :content, :string
    field :image, SampleApp.Image.Type
    belongs_to :user, User

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(micropost, attrs) do
    micropost
    |> cast(attrs, [:content, :image])
    |> validate_required([:content, :user_id], message: "Required field")
    |> validate_length(:content, max: 280)
  end

  def image_changeset(micropost, attrs) do
    micropost
    |> cast_attachments(attrs, [:image])
  end
end
