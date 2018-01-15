defmodule PhoenixAndElm.Contact do
  use PhoenixAndElmWeb, :model
  alias PhoenixAndElm.Contact

  @genders [
    {0, :male},
    {1, :female}
  ]

  @derive {Poison.Encoder, except: [:__meta__, :inserted_at, :updated_at]}

  schema "contacts" do
    field :birth_date, :date
    field :email, :string
    field :first_name, :string
    field :gender, :integer
    field :headline, :string
    field :last_name, :string
    field :location, :string
    field :phone_number, :string
    field :picture, :string

    timestamps()
  end

  @doc """
  Returns genders options
  """
  def genders, do: @genders

  @doc """
  Method for search
  """
  def search(query, ""), do: query
  def search(query, search_query) do
    search_query = ts_query_format(search_query)

    query
    |> where(
      fragment(
      """
      (to_tsvector(
        'english',
        coalesce(first_name, '') || ' ' ||
        coalesce(last_name, '') || ' ' ||
        coalesce(location, '') || ' ' ||
        coalesce(headline, '') || ' ' ||
        coalesce(email, '') || ' ' ||
        coalesce(phone_number, '')
      ) @@ to_tsquery('english', ?))
      """,
      ^search_query
      )
    )
  end

  defp ts_query_format(search_query) do
    search_query
    |> String.trim
    |> String.split(" ")
    |> Enum.map(&("#{&1}:*"))
    |> Enum.join(" & ")
  end

  @doc false
  def changeset(%Contact{} = contact, attrs) do
    contact
    |> cast(attrs, [:first_name, :last_name, :gender, :birth_date, :location, :phone_number, :email, :headline, :picture])
    |> validate_required([:first_name, :last_name, :gender, :birth_date, :location, :phone_number, :email, :headline])
  end
end
