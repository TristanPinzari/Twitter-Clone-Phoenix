defmodule SampleApp.Posts do
  @moduledoc """
  The Posts context.
  """

  import Ecto.Query, warn: false
  alias SampleApp.Repo

  alias SampleApp.Posts.Micropost

  @doc """
  Returns the list of microposts.

  ## Examples

      iex> list_microposts()
      [%Micropost{}, ...]

  """
  def list_microposts(params \\ %{}) do
    page = String.to_integer(params["page"] || "1")
    per_page = 10
    offset = (page - 1) * per_page

    Micropost
    |> order_by(desc: :id)
    |> limit(^per_page)
    |> offset(^offset)
    |> Repo.all()
  end

  def count_microposts() do
    Repo.aggregate(Micropost, :count, :id)
  end

  @doc """
  Gets a single micropost.

  Raises `Ecto.NoResultsError` if the Micropost does not exist.

  ## Examples

      iex> get_micropost!(123)
      %Micropost{}

      iex> get_micropost!(456)
      ** (Ecto.NoResultsError)

  """
  def get_micropost!(id), do: Repo.get!(Micropost, id)

  @doc """
  Creates a micropost.

  ## Examples

      iex> create_micropost(%{field: value})
      {:ok, %Micropost{}}

      iex> create_micropost(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_micropost(attrs, user) do
    micropost_transaction =
      Ecto.Multi.new()
      |> Ecto.Multi.run(:assoc, fn _repo, _change ->
        micropost =
          Ecto.build_assoc(user, :microposts)
          |> Repo.preload(:user)

        {:ok, micropost}
      end)
      |> Ecto.Multi.insert(
        :micropost,
        &Micropost.changeset(&1.assoc, attrs)
      )
      |> Ecto.Multi.update(
        :micropost_with_image,
        &Micropost.image_changeset(&1.micropost, attrs)
      )
      |> Repo.transaction()

    case micropost_transaction do
      {:ok, result} ->
        {:ok, result.micropost}

      {:error, :micropost, changeset, _changes} ->
        {:error, changeset}

      {:error, :micropost_with_image, changeset, _changes} ->
        {:error, changeset}
    end
  end

  @doc """
  Updates a micropost.

  ## Examples

      iex> update_micropost(micropost, %{field: new_value})
      {:ok, %Micropost{}}

      iex> update_micropost(micropost, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_micropost(%Micropost{} = micropost, attrs) do
    micropost
    |> Micropost.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a micropost.

  ## Examples

      iex> delete_micropost(micropost)
      {:ok, %Micropost{}}

      iex> delete_micropost(micropost)
      {:error, %Ecto.Changeset{}}

  """
  def delete_micropost(%{micropost_id: micropost_id_str, user_id: user_id}) do
    micropost_id = String.to_integer(micropost_id_str)

    found_micropost =
      Repo.one(
        from m in Micropost,
          where: m.user_id == ^user_id and ^micropost_id == m.id
      )

    case found_micropost do
      nil ->
        nil

      _ ->
        Repo.delete(found_micropost)
    end
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking micropost changes.

  ## Examples

      iex> change_micropost(micropost)
      %Ecto.Changeset{data: %Micropost{}}

  """
  def change_micropost(%Micropost{} = micropost, attrs \\ %{}) do
    Micropost.changeset(micropost, attrs)
  end
end
