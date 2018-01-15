defmodule PhoenixAndElmWeb.ContactController do
  use PhoenixAndElmWeb, :controller

  alias PhoenixAndElm.Contact

  def index(conn, params) do
    search = Map.get(params, "search", "")

    page = Contact
      |> Contact.search(search)
      |> order_by(desc: :first_name)
      |> PhoenixAndElm.Repo.paginate(params)

    render conn, page: page
  end
end
